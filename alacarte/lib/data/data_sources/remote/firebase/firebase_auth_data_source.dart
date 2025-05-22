import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/error/exceptions.dart';
import '';

abstract class FirebaseAuthDataSource {
  /// Obtém o usuário atualmente autenticado
  Future<UserModel?> getCurrentUser();
  
  /// Registra um novo usuário com email e senha
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
  });
  
  /// Autentica um usuário existente com email e senha
  Future<UserModel> signIn({
    required String email,
    required String password,
  });
  
  /// Realiza o logout do usuário atual
  Future<void> signOut();
  
  /// Envia um email de redefinição de senha
  Future<void> sendPasswordResetEmail(String email);
  
  /// Verifica se o email já está em uso
  Future<bool> isEmailInUse(String email);
  
  /// Atualiza o perfil do usuário
  Future<UserModel> updateProfile({
    String? displayName,
    String? photoUrl,
  });
  
  /// Atualiza as preferências do usuário
  Future<UserModel> updateUserPreferences({
    List<String>? dietaryRestrictions,
    Map<String, dynamic>? preferences,
  });
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  
  FirebaseAuthDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });
  
  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    
    if (user == null) {
      return null;
    }
    
    try {
      // Obtém dados adicionais do usuário do Firestore
      final userDoc = await firestore
          .collection('users')
          .doc(user.uid)
          .get();
          
      return UserModel.fromFirebase(user, userDoc.data());
    } catch (e) {
      // Se não conseguir obter dados do Firestore, retorna apenas com os dados do Auth
      return UserModel.fromFirebase(user, null);
    }
  }
  
  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Cria o usuário no Firebase Auth
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      
      if (user == null) {
        throw const ServerException(
          message: 'Erro ao criar usuário, user is null',
        );
      }
      
      // Atualiza o displayName se fornecido
      if (displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
      }
      
      // Cria o documento do usuário no Firestore
      final userData = {
        'id': user.uid,
        'email': email,
        'displayName': displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'dietaryRestrictions': [],
        'preferences': {},
      };
      
      await firestore
          .collection('users')
          .doc(user.uid)
          .set(userData);
      
      // Recarrega o usuário para obter as informações atualizadas
      await user.reload();
      final refreshedUser = firebaseAuth.currentUser;
      
      return UserModel.fromFirebase(refreshedUser!, userData);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(
        message: 'Erro ao criar usuário: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      
      if (user == null) {
        throw const ServerException(
          message: 'Erro ao fazer login, user is null',
        );
      }
      
      // Obtém dados adicionais do usuário do Firestore
      final userDoc = await firestore
          .collection('users')
          .doc(user.uid)
          .get();
          
      return UserModel.fromFirebase(user, userDoc.data());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(
        message: 'Erro ao fazer login: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(
        message: 'Erro ao fazer logout: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(
        message: 'Erro ao enviar email de redefinição: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<bool> isEmailInUse(String email) async {
    try {
      final methods = await firebaseAuth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Se não encontrou o email, significa que não está em uso
      if (e.code == 'user-not-found') {
        return false;
      }
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(
        message: 'Erro ao verificar email: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<UserModel> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = firebaseAuth.currentUser;
      
      if (user == null) {
        throw const AuthException(
          message: 'Nenhum usuário autenticado',
        );
      }
      
      // Atualiza o perfil no Firebase Auth
      if (displayName != null || photoUrl != null) {
        await user.updateDisplayName(displayName);
        
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }
      }
      
      // Atualiza os dados no Firestore
      final userData = <String, dynamic>{};
      
      if (displayName != null) {
        userData['displayName'] = displayName;
      }
      
      if (photoUrl != null) {
        userData['photoUrl'] = photoUrl;
      }
      
      if (userData.isNotEmpty) {
        await firestore
            .collection('users')
            .doc(user.uid)
            .update(userData);
      }
      
      // Recarrega o usuário para obter as informações atualizadas
      await user.reload();
      final refreshedUser = firebaseAuth.currentUser;
      
      // Obtém dados completos do Firestore
      final userDoc = await firestore
          .collection('users')
          .doc(refreshedUser!.uid)
          .get();
          
      return UserModel.fromFirebase(refreshedUser, userDoc.data());
    } catch (e) {
      throw ServerException(
        message: 'Erro ao atualizar perfil: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<UserModel> updateUserPreferences({
    List<String>? dietaryRestrictions,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final user = firebaseAuth.currentUser;
      
      if (user == null) {
        throw const AuthException(
          message: 'Nenhum usuário autenticado',
        );
      }
      
      // Atualiza as preferências no Firestore
      final userData = <String, dynamic>{};
      
      if (dietaryRestrictions != null) {
        userData['dietaryRestrictions'] = dietaryRestrictions;
      }
      
      if (preferences != null) {
        userData['preferences'] = preferences;
      }
      
      if (userData.isNotEmpty) {
        await firestore
            .collection('users')
            .doc(user.uid)
            .update(userData);
      }
      
      // Obtém dados completos do Firestore
      final userDoc = await firestore
          .collection('users')
          .doc(user.uid)
          .get();
          
      return UserModel.fromFirebase(user, userDoc.data());
    } catch (e) {
      throw ServerException(
        message: 'Erro ao atualizar preferências: ${e.toString()}',
      );
    }
  }
  
  /// Método auxiliar para tratar exceções do Firebase Auth
  Exception _handleFirebaseAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthException(
          message: 'Usuário não encontrado',
        );
      case 'wrong-password':
        return const AuthException(
          message: 'Senha incorreta',
        );
      case 'email-already-in-use':
        return const AuthException(
          message: 'Este email já está em uso',
        );
      case 'weak-password':
        return const AuthException(
          message: 'A senha é muito fraca',
        );
      case 'invalid-email':
        return const AuthException(
          message: 'Email inválido',
        );
      case 'operation-not-allowed':
        return const AuthException(
          message: 'Operação não permitida',
        );
      case 'user-disabled':
        return const AuthException(
          message: 'Este usuário foi desativado',
        );
      case 'too-many-requests':
        return const AuthException(
          message: 'Muitas tentativas. Tente novamente mais tarde',
        );
      case 'network-request-failed':
        return const NetworkException(
          message: 'Erro de conexão. Verifique sua internet',
        );
      default:
        return AuthException(
          message: 'Erro de autenticação: ${e.message}',
        );
    }
  }
}
