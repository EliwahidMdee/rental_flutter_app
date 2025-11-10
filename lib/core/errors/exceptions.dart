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
  UnauthorizedException(super.message) : super(401);
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message) : super(403);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message) : super(404);
}

class BadRequestException extends ApiException {
  BadRequestException(super.message) : super(400);
}

class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;
  
  ValidationException(super.message, {this.errors}) : super(422);
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
