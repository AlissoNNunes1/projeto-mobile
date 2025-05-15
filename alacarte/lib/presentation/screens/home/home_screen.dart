// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme.dart';
import '../../view_models/recipe_view_model.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/recipe/recipe_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RecipeViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text('À LaCarte')),
      body: Column(
        children: [
          SearchBar(onSearch: viewModel.searchRecipes),
          Expanded(
            child: viewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: viewModel.suggestedRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = viewModel.suggestedRecipes[index];
                    return RecipeCard(recipe: recipe);
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/ingredients/add'),
      ),
    );
  }
}