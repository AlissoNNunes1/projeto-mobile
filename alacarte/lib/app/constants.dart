/// [AppConstants] contém todas as constantes utilizadas na aplicação.
/// Isso centraliza valores como URLs de API, configurações padrão e outros valores constantes.
class AppConstants {
  // Impedir a instanciação
  AppConstants._();
  
  // API URLs
  static const String apiBaseUrl = 'https://api.alacarte-ai.example.com/v1/';
  static const String recommendEndpoint = 'recipes/recommend';
  static const String imageRecognitionEndpoint = 'ingredients/recognize';
  static const String speechRecognitionEndpoint = 'ingredients/speech';
  
  // Supabase (Alternativa ao Firebase Storage)
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseKey = 'YOUR_SUPABASE_KEY';
  static const String storageBucket = 'recipe_images';
  
  // Configurações de Cache
  static const int cacheExpirationMinutes = 60; // 1 hora
  static const int maxCachedRecipes = 50;
  static const int maxOfflineStorage = 50 * 1024 * 1024; // 50MB
  
  // Limites da API
  static const int maxIngredientsPerRequest = 20;
  static const int maxRecipesPerRequest = 10;
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  
  // Constantes de UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonHeight = 48.0;
  
  // Constantes de Animações
  static const int splashScreenDuration = 2000; // milissegundos
  static const int shortAnimationDuration = 300; // milissegundos
  static const int mediumAnimationDuration = 500; // milissegundos
  
  // Configurações Padrão
  static const int defaultPreparationTime = 30; // minutos
  static const int defaultServings = 2;
  
  // Sharedpreferences keys
  static const String prefKeyUser = 'user_data';
  static const String prefKeyRecipes = 'cached_recipes';
  static const String prefKeyIngredients = 'cached_ingredients';
  static const String prefKeyFavorites = 'favorites';
  static const String prefKeyHistory = 'history';
  static const String prefKeyTheme = 'app_theme';
  static const String prefKeyOnboarding = 'onboarding_completed';
  
  // Mensagens de erro
  static const String errorGeneric = 'Ocorreu um erro. Tente novamente mais tarde.';
  static const String errorNoInternet = 'Sem conexão com a Internet. Verifique sua conexão.';
  static const String errorAuthentication = 'Erro de autenticação. Verifique suas credenciais.';
  static const String errorPermissionDenied = 'Permissão negada. Você não tem acesso a este recurso.';
  static const String errorServerTimeout = 'O servidor demorou muito para responder. Tente novamente.';
}