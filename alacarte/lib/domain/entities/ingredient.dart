import 'package:equatable/equatable.dart';

/// [Ingredient] é a entidade que representa um ingrediente genérico no sistema.
/// Contém informações sobre o ingrediente, como nome, categoria e imagem.
class Ingredient extends Equatable {
  final String id;
  final String name;
  final String? category;
  final String? imageUrl;
  final Map<String, String>? alternativeMeasurements;
  final List<String>? commonSubstitutes;

  const Ingredient({
    required this.id,
    required this.name,
    this.category,
    this.imageUrl,
    this.alternativeMeasurements,
    this.commonSubstitutes,
  });

  /// Cria uma cópia do objeto com os valores especificados substituídos
  Ingredient copyWith({
    String? id,
    String? name,
    String? category,
    String? imageUrl,
    Map<String, String>? alternativeMeasurements,
    List<String>? commonSubstitutes,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      alternativeMeasurements: alternativeMeasurements ?? this.alternativeMeasurements,
      commonSubstitutes: commonSubstitutes ?? this.commonSubstitutes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        imageUrl,
        alternativeMeasurements,
        commonSubstitutes,
      ];
}

/// [RecipeIngredient] representa um ingrediente no contexto específico de uma receita.
/// Inclui informações sobre quantidade e unidade de medida.
class RecipeIngredient extends Equatable {
  final String name;
  final double quantity;
  final String unit;
  final String? notes;

  const RecipeIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
    this.notes,
  });

  /// Cria uma cópia do objeto com os valores especificados substituídos
  RecipeIngredient copyWith({
    String? name,
    double? quantity,
    String? unit,
    String? notes,
  }) {
    return RecipeIngredient(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [name, quantity, unit, notes];
}