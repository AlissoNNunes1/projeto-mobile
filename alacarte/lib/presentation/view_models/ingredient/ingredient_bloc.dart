import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/use_cases/ingredients/get_ingredients.dart';
import '../../../domain/entities/ingredient.dart';
import '../../../domain/repositories/ingredient_repository.dart';
import '../../../core/error/failures.dart';

// Events
abstract class IngredientEvent extends Equatable {
  const IngredientEvent();

  @override
  List<Object?> get props => [];
}

class GetIngredientsEvent extends IngredientEvent {
  final String? query;
  final String? category;
  final int limit;

  const GetIngredientsEvent({
    this.query,
    this.category,
    this.limit = 50,
  });

  @override
  List<Object?> get props => [query, category, limit];
}

class GetUserIngredientInputEvent extends IngredientEvent {}

class AddIngredientInputEvent extends IngredientEvent {
  final String ingredientName;

  const AddIngredientInputEvent(this.ingredientName);

  @override
  List<Object> get props => [ingredientName];
}

class RemoveIngredientInputEvent extends IngredientEvent {
  final String ingredientName;

  const RemoveIngredientInputEvent(this.ingredientName);

  @override
  List<Object> get props => [ingredientName];
}

class ClearIngredientInputEvent extends IngredientEvent {}

// States
abstract class IngredientState extends Equatable {
  const IngredientState();

  @override
  List<Object?> get props => [];
}

class IngredientInitial extends IngredientState {}

class IngredientsLoading extends IngredientState {}

class UserInputLoading extends IngredientState {}

class IngredientsLoaded extends IngredientState {
  final List<Ingredient> ingredients;

  const IngredientsLoaded(this.ingredients);

  @override
  List<Object> get props => [ingredients];
}

class UserIngredientInputLoaded extends IngredientState {
  final List<String> ingredients;

  const UserIngredientInputLoaded(this.ingredients);

  @override
  List<Object> get props => [ingredients];
}

class IngredientError extends IngredientState {
  final String message;

  const IngredientError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class IngredientBloc extends Bloc<IngredientEvent, IngredientState> {
  final GetIngredients getIngredients;
  final IngredientRepository repository;

  IngredientBloc({
    required this.getIngredients,
    required this.repository,
  }) : super(IngredientInitial()) {
    on<GetIngredientsEvent>(_onGetIngredients);
    on<GetUserIngredientInputEvent>(_onGetUserIngredientInput);
    on<AddIngredientInputEvent>(_onAddIngredientInput);
    on<RemoveIngredientInputEvent>(_onRemoveIngredientInput);
    on<ClearIngredientInputEvent>(_onClearIngredientInput);
  }

  Future<void> _onGetIngredients(
    GetIngredientsEvent event,
    Emitter<IngredientState> emit,
  ) async {
    emit(IngredientsLoading());

    final result = await getIngredients(
      query: event.query,
      category: event.category,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(IngredientError(_mapFailureToMessage(failure))),
      (ingredients) => emit(IngredientsLoaded(ingredients)),
    );
  }

  Future<void> _onGetUserIngredientInput(
    GetUserIngredientInputEvent event,
    Emitter<IngredientState> emit,
  ) async {
    emit(UserInputLoading());

    final result = await repository.getUserIngredientInput();

    result.fold(
      (failure) => emit(IngredientError(_mapFailureToMessage(failure))),
      (ingredients) => emit(UserIngredientInputLoaded(ingredients)),
    );
  }

  Future<void> _onAddIngredientInput(
    AddIngredientInputEvent event,
    Emitter<IngredientState> emit,
  ) async {
    final result = await repository.saveIngredientInput(event.ingredientName);

    await result.fold(
      (failure) async => emit(IngredientError(_mapFailureToMessage(failure))),
      (_) async {
        // Recarrega a lista de ingredientes do usuário
        final inputResult = await repository.getUserIngredientInput();
        inputResult.fold(
          (failure) => emit(IngredientError(_mapFailureToMessage(failure))),
          (ingredients) => emit(UserIngredientInputLoaded(ingredients)),
        );
      },
    );
  }

  Future<void> _onRemoveIngredientInput(
    RemoveIngredientInputEvent event,
    Emitter<IngredientState> emit,
  ) async {
    final result = await repository.removeIngredientInput(event.ingredientName);

    await result.fold(
      (failure) async => emit(IngredientError(_mapFailureToMessage(failure))),
      (_) async {
        // Recarrega a lista de ingredientes do usuário
        final inputResult = await repository.getUserIngredientInput();
        inputResult.fold(
          (failure) => emit(IngredientError(_mapFailureToMessage(failure))),
          (ingredients) => emit(UserIngredientInputLoaded(ingredients)),
        );
      },
    );
  }

  Future<void> _onClearIngredientInput(
    ClearIngredientInputEvent event,
    Emitter<IngredientState> emit,
  ) async {
    final result = await repository.clearIngredientInput();

    result.fold(
      (failure) => emit(IngredientError(_mapFailureToMessage(failure))),
      (_) => emit(const UserIngredientInputLoaded([])),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message ?? 'Erro no servidor';
      case NetworkFailure:
        return failure.message ?? 'Sem conexão com a internet';
      case CacheFailure:
        return failure.message ?? 'Erro no cache local';
      default:
        return 'Erro inesperado';
    }
  }
}
