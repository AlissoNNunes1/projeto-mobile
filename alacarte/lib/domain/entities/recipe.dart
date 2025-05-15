// lib/domain/entities/recipe.dart
import 'package:equatable/equatable.dart';
import 'ingredient.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final String imageUrl;
  final int preparationTime;
  final int servings;
  final double rating;
  
  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    this.imageUrl = '',
    required this.preparationTime,
    required this.servings,
    this.rating = 0,
  });
  
  @override
  List<Object> get props => [id, title, ingredients];
}