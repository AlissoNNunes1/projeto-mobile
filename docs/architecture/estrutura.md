à_lacarte/
├── android/                  # Configurações específicas para Android
├── ios/                      # Configurações específicas para iOS
├── assets/                   # Recursos estáticos
│   ├── images/               # Imagens e ícones
│   ├── fonts/                # Fontes personalizadas
│   └── animations/           # Animações Lottie
│
├── lib/                      # Código fonte Dart/Flutter
│   ├── app/                  # Configurações do aplicativo
│   │   ├── app.dart          # Widget raiz do aplicativo
│   │   ├── router.dart       # Configuração de rotas
│   │   ├── theme.dart        # Definições de tema
│   │   ├── constants.dart    # Constantes globais
│   │   └── firebase_options.dart # Config. do Firebase
│   │
│   ├── presentation/         # Camada de apresentação
│   │   ├── screens/          # Telas do aplicativo
│   │   │   ├── splash/       # Tela de splash
│   │   │   ├── onboarding/   # Tela de onboarding
│   │   │   ├── auth/         # Telas de autenticação
│   │   │   ├── home/         # Tela principal/dashboard
│   │   │   ├── ingredients/  # Tela de inserção de ingredientes
│   │   │   ├── recipes/      # Telas relacionadas a receitas
│   │   │   ├── profile/      # Tela de perfil
│   │   │   ├── favorites/    # Tela de favoritos
│   │   │   └── history/      # Tela de histórico
│   │   │
│   │   ├── widgets/          # Widgets reutilizáveis
│   │   │   ├── common/       # Widgets comuns (botões, cards, etc.)
│   │   │   ├── recipe/       # Widgets de receitas
│   │   │   ├── ingredient/   # Widgets de ingredientes
│   │   │   └── feedback/     # Widgets de avaliação/comentários
│   │   │
│   │   └── view_models/      # ViewModels para gerenciamento de estado
│   │       ├── auth_view_model.dart
│   │       ├── recipe_view_model.dart
│   │       ├── ingredient_view_model.dart
│   │       └── profile_view_model.dart
│   │
│   ├── domain/               # Camada de domínio
│   │   ├── entities/         # Entidades de negócio
│   │   │   ├── user.dart
│   │   │   ├── recipe.dart
│   │   │   ├── ingredient.dart
│   │   │   └── rating.dart
│   │   │
│   │   ├── use_cases/        # Casos de uso
│   │   │   ├── auth/         # Casos de uso de autenticação
│   │   │   ├── recipes/      # Casos de uso de receitas
│   │   │   ├── ingredients/  # Casos de uso de ingredientes  
│   │   │   └── profile/      # Casos de uso de perfil
│   │   │
│   │   ├── repositories/     # Interfaces de repositórios
│   │   │   ├── auth_repository.dart
│   │   │   ├── recipe_repository.dart
│   │   │   └── ingredient_repository.dart
│   │   │
│   │   └── services/         # Interfaces de serviços
│   │       ├── ai_service.dart
│   │       ├── image_recognition_service.dart
│   │       └── speech_to_text_service.dart
│   │
│   ├── data/                 # Camada de dados
│   │   ├── repositories/     # Implementações de repositórios
│   │   │   ├── auth_repository_impl.dart
│   │   │   ├── recipe_repository_impl.dart
│   │   │   └── ingredient_repository_impl.dart
│   │   │
│   │   ├── models/           # Modelos de dados
│   │   │   ├── user_model.dart
│   │   │   ├── recipe_model.dart
│   │   │   ├── ingredient_model.dart
│   │   │   └── rating_model.dart
│   │   │
│   │   └── data_sources/     # Fontes de dados
│   │       ├── remote/       # Fontes remotas
│   │       │   ├── firebase/ # Implementações Firebase
│   │       │   └── api/      # Implementações de API externas
│   │       └── local/        # Fontes locais
│   │           ├── preferences/  # SharedPreferences
│   │           └── database/     # SQLite
│   │
│   └── core/                 # Funcionalidades centrais
│       ├── utils/            # Utilitários
│       │   ├── validators.dart
│       │   ├── formatters.dart
│       │   └── extensions.dart
│       ├── error/            # Tratamento de erros
│       │   ├── exceptions.dart
│       │   └── failures.dart
│       ├── network/          # Código relacionado à rede
│       │   ├── network_info.dart
│       │   └── api_client.dart
│       └── di/               # Injeção de dependência
│           └── injection_container.dart
│
├── firebase/                 # Código das Cloud Functions
│   ├── functions/            # Funções serverless
│   │   ├── src/
│   │   │   ├── recipes/      # Funções para receitas
│   │   │   ├── ingredients/  # Funções para ingredientes
│   │   │   ├── auth/         # Funções para autenticação
│   │   │   └── ai/           # Funções de integração com IA
│   │   ├── index.ts          # Ponto de entrada das funções
│   │   └── package.json
│   ├── firestore.rules       # Regras de segurança do Firestore
│   └── storage.rules         # Regras de segurança do Storage
│
├── test/                     # Testes
│   ├── unit/                 # Testes unitários
│   │   ├── domain/           # Testes da camada de domínio
│   │   ├── data/             # Testes da camada de dados
│   │   └── presentation/     # Testes da camada de apresentação
│   │
│   ├── widget/               # Testes de widgets
│   └── integration/          # Testes de integração
│
├── pubspec.yaml              # Dependências do Flutter
├── README.md                 # Documentação principal
└── .gitignore                # Arquivos ignorados pelo git