import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../network/network_info.dart';
import '../network/api_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../data/repositories/ingredient_repository_impl.dart';
import '../../data/data_sources/remote/firebase/firebase_auth_data_source.dart';
import '../../data/data_sources/remote/api/recipe_api.dart';
import '../../data/data_sources/local/preferences/auth_local_data_source.dart';
import '../../data/data_sources/local/database/recipe_local_data_source.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/repositories/ingredient_repository.dart';
import '../../domain/use_cases/auth/get_current_user.dart';
import '../../domain/use_cases/auth/sign_in.dart';
import '../../domain/use_cases/auth/sign_out.dart';
import '../../domain/use_cases/auth/sign_up.dart';
import '../../domain/use_cases/recipes/get_suggested_recipes.dart';
import '../../domain/use_cases/recipes/get_recipe_detail.dart';
import '../../domain/use_cases/recipes/toggle_favorite_recipe.dart';
import '../../domain/use_cases/ingredients/get_ingredients.dart';
import '../../presentation/view_models/auth/auth_bloc.dart';
import '../../presentation/view_models/recipe/recipe_bloc.dart';
import '../../presentation/view_models/ingredient/ingredient_bloc.dart';

/// Instância global do GetIt
final sl = GetIt.instance;

/// Inicializa a injeção de dependências
Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      getCurrentUser: sl(),
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: sl(),
    ),
  );

  //! Features - Recipe
  // Bloc
  sl.registerFactory(
    () => RecipeBloc(
      getSuggestedRecipes: sl(),
      getRecipeDetail: sl(),
      toggleFavoriteRecipe: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSuggestedRecipes(sl()));
  sl.registerLazySingleton(() => GetRecipeDetail(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteRecipe(sl()));

  // Repository
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RecipeApi>(
    () => RecipeApiImpl(
      apiClient: sl(),
    ),
  );

  sl.registerLazySingleton<RecipeLocalDataSource>(
    () => RecipeLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  //! Features - Ingredient  // Bloc
  sl.registerFactory(
    () => IngredientBloc(
      getIngredients: sl(),
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetIngredients(sl()));

  // Repository
  sl.registerLazySingleton<IngredientRepository>(
    () => IngredientRepositoryImpl(
      firestore: sl(),
      networkInfo: sl(),
      sharedPreferences: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  sl.registerLazySingleton(
    () => ApiClient(
      dio: sl(),
    ),
  );

  //! External
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Supabase (substituindo Firebase Storage)
  sl.registerLazySingleton(() => Supabase.instance.client);

  // Dio
  sl.registerLazySingleton(() => Dio());

  // Connectivity
  sl.registerLazySingleton(() => Connectivity());

  // Armazenamento local
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
