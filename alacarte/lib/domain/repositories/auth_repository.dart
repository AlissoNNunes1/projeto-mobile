import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/error/failures.dart';

/// [AuthRepository] define os métodos para autenticação de usuários.
/// Interface seguindo o princípio de Inversão de Dependência (SOLID).
abstract class AuthRepository {
  /// Retorna o usuário atual autenticado, ou null se não houver.
  Future<Either<Failure, User>> getCurrentUser();
  
  /// Registra um novo usuário com email e senha.
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    String? displayName,
  });
  
  /// Autentica um usuário existente com email e senha.
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });
  
  /// Realiza o logout do usuário atual.
  Future<Either<Failure, void>> signOut();
  
  /// Envia um email de redefinição de senha.
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  
  /// Verifica se o email já está em uso.
  Future<Either<Failure, bool>> isEmailInUse(String email);
  
  /// Atualiza o perfil do usuário.
  Future<Either<Failure, User>> updateProfile({
    String? displayName,
    String? photoUrl,
  });
  
  /// Atualiza as preferências do usuário.
  Future<Either<Failure, User>> updateUserPreferences({
    List<String>? dietaryRestrictions,
    Map<String, dynamic>? preferences,
  });
}