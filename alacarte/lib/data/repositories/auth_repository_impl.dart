import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../data_sources/remote/firebase/firebase_auth_data_source.dart';
import '../../data_sources/local/preferences/auth_local_data_source.dart';
import '../../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Tenta obter o usuário do Firebase primeiro
      final remoteUser = await remoteDataSource.getCurrentUser();

      if (remoteUser != null) {
        // Se encontrou o usuário remoto, atualiza o cache
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      }

      // Se não houver usuário autenticado remotamente, tenta obter do cache
      final localUser = await localDataSource.getLastUser();

      if (localUser != null) {
        return Right(localUser);
      }

      // Não há usuário autenticado
      return const Left(AuthFailure(
        message: 'Nenhum usuário autenticado',
      ));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao obter usuário atual: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Sem conexão com a internet',
      ));
    }

    try {
      final user = await remoteDataSource.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );

      // Armazena o usuário localmente
      await localDataSource.cacheUser(user);

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao cadastrar usuário: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Sem conexão com a internet',
      ));
    }

    try {
      final user = await remoteDataSource.signIn(
        email: email,
        password: password,
      );

      // Armazena o usuário localmente
      await localDataSource.cacheUser(user);

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao fazer login: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();

      // Remove usuário do armazenamento local
      await localDataSource.clearUser();
      await localDataSource.clearAuthToken();

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao fazer logout: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Sem conexão com a internet',
      ));
    }

    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao enviar email de redefinição: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailInUse(String email) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Sem conexão com a internet',
      ));
    }

    try {
      final isInUse = await remoteDataSource.isEmailInUse(email);
      return Right(isInUse);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao verificar email: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Sem conexão com a internet',
      ));
    }

    try {
      final user = await remoteDataSource.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );

      // Atualiza o cache
      await localDataSource.cacheUser(user);

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao atualizar perfil: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserPreferences({
    List<String>? dietaryRestrictions,
    Map<String, dynamic>? preferences,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Sem conexão com a internet',
      ));
    }

    try {
      final user = await remoteDataSource.updateUserPreferences(
        dietaryRestrictions: dietaryRestrictions,
        preferences: preferences,
      );

      // Atualiza o cache
      await localDataSource.cacheUser(user);

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao atualizar preferências: ${e.toString()}',
      ));
    }
  }
}