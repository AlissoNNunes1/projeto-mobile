import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/recipe_repository.dart';

/// Use case para alternar uma receita entre favoritas/não favoritas.
class ToggleFavoriteRecipe {
  final RecipeRepository repository;

  ToggleFavoriteRecipe(this.repository);

  /// Executa o caso de uso.
  /// 
  /// Recebe o [recipeId] e alterna seu status de favorito.
  /// Se a receita já for favorita, remove; caso contrário, adiciona.
  /// Retorna um [Either] contendo um [Failure] em caso de erro
  /// ou um [bool] indicando se a receita está favorita (true) ou não (false) após a operação.
  Future<Either<Failure, bool>> call(String recipeId) async {
    if (recipeId.isEmpty) {
      return const Left(ValidationFailure(
        message: 'ID da receita é obrigatório',
      ));
    }
    
    // Verifica se a receita já está nos favoritos
    final isFavoriteResult = await repository.isFavorite(recipeId);
    
    return isFavoriteResult.fold(
      (failure) => Left(failure),
      (isFavorite) async {
        // Alterna o status
        if (isFavorite) {
          // Remove dos favoritos
          final result = await repository.removeFromFavorites(recipeId);
          return result.fold(
            (failure) => Left(failure),
            (_) => const Right(false), // Não é mais favorito
          );
        } else {
          // Adiciona aos favoritos
          final result = await repository.addToFavorites(recipeId);
          return result.fold(
            (failure) => Left(failure),
            (_) => const Right(true), // Agora é favorito
          );
        }
      },
    );
  }
}
