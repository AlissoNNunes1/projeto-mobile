// lib/domain/use_cases/recipes/get_suggested_recipes.dart
import 'package:dartz/dartz.dart';
import '../../entities/recipe.dart';
import '../../repositories/recipe_repository.dart';
import '../../../core/error/failures.dart';

class GetSuggestedRecipes {
  final RecipeRepository repository;
  
  GetSuggestedRecipes(this.repository);
  
  Future<Either<Failure, List<Recipe>>> call() async {
    return await repository.getSuggestedRecipes();
  }
}