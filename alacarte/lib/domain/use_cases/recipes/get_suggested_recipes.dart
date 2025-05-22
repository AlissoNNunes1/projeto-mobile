// lib/domain/use_cases/recipes/get_suggested_recipes.dart
import 'package:dartz/dartz.dart';
import '../../entities/recipe.dart';
import '../../repositories/recipe_repository.dart';
import '../../../core/error/failures.dart';

/// Use case para obter receitas recomendadas com base em ingredientes.
class GetSuggestedRecipes {
  final RecipeRepository repository;
  
  GetSuggestedRecipes(this.repository);
  
  /// Executa o caso de uso.
  /// 
  /// Recebe uma lista de [ingredients] e opcionalmente [preferences] do usuário.
  /// Retorna um [Either] contendo um [Failure] em caso de erro
  /// ou uma [List<Recipe>] com as receitas recomendadas.
  Future<Either<Failure, List<Recipe>>> call({
    required List<String> ingredients,
    Map<String, dynamic>? preferences,
  }) async {
    // Validação básica
    if (ingredients.isEmpty) {
      return const Left(ValidationFailure(
        message: 'É necessário fornecer pelo menos um ingrediente',
      ));
    }
    
    // Remove espaços em branco e valores vazios
    final cleanedIngredients = ingredients
        .map((ingredient) => ingredient.trim())
        .where((ingredient) => ingredient.isNotEmpty)
        .toList();
    
    if (cleanedIngredients.isEmpty) {
      return const Left(ValidationFailure(
        message: 'É necessário fornecer pelo menos um ingrediente válido',
      ));
    }
    
    // Executa a operação no repositório
    return await repository.getSuggestedRecipes(
      ingredients: cleanedIngredients,
      preferences: preferences,
    );
  }
}