import '../../domain/entities/user.dart';

/// [UserModel] é a implementação concreta da entidade [User].
/// Estende a entidade e adiciona métodos para conversão de/para JSON.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    List<String>? dietaryRestrictions,
    Map<String, dynamic>? preferences,
  }) : super(
          dietaryRestrictions: dietaryRestrictions,
          preferences: preferences,
        );
  
  /// Cria um [UserModel] a partir de um mapa JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      dietaryRestrictions: json['dietaryRestrictions'] != null
          ? List<String>.from(json['dietaryRestrictions'])
          : null,
      preferences: json['preferences'],
    );
  }
  
  /// Cria um [UserModel] a partir de um usuário do Firebase Auth.
  factory UserModel.fromFirebase(dynamic firebaseUser, Map<String, dynamic>? userData) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName ?? userData?['displayName'],
      photoUrl: firebaseUser.photoURL ?? userData?['photoUrl'],
      dietaryRestrictions: userData?['dietaryRestrictions'] != null
          ? List<String>.from(userData!['dietaryRestrictions'])
          : null,
      preferences: userData?['preferences'],
    );
  }
  
  /// Converte o modelo para um mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'dietaryRestrictions': dietaryRestrictions,
      'preferences': preferences,
    };
  }
  
  /// Cria uma cópia do objeto com os valores especificados substituídos
  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    List<String>? dietaryRestrictions,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      preferences: preferences ?? this.preferences,
    );
  }
}