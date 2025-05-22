import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Use case para cadastrar um novo usuário com email e senha.
class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  /// Executa o caso de uso.
  /// 
  /// Recebe [email], [password] e opcionalmente [displayName].
  /// Retorna um [Either] contendo um [Failure] em caso de erro
  /// ou um [User] com os dados do usuário cadastrado.
  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // Validação de email
    if (email.isEmpty) {
      return const Left(ValidationFailure(message: 'Email não pode ser vazio'));
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return const Left(ValidationFailure(message: 'Email inválido'));
    }
    
    // Validação de senha
    if (password.isEmpty) {
      return const Left(ValidationFailure(message: 'Senha não pode ser vazia'));
    }
    
    if (password.length < 6) {
      return const Left(ValidationFailure(message: 'A senha deve ter pelo menos 6 caracteres'));
    }
    
    // Verificar se o email já está em uso
    final emailInUseResult = await repository.isEmailInUse(email);
    
    return emailInUseResult.fold(
      (failure) => Left(failure),
      (isInUse) {
        if (isInUse) {
          return const Left(ValidationFailure(message: 'Este email já está em uso'));
        }
        
        // Executa o cadastro no repositório
        return repository.signUp(
          email: email, 
          password: password,
          displayName: displayName,
        );
      },
    );
  }
}
