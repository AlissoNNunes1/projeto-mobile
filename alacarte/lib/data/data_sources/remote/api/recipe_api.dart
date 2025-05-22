import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../models/recipe_model.dart';

abstract class RecipeApi {
  /// Busca receitas sugeridas com base nos ingredientes fornecidos
  Future<List<RecipeModel>> getSuggestedRecipes({
    required List<String> ingredients,
    Map<String, dynamic>? preferences,
  });
  
  /// Busca os detalhes de uma receita específica
  Future<RecipeModel> getRecipeById(String id);
  
  /// Busca receitas por texto
  Future<List<RecipeModel>> searchRecipes(String query);
}

class RecipeApiImpl implements RecipeApi {
  final ApiClient apiClient;
  
  RecipeApiImpl({
    required this.apiClient,
  });
  
  @override
  Future<List<RecipeModel>> getSuggestedRecipes({
    required List<String> ingredients,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final response = await apiClient.post(
        '/api/recipes/suggest',
        data: {
          'ingredients': ingredients,
          'preferences': preferences,
        },
      );
      
      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Erro ao buscar receitas: ${response.statusCode}',
        );
      }
      
      final List<dynamic> recipeList = response.data['data'] ?? [];
      
      return recipeList
          .map((json) => RecipeModel.fromJson(json))
          .toList();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Erro ao buscar receitas sugeridas: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<RecipeModel> getRecipeById(String id) async {
    try {
      final response = await apiClient.get('/api/recipes/$id');
      
      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Erro ao buscar receita: ${response.statusCode}',
        );
      }
      
      return RecipeModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Erro ao buscar detalhes da receita: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final response = await apiClient.get(
        '/api/recipes/search',
        queryParameters: {'q': query},
      );
      
      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Erro ao buscar receitas: ${response.statusCode}',
        );
      }
      
      final List<dynamic> recipeList = response.data['data'] ?? [];
      
      return recipeList
          .map((json) => RecipeModel.fromJson(json))
          .toList();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Erro ao buscar receitas: ${e.toString()}',
      );
    }
  }
}
