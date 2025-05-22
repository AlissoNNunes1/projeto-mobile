import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/use_cases/recipes/get_suggested_recipes.dart';
import '../../../domain/use_cases/recipes/get_recipe_detail.dart';
import '../../../domain/use_cases/recipes/toggle_favorite_recipe.dart';
import '../../../domain/entities/recipe.dart';
import '../../../core/error/failures.dart';

// Events
abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object?> get props => [];
}

class GetSuggestedRecipesEvent extends RecipeEvent {
  final List<String> ingredients;
  final Map<String, dynamic>? preferences;

  const GetSuggestedRecipesEvent({
    required this.ingredients,
    this.preferences,
  });

  @override
  List<Object?> get props => [ingredients, preferences];
}

class GetRecipeDetailEvent extends RecipeEvent {
  final String recipeId;

  const GetRecipeDetailEvent(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}

class ToggleFavoriteEvent extends RecipeEvent {
  final String recipeId;

  const ToggleFavoriteEvent(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}

// States
abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipesLoading extends RecipeState {}

class RecipeDetailLoading extends RecipeState {}

class RecipesLoaded extends RecipeState {
  final List<Recipe> recipes;

  const RecipesLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RecipeDetailLoaded extends RecipeState {
  final Recipe recipe;
  final bool isFavorite;

  const RecipeDetailLoaded({
    required this.recipe,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [recipe, isFavorite];
}

class FavoriteToggled extends RecipeState {
  final bool isFavorite;
  final String recipeId;

  const FavoriteToggled({
    required this.isFavorite,
    required this.recipeId,
  });

  @override
  List<Object> get props => [isFavorite, recipeId];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final GetSuggestedRecipes getSuggestedRecipes;
  final GetRecipeDetail getRecipeDetail;
  final ToggleFavoriteRecipe toggleFavoriteRecipe;

  RecipeBloc({
    required this.getSuggestedRecipes,
    required this.getRecipeDetail,
    required this.toggleFavoriteRecipe,
  }) : super(RecipeInitial()) {
    on<GetSuggestedRecipesEvent>(_onGetSuggestedRecipes);
    on<GetRecipeDetailEvent>(_onGetRecipeDetail);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onGetSuggestedRecipes(
    GetSuggestedRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipesLoading());

    final result = await getSuggestedRecipes(
      ingredients: event.ingredients,
      preferences: event.preferences,
    );

    result.fold(
      (failure) => emit(RecipeError(_mapFailureToMessage(failure))),
      (recipes) => emit(RecipesLoaded(recipes)),
    );
  }

  Future<void> _onGetRecipeDetail(
    GetRecipeDetailEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeDetailLoading());

    final detailResult = await getRecipeDetail(event.recipeId);
    
    return detailResult.fold(
      (failure) => emit(RecipeError(_mapFailureToMessage(failure))),
      (recipe) async {
        // Checa se é favorito
        final favoriteResult = await toggleFavoriteRecipe.repository.isFavorite(event.recipeId);
        
        favoriteResult.fold(
          (failure) => emit(RecipeDetailLoaded(recipe: recipe, isFavorite: false)),
          (isFavorite) => emit(RecipeDetailLoaded(recipe: recipe, isFavorite: isFavorite)),
        );
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final result = await toggleFavoriteRecipe(event.recipeId);

    result.fold(
      (failure) => emit(RecipeError(_mapFailureToMessage(failure))),
      (isFavorite) => emit(FavoriteToggled(
        isFavorite: isFavorite,
        recipeId: event.recipeId,
      )),
    );
    
    // Se estamos na tela de detalhes, atualizamos o estado com o novo status de favorito
    if (state is RecipeDetailLoaded) {
      final currentState = state as RecipeDetailLoaded;
      if (currentState.recipe.id == event.recipeId) {
        emit(RecipeDetailLoaded(
          recipe: currentState.recipe,
          isFavorite: result.getOrElse(() => !currentState.isFavorite),
        ));
      }
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message ?? 'Erro no servidor';
      case NetworkFailure:
        return failure.message ?? 'Sem conexão com a internet';
      case CacheFailure:
        return failure.message ?? 'Erro no cache local';
      case ValidationFailure:
        return failure.message ?? 'Erro de validação';
      default:
        return 'Erro inesperado';
    }
  }
}
