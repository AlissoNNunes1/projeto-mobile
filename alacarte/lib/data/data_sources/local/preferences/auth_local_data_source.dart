import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../../../models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Salva os dados do usuário no armazenamento local
  Future<void> cacheUser(UserModel user);
  
  /// Obtém os dados do usuário do armazenamento local
  Future<UserModel?> getLastUser();
  
  /// Remove os dados do usuário do armazenamento local
  Future<void> clearUser();
  
  /// Salva o token de autenticação
  Future<void> saveAuthToken(String token);
  
  /// Obtém o token de autenticação
  Future<String?> getAuthToken();
  
  /// Remove o token de autenticação
  Future<void> clearAuthToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  
  // Chaves para o armazenamento
  static const _userKey = 'cached_user';
  static const _tokenKey = 'auth_token';
  
  AuthLocalDataSourceImpl({
    required this.secureStorage,
  });
  
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await secureStorage.write(key: _userKey, value: userJson);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao armazenar dados do usuário: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<UserModel?> getLastUser() async {
    try {
      final userJson = await secureStorage.read(key: _userKey);
      
      if (userJson == null) {
        return null;
      }
      
      return UserModel.fromJson(json.decode(userJson));
    } catch (e) {
      throw CacheException(
        message: 'Falha ao recuperar dados do usuário: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> clearUser() async {
    try {
      await secureStorage.delete(key: _userKey);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao remover dados do usuário: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> saveAuthToken(String token) async {
    try {
      await secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao armazenar token: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<String?> getAuthToken() async {
    try {
      return await secureStorage.read(key: _tokenKey);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao recuperar token: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> clearAuthToken() async {
    try {
      await secureStorage.delete(key: _tokenKey);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao remover token: ${e.toString()}',
      );
    }
  }
}
