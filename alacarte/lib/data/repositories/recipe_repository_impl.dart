// lib/data/repositories/recipe_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../data_sources/remote/api/recipe_api.dart';
import '../data_sources/local/database/recipe_local_data_source.dart';
import '../../../core/network/network_info.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeApi remoteDataSource;
  final RecipeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  // Chaves para caching
  static const String _suggestedRecipesKey = 'suggested_recipes';
  static const String _searchRecipesKey = 'search_recipes_';
  
  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Recipe>>> getSuggestedRecipes({
    required List<String> ingredients,
    Map<String, dynamic>? preferences,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // Busca receitas da API
        final recipes = await remoteDataSource.getSuggestedRecipes(
          ingredients: ingredients,
          preferences: preferences,
        );

        // Armazena no cache
        await localDataSource.cacheRecipes(recipes, _suggestedRecipesKey);

        return Right(recipes);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(
          message: 'Erro ao buscar receitas sugeridas: ${e.toString()}',
        ));
      }
    } else {
      // Sem conexão, tenta buscar do cache
      try {
        final cachedRecipes = 
            await localDataSource.getCachedRecipes(_suggestedRecipesKey);
        return Right(cachedRecipes);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        return Left(CacheFailure(
          message: 'Erro ao recuperar receitas do cache: ${e.toString()}',
        ));
      }
    }
  }

  @override
  Future<Either<Failure, Recipe>> getRecipeById(String id) async {
    // Verifica primeiro no cache
    try {
      final cachedRecipe = await localDataSource.getCachedRecipe(id);
      
      if (cachedRecipe != null) {
        return Right(cachedRecipe);
      }
    } catch (_) {
      // Ignora erros do cache e tenta remotamente
    }

    // Se não está no cache ou ocorreu um erro, busca remotamente
    if (await networkInfo.isConnected) {
      try {
        final recipe = await remoteDataSource.getRecipeById(id);
        
        // Armazena no cache
        await localDataSource.cacheRecipe(recipe);
        
        return Right(recipe);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(
          message: 'Erro ao buscar receita: ${e.toString()}',
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'Sem conexão com a internet',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> searchRecipes(String query) async {
    final cacheKey = _searchRecipesKey + query.toLowerCase();
    
    if (await networkInfo.isConnected) {
      try {
        // Busca receitas da API
        final recipes = await remoteDataSource.searchRecipes(query);
        
        // Armazena no cache
        await localDataSource.cacheRecipes(recipes, cacheKey);
        
        return Right(recipes);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(
          message: 'Erro ao buscar receitas: ${e.toString()}',
        ));
      }
    } else {
      // Sem conexão, tenta buscar do cache
      try {
        final cachedRecipes = await localDataSource.getCachedRecipes(cacheKey);
        return Right(cachedRecipes);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        return Left(CacheFailure(
          message: 'Erro ao recuperar busca do cache: ${e.toString()}',
        ));
      }
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getFavoriteRecipes() async {
    try {
      // Obtém os IDs das receitas favoritas
      final favoriteIds = await localDataSource.getCachedFavorites();
      
      if (favoriteIds.isEmpty) {
        return const Right([]);
      }
      
      final List<Recipe> favoriteRecipes = [];
      
      // Carrega cada receita favorita do cache
      for (final id in favoriteIds) {
        final recipe = await localDataSource.getCachedRecipe(id);
        if (recipe != null) {
          favoriteRecipes.add(recipe);
        }
      }
      
      // Se estiver online, busca as informações atualizadas das receitas que faltam
      if (await networkInfo.isConnected) {
        final cachedIds = favoriteRecipes.map((r) => r.id).toList();
        final missingIds = favoriteIds.where((id) => !cachedIds.contains(id)).toList();
        
        for (final id in missingIds) {
          try {
            final recipe = await remoteDataSource.getRecipeById(id);
            await localDataSource.cacheRecipe(recipe);
            favoriteRecipes.add(recipe);
          } catch (_) {
            // Ignora erros ao buscar receitas individuais
          }
        }
      }
      
      return Right(favoriteRecipes);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Erro ao recuperar favoritos: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String recipeId) async {
    try {
      await localDataSource.addToFavorites(recipeId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Erro ao adicionar aos favoritos: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String recipeId) async {
    try {
      await localDataSource.removeFromFavorites(recipeId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Erro ao remover dos favoritos: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String recipeId) async {
    try {
      final isFavorite = await localDataSource.isFavorite(recipeId);
      return Right(isFavorite);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Erro ao verificar favorito: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipeHistory() async {
    try {
      // Obtém os IDs do histórico
      final historyIds = await localDataSource.getCachedHistory();
      
      if (historyIds.isEmpty) {
        return const Right([]);
      }
      
      final List<Recipe> historyRecipes = [];
      
      // Carrega cada receita do histórico do cache
      for (final id in historyIds) {
        final recipe = await localDataSource.getCachedRecipe(id);
        if (recipe != null) {
          historyRecipes.add(recipe);
        }
      }
      
      return Right(historyRecipes);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Erro ao recuperar histórico: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> addToHistory(String recipeId) async {
    try {
      await localDataSource.addToHistory(recipeId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Erro ao adicionar ao histórico: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await localDataSource.clearHistory();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Erro ao limpar histórico: ${e.toString()}',
      ));
    }
  }
}