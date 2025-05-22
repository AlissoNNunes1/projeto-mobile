import 'package:flutter/material.dart';

/// [AppTheme] contém as definições de temas da aplicação.
/// Isso inclui cores, tipografia, formas, e outros atributos visuais.
class AppTheme {
  // Impedir a instanciação
  AppTheme._();

  // Cores principais
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color primaryLightColor = Color(0xFF80E27E);
  static const Color primaryDarkColor = Color(0xFF087F23);
  
  static const Color secondaryColor = Color(0xFFFFA000);
  static const Color secondaryLightColor = Color(0xFFFFD149);
  static const Color secondaryDarkColor = Color(0xFFC67100);
  
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color errorColor = Color(0xFFB00020);

  // Cores de texto
  static const Color primaryTextColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);

  // Definição do tema claro
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryLightColor,
      secondary: secondaryColor,
      secondaryContainer: secondaryLightColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: primaryTextColor,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    
    // Estilo de texto
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32, 
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      displayMedium: TextStyle(
        fontSize: 28, 
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      displaySmall: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 20, 
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18, 
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16, 
        color: primaryTextColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: primaryTextColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    
    // Estilo de componentes
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // Definição do tema escuro
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      primaryContainer: primaryDarkColor,
      secondary: secondaryColor,
      secondaryContainer: secondaryDarkColor,
      surface: const Color(0xFF121212),
      error: const Color(0xFFCF6679),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
    
    // Aplicando os mesmos estilos do tema claro, com ajustes para o tema escuro
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32, 
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 28, 
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 20, 
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 18, 
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16, 
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryDarkColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF303030)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCF6679)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}