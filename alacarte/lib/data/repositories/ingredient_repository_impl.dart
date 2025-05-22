import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/entities/ingredient.dart';
import '../../../domain/repositories/ingredient_repository.dart';
import '../../models/ingredient_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IngredientRepositoryImpl implements IngredientRepository {
  final FirebaseFirestore firestore;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  
  // Chaves para o armazenamento local
  static const _ingredientInputKey = 'user_ingredient_input';
  
  IngredientRepositoryImpl({
    required this.firestore,
    required this.networkInfo,
    required this.sharedPreferences,
  });
  
  @override
  Future<Either<Failure, List<Ingredient>>> getAllIngredients() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Sem conexão com a internet',
      ));
    }
    
    try {
      final snapshot = await firestore
          .collection('ingredients')
          .get();
          
      final ingredients = snapshot.docs
          .map((doc) => IngredientModel.fromJson({
            'id': doc.id,
            ...doc.data(),
          }))
          .toList();
          
      return Right(ingredients);
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao buscar ingredientes: ${e.toString()}',
      ));
    }
  }
  
  @override
  Future<Either<Failure, List<Ingredient>>> searchIngredients(String query) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Sem conexão com a internet',
      ));
    }
    
    try {
      // Busca por nome começando com a query
      final snapshot = await firestore
          .collection('ingredients')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
          
      final ingredients = snapshot.docs
          .map((doc) => IngredientModel.fromJson({
            'id': doc.id,
            ...doc.data(),
          }))
          .toList();
          
      return Right(ingredients);
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao buscar ingredientes: ${e.toString()}',
      ));
    }
  }
  
  @override
  Future<Either<Failure, List<Ingredient>>> getIngredientsByCategory(String category) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Sem conexão com a internet',
      ));
    }
    
    try {
      final snapshot = await firestore
          .collection('ingredients')
          .where('category', isEqualTo: category)
          .get();
          
      final ingredients = snapshot.docs
          .map((doc) => IngredientModel.fromJson({
            'id': doc.id,
            ...doc.data(),
          }))
          .toList();
          
      return Right(ingredients);
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao buscar ingredientes: ${e.toString()}',
      ));
    }
  }
  
  @override
  Future<Either<Failure, List<Ingredient>>> getPopularIngredients({int limit = 10}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Sem conexão com a internet',
      ));
    }
    
    try {
      final snapshot = await firestore
          .collection('ingredients')
          .orderBy('popularityScore', descending: true)
          .limit(limit)
          .get();
          
      final ingredients = snapshot.docs
          .map((doc) => IngredientModel.fromJson({
            'id': doc.id,
            ...doc.data(),
          }))
          .toList();
          
      return Right(ingredients);
    } catch (e) {
      return Left(ServerFailure(
        message: 'Erro ao buscar ingredientes populares: ${e.toString()}',
      ));
    }
  }
  
  @override
  Future<Either<Failure, void>> saveIngredientInput(String ingredientName) async {
    try {
      final ingredients = await getUserIngredientInput();
      
      return ingredients.fold(
        (failure) => Left(failure),
        (list) {
          final newList = List<String>.from(list);
          
          // Adiciona apenas se não existir
          if (!newList.contains(ingredientName)) {
            newList.add(ingredientName);
            sharedPreferences.setStringList(_ingredientInputKey, newList);
          }
          
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(CacheFailure(
        message: 'Erro ao salvar ingrediente: ${e.toString()}',
      ));
    }
  }
  
  @override
  Future<Either<Failure, List<String>>> getUserIngredientInput() async {
    try {
      final ingredients = sharedPreferences.getStringList(_ingredientInputKey) ?? [];
      return Right(ingredients);
    } catch (e) {
      return Left(CacheFailure(
        message: 'Erro ao recuperar ingredientes: ${e.toString()}',
      ));
    }
  }
  
  @override
  Future<Either<Failure, void>> removeIngredientInput(String ingredientName) async {
    try {
      final ingredients = await getUserIngredientInput();
      
      return ingredients.fold(
        (failure) => Left(failure),
        (list) {
          final newList = List<String>.from(list);
          newList.remove(ingredientName);
          sharedPreferences.setStringList(_ingredientInputKey, newList);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(CacheFailure(
        message: 'Erro ao remover ingrediente: ${e.toString()}',
      ));
    }
  }
  
  @override
  Future<Either<Failure, void>> clearIngredientInput() async {
    try {
      sharedPreferences.remove(_ingredientInputKey);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(
        message: 'Erro ao limpar ingredientes: ${e.toString()}',
      ));
    }
  }
  
  @override
  Future<Either<Failure, List<String>>> recognizeIngredientsFromImage(String imagePath) async {
    // Esta é uma funcionalidade futura que requer integração com IA
    // Por enquanto, retornamos um erro indicando que não está implementado
    return const Left(ServerFailure(
      message: 'Reconhecimento de imagem ainda não disponível',
    ));
  }
}