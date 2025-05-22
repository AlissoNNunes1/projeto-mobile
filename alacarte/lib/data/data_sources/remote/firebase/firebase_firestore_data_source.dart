import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../domain/entities/ingredient.dart';
import '../../../../domain/entities/recipe.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../models/ingredient_model.dart';
import '../../../models/recipe_model.dart';
import '../../../models/user_profile_model.dart';

/// [FirebaseFirestoreDataSource] é responsável por operações com o Firestore.
/// Implementa as operações CRUD para entidades da aplicação.
class FirebaseFirestoreDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseFirestoreDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  // Coleções do Firestore
  static const String _usersCollection = 'users';
  static const String _recipesCollection = 'recipes';
  static const String _ingredientsCollection = 'ingredients';
  static const String _favoritesCollection = 'favorites';
  static const String _historyCollection = 'history';

  // Métodos de Usuário
  
  /// Obtém o perfil do usuário atual
  Future<UserProfileModel> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NotAuthenticatedException();
    }

    try {
      final doc = await _firestore.collection(_usersCollection).doc(user.uid).get();
      
      if (!doc.exists) {
        throw NotFoundException('Perfil de usuário não encontrado');
      }

      return UserProfileModel.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao obter perfil do usuário');
    }
  }

  /// Atualiza o perfil do usuário
  Future<void> updateUserProfile(UserProfile userProfile) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NotAuthenticatedException();
    }

    try {
      await _firestore.collection(_usersCollection).doc(user.uid).update(
        (userProfile as UserProfileModel).toJson(),
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao atualizar perfil do usuário');
    }
  }

  // Métodos de Receitas

  /// Obtém todas as receitas
  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final querySnapshot = await _firestore.collection(_recipesCollection).get();
      return querySnapshot.docs
          .map((doc) => RecipeModel.fromJson(doc.data())..id = doc.id)
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao obter receitas');
    }
  }

  /// Busca receitas por termo de busca
  Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      // Implementação simples de busca usando o nome da receita
      // Para uma solução mais robusta, considere usar Algolia ou Firebase Extensions
      final querySnapshot = await _firestore
          .collection(_recipesCollection)
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => RecipeModel.fromJson(doc.data())..id = doc.id)
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao buscar receitas');
    }
  }

  /// Obtém uma receita por ID
  Future<RecipeModel> getRecipeById(String recipeId) async {
    try {
      final doc = await _firestore.collection(_recipesCollection).doc(recipeId).get();
      
      if (!doc.exists) {
        throw NotFoundException('Receita não encontrada');
      }

      return RecipeModel.fromJson(doc.data()!)..id = doc.id;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao obter receita');
    }
  }

  /// Recomenda receitas baseadas em ingredientes
  Future<List<RecipeModel>> getRecipesByIngredients(List<String> ingredientIds) async {
    if (ingredientIds.isEmpty) {
      return [];
    }

    try {
      // Buscar receitas que contenham pelo menos um dos ingredientes
      // Ordenar por número de ingredientes correspondentes
      final querySnapshot = await _firestore
          .collection(_recipesCollection)
          .where('ingredientIds', arrayContainsAny: ingredientIds)
          .get();

      final recipes = querySnapshot.docs
          .map((doc) => RecipeModel.fromJson(doc.data())..id = doc.id)
          .toList();

      // Ordenar por número de ingredientes correspondentes (do maior para o menor)
      recipes.sort((a, b) {
        final aMatches = a.ingredientIds.where((id) => ingredientIds.contains(id)).length;
        final bMatches = b.ingredientIds.where((id) => ingredientIds.contains(id)).length;
        return bMatches.compareTo(aMatches);
      });

      return recipes;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao recomendar receitas');
    }
  }

  // Métodos de Ingredientes

  /// Obtém todos os ingredientes
  Future<List<IngredientModel>> getAllIngredients() async {
    try {
      final querySnapshot = await _firestore.collection(_ingredientsCollection).get();
      return querySnapshot.docs
          .map((doc) => IngredientModel.fromJson(doc.data())..id = doc.id)
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao obter ingredientes');
    }
  }

  /// Obtém ingredientes por categoria
  Future<List<IngredientModel>> getIngredientsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_ingredientsCollection)
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs
          .map((doc) => IngredientModel.fromJson(doc.data())..id = doc.id)
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao obter ingredientes por categoria');
    }
  }

  /// Busca ingredientes por termo
  Future<List<IngredientModel>> searchIngredients(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_ingredientsCollection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => IngredientModel.fromJson(doc.data())..id = doc.id)
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao buscar ingredientes');
    }
  }

  // Métodos de Favoritos

  /// Adiciona uma receita aos favoritos
  Future<void> addToFavorites(String recipeId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NotAuthenticatedException();
    }

    try {
      final userDoc = _firestore.collection(_usersCollection).doc(user.uid);
      
      await userDoc.collection(_favoritesCollection).doc(recipeId).set({
        'recipeId': recipeId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao adicionar aos favoritos');
    }
  }

  /// Remove uma receita dos favoritos
  Future<void> removeFromFavorites(String recipeId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NotAuthenticatedException();
    }

    try {
      final userDoc = _firestore.collection(_usersCollection).doc(user.uid);
      await userDoc.collection(_favoritesCollection).doc(recipeId).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao remover dos favoritos');
    }
  }

  /// Obtém as receitas favoritas do usuário
  Future<List<RecipeModel>> getFavoriteRecipes() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NotAuthenticatedException();
    }

    try {
      final userDoc = _firestore.collection(_usersCollection).doc(user.uid);
      final favorites = await userDoc.collection(_favoritesCollection).get();

      if (favorites.docs.isEmpty) {
        return [];
      }

      // Obter IDs das receitas favoritas
      final recipeIds = favorites.docs.map((doc) => doc.id).toList();

      // Buscar as receitas completas
      final recipes = await Future.wait(
        recipeIds.map((id) => getRecipeById(id)),
      );

      return recipes;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao obter favoritos');
    }
  }

  /// Verifica se uma receita está nos favoritos
  Future<bool> isFavorite(String recipeId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NotAuthenticatedException();
    }

    try {
      final userDoc = _firestore.collection(_usersCollection).doc(user.uid);
      final favoriteDoc = await userDoc.collection(_favoritesCollection).doc(recipeId).get();
      
      return favoriteDoc.exists;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao verificar favorito');
    }
  }

  // Métodos de Histórico

  /// Adiciona uma receita ao histórico
  Future<void> addToHistory(String recipeId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NotAuthenticatedException();
    }

    try {
      final userDoc = _firestore.collection(_usersCollection).doc(user.uid);
      
      await userDoc.collection(_historyCollection).doc(recipeId).set({
        'recipeId': recipeId,
        'viewedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao adicionar ao histórico');
    }
  }

  /// Limpa o histórico de receitas
  Future<void> clearHistory() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NotAuthenticatedException();
    }

    try {
      final userDoc = _firestore.collection(_usersCollection).doc(user.uid);
      final historySnapshot = await userDoc.collection(_historyCollection).get();
      
      final batch = _firestore.batch();
      for (var doc in historySnapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao limpar histórico');
    }
  }

  /// Obtém o histórico de receitas visualizadas
  Future<List<Map<String, dynamic>>> getRecipeHistory() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NotAuthenticatedException();
    }

    try {
      final userDoc = _firestore.collection(_usersCollection).doc(user.uid);
      final historySnapshot = await userDoc.collection(_historyCollection)
          .orderBy('viewedAt', descending: true)
          .get();

      if (historySnapshot.docs.isEmpty) {
        return [];
      }

      // Mapear o histórico para obter IDs e timestamps
      final historyItems = historySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'recipeId': doc.id,
          'viewedAt': data['viewedAt'],
        };
      }).toList();

      // Obter as receitas completas
      final recipes = await Future.wait(
        historyItems.map((item) async {
          final recipe = await getRecipeById(item['recipeId']);
          return {
            'recipe': recipe,
            'viewedAt': item['viewedAt'],
          };
        }),
      );

      return recipes;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao obter histórico');
    }
  }

  // Métodos para ingredientes do usuário

  /// Salva os ingredientes do usuário
  Future<void> saveUserIngredients(List<Ingredient> ingredients) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NotAuthenticatedException();
    }

    try {
      final userDoc = _firestore.collection(_usersCollection).doc(user.uid);
      
      // Converter para IDs de ingredientes
      final ingredientIds = ingredients.map((e) => e.id).toList();
      
      await userDoc.update({
        'ingredientIds': ingredientIds,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao salvar ingredientes do usuário');
    }
  }

  /// Obtém os ingredientes do usuário
  Future<List<IngredientModel>> getUserIngredients() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NotAuthenticatedException();
    }

    try {
      final userDoc = await _firestore.collection(_usersCollection).doc(user.uid).get();
      
      if (!userDoc.exists) {
        throw NotFoundException('Usuário não encontrado');
      }

      final userData = userDoc.data()!;
      if (!userData.containsKey('ingredientIds')) {
        return [];
      }

      final ingredientIds = List<String>.from(userData['ingredientIds']);
      if (ingredientIds.isEmpty) {
        return [];
      }

      // Buscar os detalhes completos de cada ingrediente
      final ingredients = <IngredientModel>[];
      
      // Buscar em lotes para evitar exceder limites do Firestore
      for (var i = 0; i < ingredientIds.length; i += 10) {
        final end = (i + 10 < ingredientIds.length) ? i + 10 : ingredientIds.length;
        final batch = ingredientIds.sublist(i, end);
        
        final querySnapshot = await _firestore
            .collection(_ingredientsCollection)
            .where(FieldPath.documentId, whereIn: batch)
            .get();
            
        ingredients.addAll(querySnapshot.docs
            .map((doc) => IngredientModel.fromJson(doc.data())..id = doc.id));
      }

      return ingredients;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Erro ao obter ingredientes do usuário');
    }
  }
}
