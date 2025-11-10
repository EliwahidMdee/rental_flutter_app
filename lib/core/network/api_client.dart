import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../config/app_config.dart';
import '../storage/secure_storage.dart';
import '../errors/exceptions.dart';

/// API Client
/// 
/// Handles all HTTP requests to the backend API with authentication,
/// error handling, and request/response interceptors.

class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();
  
  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: AppConfig.defaultHeaders,
      ),
    );
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authentication token
          final token = await SecureStorage.getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          if (AppConfig.enableLogging) {
            _logger.d('REQUEST[${options.method}] => ${options.path}');
            _logger.d('Headers: ${options.headers}');
            if (options.data != null) {
              _logger.d('Data: ${options.data}');
            }
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (AppConfig.enableLogging) {
            _logger.i('RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (AppConfig.enableLogging) {
            _logger.e(
              'ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}',
            );
            _logger.e('Message: ${error.message}');
          }
          
          // Handle token expiration
          if (error.response?.statusCode == 401) {
            await SecureStorage.clearAll();
            // TODO: Trigger navigation to login
          }
          
          return handler.next(error);
        },
      ),
    );
    
    // Retry interceptor for network failures
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            // Retry once for timeout errors
            try {
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
  
  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Upload file
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (data != null) ...data,
      });
      
      return await _dio.post<T>(
        path,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Download file
  Future<Response> downloadFile(
    String path,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.download(
        path,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Handle Dio errors
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');
        
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
        
      case DioExceptionType.cancel:
        return ApiException('Request cancelled');
        
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
        
      default:
        return ApiException('An unexpected error occurred: ${error.message}');
    }
  }
  
  /// Handle HTTP response errors
  ApiException _handleResponseError(Response? response) {
    if (response == null) {
      return ApiException('Unknown error occurred');
    }
    
    final statusCode = response.statusCode ?? 0;
    final message = response.data?['message'] ?? response.statusMessage ?? 'Unknown error';
    
    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 422:
        return ValidationException(
          message,
          errors: response.data?['errors'] as Map<String, dynamic>?,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(message);
      default:
        return ApiException(message);
    }
  }
}
