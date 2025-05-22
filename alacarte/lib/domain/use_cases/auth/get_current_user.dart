import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Use case para obter o usuário atualmente autenticado.
class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  /// Executa o caso de uso.
  /// 
  /// Retorna um [Either] contendo um [Failure] em caso de erro
  /// ou um [User] com os dados do usuário atual.
  Future<Either<Failure, User>> call() async {
    return await repository.getCurrentUser();
  }
}
