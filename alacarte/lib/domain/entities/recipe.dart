// lib/domain/entities/recipe.dart
import 'package:equatable/equatable.dart';
import 'ingredient.dart';

/// [Recipe] é a entidade que representa uma receita completa.
/// Contém todas as informações necessárias para exibir e preparar uma receita.
class Recipe extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int prepTime;    // Tempo de preparo em minutos
  final int cookTime;    // Tempo de cozimento em minutos
  final int servings;    // Número de porções
  final String difficulty; // Nível de dificuldade (fácil, médio, difícil)
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final Map<String, dynamic> nutrition;
  final List<String> tags;
  final double rating;
  final int ratingCount;
  final String? sourceId;
  final DateTime createdAt;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    this.difficulty = 'medium',
    required this.ingredients,
    required this.steps,
    this.nutrition = const {},
    this.tags = const [],
    this.rating = 0.0,
    this.ratingCount = 0,
    this.sourceId,
    required this.createdAt,
  });

  /// Retorna o tempo total de preparo (preparo + cozimento)
  int get totalTime => prepTime + cookTime;

  /// Cria uma receita vazia para exibição enquanto carrega
  factory Recipe.empty() => Recipe(
        id: '',
        title: '',
        description: '',
        prepTime: 0,
        cookTime: 0,
        servings: 0,
        ingredients: const [],
        steps: const [],
        createdAt: DateTime.now(),
      );

  /// Cria uma cópia do objeto com os valores especificados substituídos
  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? prepTime,
    int? cookTime,
    int? servings,
    String? difficulty,
    List<RecipeIngredient>? ingredients,
    List<String>? steps,
    Map<String, dynamic>? nutrition,
    List<String>? tags,
    double? rating,
    int? ratingCount,
    String? sourceId,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      nutrition: nutrition ?? this.nutrition,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      sourceId: sourceId ?? this.sourceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        prepTime,
        cookTime,
        servings,
        difficulty,
        ingredients,
        steps,
        nutrition,
        tags,
        rating,
        ratingCount,
        sourceId,
        createdAt,
      ];
}