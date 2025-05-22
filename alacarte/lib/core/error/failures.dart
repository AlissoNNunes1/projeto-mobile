import 'package:equatable/equatable.dart';

/// [Failure] é a classe base abstrata para todas as falhas na aplicação.
/// Usada para representar erros de domínio de forma consistente.
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Falha de servidor (API, Firebase, etc.)
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Ocorreu um erro no servidor',
    super.code,
  });
}

/// Falha de cache (SharedPreferences, SQLite, etc.)
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Erro ao acessar dados locais',
    super.code,
  });
}

/// Falha de rede (sem conexão, timeout, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Sem conexão com a Internet',
    super.code,
  });
}

/// Falha de autenticação (credenciais inválidas, token expirado, etc.)
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Erro de autenticação',
    super.code,
  });
}

/// Falha de validação (entrada inválida, formato incorreto, etc.)
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Dados inválidos',
    super.code,
  });
}

/// Falha desconhecida (erro não categorizado)
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Ocorreu um erro desconhecido',
    super.code,
  });
}
