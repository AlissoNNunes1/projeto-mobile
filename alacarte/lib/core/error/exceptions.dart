/// [AppException] é a classe base para todas as exceções específicas da aplicação.
/// Usada para representar erros que ocorrem durante a execução.
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic stackTrace;

  AppException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: [$code] $message';
}

/// Erro de servidor (API, Firebase, etc.)
class ServerException extends AppException {
  ServerException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Erro de cache (SharedPreferences, SQLite, etc.)
class CacheException extends AppException {
  CacheException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Erro de rede (sem conexão, timeout, etc.)
class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Erro de autenticação (credenciais inválidas, token expirado, etc.)
class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Erro de validação (entrada inválida, formato incorreto, etc.)
class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}
