// lib/presentation/view_models/recipe_view_model.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/use_cases/recipes/get_suggested_recipes.dart';

class RecipeViewModel extends ChangeNotifier {
  final GetSuggestedRecipes _getSuggestedRecipes;
  
  RecipeViewModel({required GetSuggestedRecipes getSuggestedRecipes})
      : _getSuggestedRecipes = getSuggestedRecipes;
  
  List<Recipe> _suggestedRecipes = [];
  bool _isLoading = false;
  
  List<Recipe> get suggestedRecipes => _suggestedRecipes;
  bool get isLoading => _isLoading;
  
  Future<void> loadSuggestedRecipes() async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _getSuggestedRecipes();
    
    result.fold(
      (failure) {
        // Handle error
        _isLoading = false;
      },
      (recipes) {
        _suggestedRecipes = recipes;
        _isLoading = false;
      }
    );
    
    notifyListeners();
  }
  
  Future<void> searchRecipes(String query) async {
    // Implementation
  }
}