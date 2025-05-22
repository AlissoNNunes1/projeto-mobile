import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/ingredient.dart';
import '../../repositories/ingredient_repository.dart';

/// Use case para obter ingredientes disponíveis no sistema.
class GetIngredients {
  final IngredientRepository repository;

  GetIngredients(this.repository);

  /// Executa o caso de uso.
  /// 
  /// Opcionalmente recebe [query] para busca, [category] para filtrar por categoria
  /// e [limit] para limitar o número de resultados.
  /// Retorna um [Either] contendo um [Failure] em caso de erro
  /// ou uma [List<Ingredient>] com os ingredientes encontrados.
  Future<Either<Failure, List<Ingredient>>> call({
    String? query,
    String? category,
    int limit = 50,
  }) async {
    // Se houver uma query, faz busca por texto
    if (query != null && query.isNotEmpty) {
      return await repository.searchIngredients(query);
    }
    
    // Se houver categoria, filtra por categoria
    if (category != null && category.isNotEmpty) {
      return await repository.getIngredientsByCategory(category);
    }
    
    // Caso contrário, retorna todos os ingredientes
    final result = await repository.getAllIngredients();
    
    // Limita o número de resultados se necessário
    return result.fold(
      (failure) => Left(failure),
      (ingredients) {
        if (ingredients.length <= limit) {
          return Right(ingredients);
        }
        return Right(ingredients.sublist(0, limit));
      },
    );
  }
}
