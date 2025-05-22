import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alacarte/app/router.dart';
import 'package:alacarte/app/theme.dart';
import 'package:alacarte/presentation/view_models/auth/auth_bloc.dart';
import 'package:alacarte/core/di/injection_container.dart' as di;

/// [MyApp] é o widget raiz da aplicação À LaCarte.
/// Configura temas, rotas e injeção de dependências globais.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        // Outros BlocProviders serão adicionados conforme necessário
      ],
      child: MaterialApp.router(
        title: 'À LaCarte',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}