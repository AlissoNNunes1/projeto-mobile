import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../models/recipe_model.dart';

abstract class RecipeLocalDataSource {
  /// Salva uma lista de receitas no cache
  Future<void> cacheRecipes(List<RecipeModel> recipes, String cacheKey);
  
  /// Recupera receitas do cache
  Future<List<RecipeModel>> getCachedRecipes(String cacheKey);
  
  /// Salva uma receita específica no cache
  Future<void> cacheRecipe(RecipeModel recipe);
  
  /// Recupera uma receita específica do cache
  Future<RecipeModel?> getCachedRecipe(String id);
  
  /// Salva as receitas favoritas do usuário
  Future<void> cacheFavorites(List<String> recipeIds);
  
  /// Recupera as receitas favoritas do usuário
  Future<List<String>> getCachedFavorites();
  
  /// Adiciona um ID de receita às favoritas
  Future<void> addToFavorites(String recipeId);
  
  /// Remove um ID de receita das favoritas
  Future<void> removeFromFavorites(String recipeId);
  
  /// Verifica se uma receita está nos favoritos
  Future<bool> isFavorite(String recipeId);
  
  /// Salva o histórico de receitas visualizadas
  Future<void> cacheHistory(List<String> recipeIds);
  
  /// Recupera o histórico de receitas visualizadas
  Future<List<String>> getCachedHistory();
  
  /// Adiciona um ID de receita ao histórico
  Future<void> addToHistory(String recipeId);
  
  /// Limpa o histórico de receitas
  Future<void> clearHistory();
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  // Chaves para o armazenamento
  static const _recipePrefix = 'cached_recipe_';
  static const _favoritesKey = 'favorite_recipes';
  static const _historyKey = 'history_recipes';
  
  RecipeLocalDataSourceImpl({
    required this.sharedPreferences,
  });
  
  @override
  Future<void> cacheRecipes(List<RecipeModel> recipes, String cacheKey) async {
    try {
      final List<Map<String, dynamic>> jsonList = 
          recipes.map((recipe) => recipe.toJson()).toList();
      
      await sharedPreferences.setString(
        cacheKey,
        json.encode(jsonList),
      );
      
      // Armazena cada receita individualmente também
      for (var recipe in recipes) {
        await cacheRecipe(recipe);
      }
    } catch (e) {
      throw CacheException(
        message: 'Falha ao armazenar receitas: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<List<RecipeModel>> getCachedRecipes(String cacheKey) async {
    try {
      final jsonString = sharedPreferences.getString(cacheKey);
      
      if (jsonString == null) {
        throw CacheException(
          message: 'Nenhuma receita em cache',
        );
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      
      return jsonList
          .map((json) => RecipeModel.fromJson(json))
          .toList();
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException(
        message: 'Falha ao recuperar receitas do cache: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> cacheRecipe(RecipeModel recipe) async {
    try {
      await sharedPreferences.setString(
        _recipePrefix + recipe.id,
        json.encode(recipe.toJson()),
      );
    } catch (e) {
      throw CacheException(
        message: 'Falha ao armazenar receita: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<RecipeModel?> getCachedRecipe(String id) async {
    try {
      final jsonString = sharedPreferences.getString(_recipePrefix + id);
      
      if (jsonString == null) {
        return null;
      }
      
      return RecipeModel.fromJson(json.decode(jsonString));
    } catch (e) {
      throw CacheException(
        message: 'Falha ao recuperar receita do cache: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> cacheFavorites(List<String> recipeIds) async {
    try {
      await sharedPreferences.setStringList(_favoritesKey, recipeIds);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao armazenar favoritos: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<List<String>> getCachedFavorites() async {
    try {
      return sharedPreferences.getStringList(_favoritesKey) ?? [];
    } catch (e) {
      throw CacheException(
        message: 'Falha ao recuperar favoritos: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> addToFavorites(String recipeId) async {
    try {
      final favorites = await getCachedFavorites();
      
      if (!favorites.contains(recipeId)) {
        favorites.add(recipeId);
        await cacheFavorites(favorites);
      }
    } catch (e) {
      throw CacheException(
        message: 'Falha ao adicionar aos favoritos: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> removeFromFavorites(String recipeId) async {
    try {
      final favorites = await getCachedFavorites();
      
      favorites.remove(recipeId);
      await cacheFavorites(favorites);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao remover dos favoritos: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<bool> isFavorite(String recipeId) async {
    try {
      final favorites = await getCachedFavorites();
      return favorites.contains(recipeId);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao verificar favorito: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> cacheHistory(List<String> recipeIds) async {
    try {
      await sharedPreferences.setStringList(_historyKey, recipeIds);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao armazenar histórico: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<List<String>> getCachedHistory() async {
    try {
      return sharedPreferences.getStringList(_historyKey) ?? [];
    } catch (e) {
      throw CacheException(
        message: 'Falha ao recuperar histórico: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> addToHistory(String recipeId) async {
    try {
      final history = await getCachedHistory();
      
      // Remove se já existe para reordenar
      history.remove(recipeId);
      
      // Adiciona no início da lista (mais recente)
      history.insert(0, recipeId);
      
      // Limita a 50 itens no histórico
      if (history.length > 50) {
        history.removeLast();
      }
      
      await cacheHistory(history);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao adicionar ao histórico: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> clearHistory() async {
    try {
      await sharedPreferences.remove(_historyKey);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao limpar histórico: ${e.toString()}',
      );
    }
  }
}
