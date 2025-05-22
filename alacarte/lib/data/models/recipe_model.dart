import '../../domain/entities/recipe.dart';
import '../../domain/entities/ingredient.dart';

/// [RecipeModel] é a implementação concreta da entidade [Recipe].
/// Estende a entidade e adiciona métodos para conversão de/para JSON.
class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.title,
    required super.description,
    super.imageUrl,
    required super.prepTime,
    required super.cookTime,
    required super.servings,
    super.difficulty,
    required super.ingredients,
    required super.steps,
    super.nutrition,
    super.tags,
    super.rating,
    super.ratingCount,
    super.sourceId,
    required super.createdAt,
  });

  /// Cria um [RecipeModel] a partir de um mapa JSON.
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      prepTime: json['prepTime'] ?? 0,
      cookTime: json['cookTime'] ?? 0,
      servings: json['servings'] ?? 2,
      difficulty: json['difficulty'] ?? 'medium',
      ingredients: json['ingredients'] != null
          ? List<RecipeIngredient>.from(
              json['ingredients'].map(
                (i) => RecipeIngredientModel.fromJson(i),
              ),
            )
          : [],
      steps: json['steps'] != null ? List<String>.from(json['steps']) : [],
      nutrition: json['nutrition'] ?? {},
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      rating: (json['rating'] ?? 0.0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
      sourceId: json['sourceId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
  /// Converte o modelo para um mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'difficulty': difficulty,
      'ingredients': ingredients.map((i) {
        if (i is RecipeIngredientModel) {
          return i.toJson();
        } else {
          return {
            'name': i.name,
            'quantity': i.quantity,
            'unit': i.unit,
            'notes': i.notes,
          };
        }
      }).toList(),
      'steps': steps,
      'nutrition': nutrition,
      'tags': tags,
      'rating': rating,
      'ratingCount': ratingCount,
      'sourceId': sourceId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  /// Cria uma cópia do objeto com os valores especificados substituídos
  @override
  RecipeModel copyWith({
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
    return RecipeModel(
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
}

/// [RecipeIngredientModel] é a implementação concreta da entidade [RecipeIngredient].
class RecipeIngredientModel extends RecipeIngredient {
  const RecipeIngredientModel({
    required super.name,
    required super.quantity,
    required super.unit,
    super.notes,
  });

  /// Cria um [RecipeIngredientModel] a partir de um mapa JSON.
  factory RecipeIngredientModel.fromJson(Map<String, dynamic> json) {
    double parsedQuantity;
    if (json['quantity'] is String) {
      parsedQuantity = double.tryParse(json['quantity'] ?? '') ?? 0.0;
    } else {
      parsedQuantity = (json['quantity'] ?? 0.0).toDouble();
    }
    
    return RecipeIngredientModel(
      name: json['name'] ?? '',
      quantity: parsedQuantity,
      unit: json['unit'] ?? '',
      notes: json['notes'],
    );
  }
  /// Converte o modelo para um mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'notes': notes,
    };
  }
  
  /// Cria uma cópia do objeto com os valores especificados substituídos
  @override
  RecipeIngredientModel copyWith({
    String? name,
    double? quantity,
    String? unit,
    String? notes,
  }) {
    return RecipeIngredientModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
    );
  }
}