import 'package:dartz/dartz.dart';
import '../entities/recipe.dart';
import '../../core/error/failures.dart';

/// [RecipeRepository] define os métodos para operações relacionadas a receitas.
/// Interface seguindo o princípio de Inversão de Dependência (SOLID).
abstract class RecipeRepository {
  /// Busca receitas sugeridas com base nos ingredientes fornecidos.
  Future<Either<Failure, List<Recipe>>> getSuggestedRecipes({
    required List<String> ingredients,
    Map<String, dynamic>? preferences,
  });
  
  /// Busca os detalhes de uma receita específica.
  Future<Either<Failure, Recipe>> getRecipeById(String id);
  
  /// Busca receitas por texto de busca.
  Future<Either<Failure, List<Recipe>>> searchRecipes(String query);
  
  /// Obtém as receitas favoritas do usuário.
  Future<Either<Failure, List<Recipe>>> getFavoriteRecipes();
  
  /// Adiciona uma receita aos favoritos.
  Future<Either<Failure, void>> addToFavorites(String recipeId);
  
  /// Remove uma receita dos favoritos.
  Future<Either<Failure, void>> removeFromFavorites(String recipeId);
  
  /// Verifica se uma receita está nos favoritos.
  Future<Either<Failure, bool>> isFavorite(String recipeId);
  
  /// Obtém o histórico de receitas visualizadas.
  Future<Either<Failure, List<Recipe>>> getRecipeHistory();
  
  /// Adiciona uma receita ao histórico.
  Future<Either<Failure, void>> addToHistory(String recipeId);
  
  /// Limpa o histórico de receitas.
  Future<Either<Failure, void>> clearHistory();
}