import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/recipe.dart';
import '../../repositories/recipe_repository.dart';

/// Use case para obter os detalhes de uma receita específica.
class GetRecipeDetail {
  final RecipeRepository repository;

  GetRecipeDetail(this.repository);

  /// Executa o caso de uso.
  /// 
  /// Recebe o [id] da receita e retorna um [Either] contendo
  /// um [Failure] em caso de erro ou a [Recipe] solicitada.
  Future<Either<Failure, Recipe>> call(String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'ID da receita é obrigatório',
      ));
    }
    
    // Registra a visualização da receita no histórico
    await repository.addToHistory(id);
    
    // Obtém os detalhes da receita
    return await repository.getRecipeById(id);
  }
}
