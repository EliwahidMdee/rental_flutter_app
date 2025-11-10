/// Custom Exceptions
/// 
/// Defines all custom exception types used throughout the app

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  ApiException(this.message, [this.statusCode]);
  
  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class ServerException extends ApiException {
  ServerException(super.message, [super.statusCode]);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message, 403);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, 404);
}

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message, 400);
}

class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;
  
  ValidationException(String message, {this.errors}) : super(message, 422);
}

class CacheException implements Exception {
  final String message;
  
  CacheException(this.message);
  
  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  
  AuthException(this.message);
  
  @override
  String toString() => message;
}
