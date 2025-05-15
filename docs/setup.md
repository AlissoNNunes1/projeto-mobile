# Guia de Configuração - À LaCarte

Este documento fornece instruções passo a passo para configurar o ambiente de desenvolvimento e iniciar o projeto À LaCarte.

## Índice

1. [Pré-requisitos](#pré-requisitos)
2. [Configuração do Ambiente](#configuração-do-ambiente)
3. [Clone do Repositório](#clone-do-repositório)
4. [Configuração do Firebase](#configuração-do-firebase)
5. [Configuração da API de IA](#configuração-da-api-de-ia)
6. [Executando o Projeto](#executando-o-projeto)
7. [Estrutura do Projeto](#estrutura-do-projeto)
8. [Testes](#testes)
9. [Deployment](#deployment)

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- Flutter SDK (versão 3.10.0 ou superior)
- Dart SDK (versão 3.0.0 ou superior)
- Android Studio / Xcode
- VS Code (recomendado)
- Git
- Node.js (para algumas ferramentas de desenvolvimento)

## Configuração do Ambiente

### 1. Instalar o Flutter

```bash
# Baixar o Flutter SDK do site oficial
# Extrair o arquivo em um diretório de sua escolha
# Adicionar ao PATH

# Verificar a instalação
flutter doctor
```

Corrigir quaisquer problemas identificados pelo `flutter doctor`.

### 2. Configurar Editores/IDEs

#### VS Code
- Instalar extensões: Flutter, Dart
- Configurar formatação automática

#### Android Studio
- Instalar plugins: Flutter, Dart
- Configurar emulador Android

### 3. Configurar iOS (apenas macOS)

```bash
# Instalar CocoaPods
sudo gem install cocoapods

# Verificar a instalação do Xcode
xcode-select --install
```

## Clone do Repositório

```bash
# Clonar o repositório
git clone https://github.com/seu-usuario/a-lacarte.git

# Entrar no diretório
cd a-lacarte

# Instalar dependências
flutter pub get
```

## Configuração do Firebase

### 1. Criar Projeto no Firebase

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Crie um novo projeto chamado "A LaCarte"
3. Ative os serviços necessários:
   - Authentication
   - Firestore Database
   - Storage
   - Cloud Messaging

### 2. Configurar Firebase no App Android

1. No Firebase Console, adicione um aplicativo Android:
   - Nome do pacote: `com.alacarte.app`
   - Nickname: `A LaCarte`
   - Baixe o arquivo `google-services.json`
   - Coloque o arquivo na pasta `android/app/`

### 3. Configurar Firebase no App iOS

1. No Firebase Console, adicione um aplicativo iOS:
   - Bundle ID: `com.alacarte.app`
   - Nickname: `A LaCarte`
   - Baixe o arquivo `GoogleService-Info.plist`
   - Coloque o arquivo na pasta `ios/Runner/`
   - Também adicione-o ao projeto iOS via Xcode

### 4. Configurar Regras do Firestore

```javascript
// Copie estas regras no console do Firebase > Firestore > Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários podem ler e atualizar apenas seus próprios dados
    match /users/{userId} {
      allow read, update, delete: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null;
      
      // Subcoleções de usuário
      match /{subCollection}/{docId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Regras para receitas
    match /recipes/{recipeId} {
      allow read: if request.auth != null;
      allow create, update: if request.auth != null && request.auth.uid == request.resource.data.createdBy;
      allow delete: if request.auth != null && request.auth.uid == resource.data.createdBy;
      
      // Avaliações de receitas
      match /ratings/{ratingId} {
        allow read: if request.auth != null;
        allow create: if request.auth != null;
        allow update, delete: if request.auth != null && request.auth.uid == resource.data.userId;
      }
    }
    
    // Outras coleções similares...
  }
}
```

### 5. Configurar Storage Rules

```javascript
// Copie estas regras no console do Firebase > Storage > Rules
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Autenticação necessária para qualquer operação
    match /{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Imagens de perfil - apenas o próprio usuário pode modificar
    match /profile_images/{userId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Imagens de ingredientes - qualquer usuário autenticado pode enviar
    match /ingredient_images/{imagePath} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && request.auth.uid == resource.metadata.userId;
    }
  }
}
```

## Configuração da API de IA

### 1. Obter Credenciais da API

Obtenha uma chave de API do serviço de IA de sua escolha (OpenAI, Google, etc).

### 2. Configurar Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```
AI_API_KEY=sua_chave_api_aqui
AI_API_URL=https://api.exemplo.com/v1
FIREBASE_WEB_API_KEY=sua_chave_firebase_web_api_key
```

### 3. Configurar Arquivo de Ambiente Flutter

```dart
// lib/core/config/env.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get aiApiKey => dotenv.env['AI_API_KEY'] ?? '';
  static String get aiApiUrl => dotenv.env['AI_API_URL'] ?? '';
  static String get firebaseWebApiKey => dotenv.env['FIREBASE_WEB_API_KEY'] ?? '';
  
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
}
```

## Executando o Projeto

### 1. Executar em Modo Debug

```bash
# Verificar dispositivos disponíveis
flutter devices

# Executar no dispositivo específico (ou emulador)
flutter run -d <device_id>

# Executar com reconstrução limpa
flutter clean && flutter pub get && flutter run
```

### 2. Compilar em Modo Release

```bash
# Compilar APK para Android
flutter build apk --release

# Compilar App Bundle para Android (Google Play)
flutter build appbundle --release

# Compilar para iOS (apenas em macOS)
flutter build ios --release
```

### 3. Opções de Flavors (Opcional)

Se configurado para múltiplos ambientes:

```bash
# Desenvolvimento
flutter run --flavor dev -t lib/main_dev.dart

# Produção
flutter run --flavor prod -t lib/main_prod.dart
```

## Estrutura do Projeto

```
├── android/              # Configurações nativas Android
├── ios/                  # Configurações nativas iOS
├── lib/
│   ├── core/             # Código principal, utilitários e serviços
│   │   ├── config/       # Configurações da aplicação
│   │   ├── errors/       # Tratamento de erros e exceções
│   │   ├── network/      # Serviços de rede e cliente HTTP
│   │   └── utils/        # Utilitários e helpers
│   ├── data/             # Camada de dados
│   │   ├── datasources/  # Fontes de dados (API, local)
│   │   ├── models/       # Modelos de dados
│   │   └── repositories/ # Implementações de repositories
│   ├── domain/           # Camada de domínio
│   │   ├── entities/     # Entidades de negócio
│   │   ├── repositories/ # Interfaces de repositories
│   │   └── usecases/     # Casos de uso
│   ├── presentation/     # Camada de apresentação
│   │   ├── navigation/   # Rotas e navegação
│   │   ├── providers/    # Providers para gerenciamento de estado
│   │   ├── screens/      # Telas da aplicação
│   │   ├── themes/       # Temas e estilos
│   │   └── widgets/      # Widgets reutilizáveis
│   └── main.dart         # Ponto de entrada da aplicação
├── test/                 # Testes automatizados
├── docs/                 # Documentação
├── assets/               # Recursos estáticos (imagens, fontes, etc)
├── pubspec.yaml          # Definição de dependências
└── README.md             # Documentação principal
```

## Testes

### 1. Executar Testes

```bash
# Executar todos os testes
flutter test

# Executar teste específico
flutter test test/path/to/test_file.dart

# Executar testes com cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 2. Tipos de Testes

- **Testes Unitários**: Testam funções, classes e lógica de negócios isoladamente
- **Testes de Widgets**: Testam componentes de UI individuais
- **Testes de Integração**: Testam interações entre diferentes partes do sistema
- **Testes Golden**: Comparação visual de widgets com imagens de referência

## Deployment

### 1. Android

1. Configurar `android/app/build.gradle` com as informações da versão
2. Gerar keystore para assinatura (se não existir)
3. Configurar assinatura em `android/key.properties`
4. Compilar: `flutter build appbundle --release`
5. Enviar para Google Play Console

### 2. iOS (apenas macOS)

1. Configurar `ios/Runner/Info.plist` com versão
2. Configurar certificados e perfis de provisionamento no Apple Developer Portal
3. Compilar: `flutter build ios --release`
4. Abrir `ios/Runner.xcworkspace` no Xcode
5. Arquivar e enviar para App Store Connect

## Solução de Problemas

### Problemas Comuns

1. **Erro de versão Flutter/Dart**
   - Solução: `flutter upgrade` para atualizar

2. **Incompatibilidade de dependências**
   - Solução: Verificar versões em `pubspec.yaml`, executar `flutter pub upgrade`

3. **Erros de compilação iOS**
   - Solução: Executar `pod install` em `ios/`

4. **Problemas com Firebase**
   - Solução: Verificar `google-services.json` e `GoogleService-Info.plist`

5. **Erro de conexão com API**
   - Solução: Verificar chave API e variáveis de ambiente

## Recursos Adicionais

- [Documentação do Flutter](https://flutter.dev/docs)
- [Documentação do Firebase](https://firebase.google.com/docs)
- [Documentação de design](./docs/design/ui-guidelines.md)
- [Backlog do Projeto](./docs/backlog/product-backlog.md)

## Contato e Suporte

- **Repositório**: [GitHub](https://github.com/seu-usuario/a-lacarte)
- **Problemas**: [Issues Tracker](https://github.com/seu-usuario/a-lacarte/issues)
