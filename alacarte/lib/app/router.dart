import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alacarte/presentation/screens/auth/login_screen.dart';
import 'package:alacarte/presentation/screens/auth/signup_screen.dart';
import 'package:alacarte/presentation/screens/home/home_screen.dart';
import 'package:alacarte/presentation/screens/splash/splash_screen.dart';
import 'package:alacarte/presentation/screens/ingredients/ingredients_input_screen.dart';
import 'package:alacarte/presentation/screens/recipes/recipe_detail_screen.dart';
import 'package:alacarte/presentation/screens/favorites/favorites_screen.dart';
import 'package:alacarte/presentation/screens/history/history_screen.dart';
import 'package:alacarte/presentation/screens/profile/profile_screen.dart';

/// [AppRouter] gerencia as rotas da aplicação usando o GoRouter.
/// Define todas as rotas, redirecionamentos e transições entre telas.
class AppRouter {
  // Instância do router
  static final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Splash screen - Tela inicial de carregamento
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Rotas de autenticação
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      
      // Rotas principais do app (protegidas por autenticação)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/ingredients',
        name: 'ingredients',
        builder: (context, state) => const IngredientsInputScreen(),
      ),
      GoRoute(
        path: '/recipe/:id',
        name: 'recipe_detail',
        builder: (context, state) {
          final recipeId = state.pathParameters['id']!;
          return RecipeDetailScreen(recipeId: recipeId);
        },
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    
    // Redirecionamento com base no estado de autenticação
    // Isso será implementado posteriormente com um middleware de autenticação
    redirect: (context, state) {
      // Por agora, retornamos null para permitir a navegação normal
      return null;
    },
    
    // Tratamento de erros de navegação
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Página não encontrada')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oops!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('A página que você procura não existe'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Voltar para o início'),
            ),
          ],
        ),
      ),
    ),
  );
}