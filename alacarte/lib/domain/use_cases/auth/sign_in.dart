import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Use case para realizar login de usuário com email e senha.
class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  /// Executa o caso de uso.
  /// 
  /// Recebe [email] e [password] e retorna um [Either] contendo
  /// um [Failure] em caso de erro ou um [User] com os dados do usuário logado.
  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    // Validação básica de email e senha
    if (email.isEmpty) {
      return const Left(ValidationFailure(message: 'Email não pode ser vazio'));
    }
    
    if (password.isEmpty) {
      return const Left(ValidationFailure(message: 'Senha não pode ser vazia'));
    }
    
    // Executa a operação no repositório
    return await repository.signIn(email: email, password: password);
  }
}
