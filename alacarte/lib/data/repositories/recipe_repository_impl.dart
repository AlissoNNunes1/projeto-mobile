// lib/data/repositories/recipe_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../data_sources/remote/api/recipe_api.dart';
import '../data_sources/local/database/recipe_local_datasource.dart';
import '../../../core/network/network_info.dart';
import '../../../core/error/failures.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeApi remoteDataSource;
  final RecipeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<Recipe>>> getSuggestedRecipes() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRecipes = await remoteDataSource.getSuggestedRecipes();
        localDataSource.cacheRecipes(remoteRecipes);
        return Right(remoteRecipes);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localRecipes = await localDataSource.getLastRecipes();
        return Right(localRecipes);
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }
}