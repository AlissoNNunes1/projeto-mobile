import 'package:dartz/dartz.dart';
import '../entities/ingredient.dart';
import '../../core/error/failures.dart';

/// [IngredientRepository] define os métodos para operações relacionadas a ingredientes.
/// Interface seguindo o princípio de Inversão de Dependência (SOLID).
abstract class IngredientRepository {
  /// Busca todos os ingredientes disponíveis no sistema.
  Future<Either<Failure, List<Ingredient>>> getAllIngredients();
  
  /// Busca ingredientes por texto de busca.
  Future<Either<Failure, List<Ingredient>>> searchIngredients(String query);
  
  /// Busca ingredientes por categoria.
  Future<Either<Failure, List<Ingredient>>> getIngredientsByCategory(String category);
  
  /// Busca os ingredientes mais populares.
  Future<Either<Failure, List<Ingredient>>> getPopularIngredients({int limit = 10});
  
  /// Salva um ingrediente temporário na entrada do usuário.
  Future<Either<Failure, void>> saveIngredientInput(String ingredientName);
  
  /// Obtém a lista de ingredientes inseridos pelo usuário.
  Future<Either<Failure, List<String>>> getUserIngredientInput();
  
  /// Remove um ingrediente da entrada do usuário.
  Future<Either<Failure, void>> removeIngredientInput(String ingredientName);
  
  /// Limpa a lista de ingredientes inseridos pelo usuário.
  Future<Either<Failure, void>> clearIngredientInput();
  
  /// Reconhece ingredientes a partir de uma imagem (funcionalidade futura).
  Future<Either<Failure, List<String>>> recognizeIngredientsFromImage(String imagePath);
}