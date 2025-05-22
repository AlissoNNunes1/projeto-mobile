import 'package:equatable/equatable.dart';

/// [User] é a entidade que representa um usuário autenticado no sistema.
/// Contém informações básicas do usuário e suas preferências.
class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final List<String> dietaryRestrictions;
  final Map<String, dynamic> preferences;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.dietaryRestrictions = const [],
    this.preferences = const {},
  });

  /// Cria uma instância de [User] sem dados (usuário não autenticado)
  factory User.empty() => User(
        id: '',
        email: '',
        createdAt: DateTime.now(),
      );

  /// Verifica se o usuário está autenticado
  bool get isAuthenticated => id.isNotEmpty;

  /// Cria uma cópia do objeto com os valores especificados substituídos
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    List<String>? dietaryRestrictions,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        createdAt,
        dietaryRestrictions,
        preferences,
      ];
}