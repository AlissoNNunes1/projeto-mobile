import 'dart:convert';
import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import '../../app/constants.dart';

/// [ApiClient] é responsável por realizar as requisições HTTP para a API.
/// Encapsula o Dio e gerencia erros, autenticação e serialização/deserialização.
class ApiClient {
  final Dio dio;

  ApiClient({
    required this.dio,
  }) {
    _configureDio();
  }

  /// Configura o cliente Dio com interceptores, timeout, etc.
  void _configureDio() {
    dio.options.baseUrl = AppConstants.apiBaseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Interceptor para logging (apenas em modo debug)
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    // Interceptor para manipulação de erros
    dio.interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        // Lança a exceção personalizada para ser capturada nos métodos públicos
        throw _handleError(e);
      },
    ));
  }

  /// Configura o token de autenticação para as requisições
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove o token de autenticação
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }

  /// Realiza uma requisição GET
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Realiza uma requisição POST
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Realiza uma requisição PUT
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Realiza uma requisição DELETE
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Processa a resposta da API
  dynamic _processResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        return response.data;
      default:
        throw ServerException(
          message: 'Resposta inesperada: ${response.statusCode}',
          code: response.statusCode.toString(),
        );
    }
  }

  /// Converte erros do Dio em exceções da aplicação
  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Timeout na conexão com o servidor',
          code: 'TIMEOUT',
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.badResponse:
        return _handleResponseError(error);
      case DioExceptionType.cancel:
        return ServerException(
          message: 'Requisição cancelada',
          code: 'REQUEST_CANCELLED',
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException') ||
            error.error.toString().contains('Network is unreachable')) {
          return NetworkException(
            message: 'Sem conexão com a Internet',
            code: 'NO_INTERNET',
            stackTrace: error.stackTrace,
          );
        }
        return ServerException(
          message: 'Erro desconhecido: ${error.message}',
          code: 'UNKNOWN',
          stackTrace: error.stackTrace,
        );
      default:
        return ServerException(
          message: 'Erro na requisição: ${error.message}',
          code: 'SERVER_ERROR',
          stackTrace: error.stackTrace,
        );
    }
  }

  /// Processa erros específicos de resposta HTTP
  AppException _handleResponseError(DioException error) {
    final int? statusCode = error.response?.statusCode;
    final dynamic data = error.response?.data;
    String message = 'Erro desconhecido';
    String code = statusCode?.toString() ?? 'UNKNOWN';

    if (data != null) {
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['error'] ?? message;
        code = data['code'] ?? code;
      } else if (data is String) {
        try {
          final Map<String, dynamic> jsonData = json.decode(data);
          message = jsonData['message'] ?? jsonData['error'] ?? message;
          code = jsonData['code'] ?? code;
        } catch (_) {
          message = data;
        }
      }
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message,
          code: code,
          stackTrace: error.stackTrace,
        );
      case 401:
      case 403:
        return AuthException(
          message: message,
          code: code,
          stackTrace: error.stackTrace,
        );
      case 404:
        return ServerException(
          message: 'Recurso não encontrado',
          code: code,
          stackTrace: error.stackTrace,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(
          message: 'Erro no servidor',
          code: code,
          stackTrace: error.stackTrace,
        );
      default:
        return ServerException(
          message: message,
          code: code,
          stackTrace: error.stackTrace,
        );
    }
  }
}
