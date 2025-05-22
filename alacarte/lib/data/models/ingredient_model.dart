import '../../domain/entities/ingredient.dart';

/// [IngredientModel] é a implementação concreta da entidade [Ingredient].
/// Estende a entidade e adiciona métodos para conversão de/para JSON.
class IngredientModel extends Ingredient {
  const IngredientModel({
    required super.id,
    required super.name,
    super.category,
    super.imageUrl,
    super.alternativeMeasurements,
    super.commonSubstitutes,
  });

  /// Cria um [IngredientModel] a partir de um mapa JSON.
  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'],
      imageUrl: json['imageUrl'],
      alternativeMeasurements: json['alternativeMeasurements'] != null
          ? Map<String, String>.from(json['alternativeMeasurements'])
          : null,
      commonSubstitutes: json['commonSubstitutes'] != null
          ? List<String>.from(json['commonSubstitutes'])
          : null,
    );
  }

  /// Converte o modelo para um mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'alternativeMeasurements': alternativeMeasurements,
      'commonSubstitutes': commonSubstitutes,
    };
  }

  /// Cria uma cópia do objeto com os valores especificados substituídos
  @override
  IngredientModel copyWith({
    String? id,
    String? name,
    String? category,
    String? imageUrl,
    Map<String, String>? alternativeMeasurements,
    List<String>? commonSubstitutes,
  }) {
    return IngredientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      alternativeMeasurements: alternativeMeasurements ?? this.alternativeMeasurements,
      commonSubstitutes: commonSubstitutes ?? this.commonSubstitutes,
    );
  }
}