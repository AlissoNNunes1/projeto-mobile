import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

/// Use case para fazer logout do usuário atual.
class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  /// Executa o caso de uso.
  /// 
  /// Retorna um [Either] contendo um [Failure] em caso de erro
  /// ou [void] em caso de sucesso.
  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}
