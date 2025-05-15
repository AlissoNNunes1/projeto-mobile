# Guia de Configuração do Ambiente de Desenvolvimento - À LaCarte

Este guia fornece instruções para configurar o ambiente de desenvolvimento do aplicativo À LaCarte.

## Requisitos do Sistema

- **Flutter SDK:** versão 3.10.0 ou superior
- **Dart:** versão 3.0.0 ou superior
- **Android Studio:** versão mais recente recomendada
- **Xcode:** versão 14.0 ou superior (apenas para desenvolvimento iOS)
- **VS Code ou outro editor:** com plugins Flutter/Dart
- **Git:** para controle de versão

## Configuração do Ambiente

### 1. Instalação do Flutter

#### Windows
1. Baixe o [Flutter SDK](https://flutter.dev/docs/get-started/install/windows)
2. Extraia o arquivo zip em um diretório (evite caminhos com espaços ou caracteres especiais)
3. Adicione `flutter\bin` ao PATH do sistema
4. Execute `flutter doctor` para verificar dependências adicionais

#### macOS
1. Baixe o [Flutter SDK](https://flutter.dev/docs/get-started/install/macos)
2. Extraia o arquivo zip em um diretório
3. Adicione `flutter/bin` ao PATH:
   ```bash
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
4. Execute `flutter doctor` para verificar dependências adicionais

#### Linux
1. Baixe o [Flutter SDK](https://flutter.dev/docs/get-started/install/linux)
2. Extraia o arquivo tar.xz em um diretório
3. Adicione `flutter/bin` ao PATH:
   ```bash
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
4. Execute `flutter doctor` para verificar dependências adicionais

### 2. Configuração do Android Studio

1. Baixe e instale o [Android Studio](https://developer.android.com/studio)
2. Execute o Android Studio e siga o assistente de configuração
3. Instale os plugins Flutter e Dart:
   - Navegue até **Plugins** > **Marketplace**
   - Pesquise por "Flutter" e instale o plugin
   - O plugin Dart será instalado automaticamente
4. Configure um emulador Android:
   - Navegue até **Tools** > **AVD Manager**
   - Clique em **Create Virtual Device**
   - Selecione um dispositivo e imagem do sistema (API 30+ recomendada)
   - Finalize a configuração e inicie o emulador

### 3. Configuração do Xcode (para macOS)

1. Instale o Xcode a partir da App Store
2. Instale as ferramentas de linha de comando:
   ```bash
   xcode-select --install
   ```
3. Configure o simulador iOS:
   ```bash
   open -a Simulator
   ```

### 4. Configuração do Firebase

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
2. Adicione seu aplicativo:
   - Para Android: Adicione um novo app Android usando o pacote `com.alacarte.app`
   - Para iOS: Adicione um novo app iOS usando o bundle ID `com.alacarte.app`
3. Baixe os arquivos de configuração:
   - `google-services.json` para Android
   - `GoogleService-Info.plist` para iOS
4. Coloque os arquivos nos diretórios apropriados:
   - Android: `android/app/`
   - iOS: Adicione ao projeto via Xcode

### 5. Clone o Repositório

```bash
git clone https://github.com/seu-usuario/a-lacarte.git
cd a-lacarte
```

### 6. Instale as Dependências

```bash
flutter pub get
```

### 7. Configure Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```env
AI_API_KEY=sua_chave_api_aqui
AI_API_URL=https://api.alacarte-ai.example.com/v1
```

## Estrutura do Projeto

```
lib/
├── core/               # Utilitários e componentes compartilhados
├── data/               # Camada de dados (repositórios, fontes de dados)
│   ├── models/         # Modelos de dados
│   ├── repositories/   # Implementações de repositórios
│   └── sources/        # Fontes de dados (API, local)
├── domain/             # Camada de domínio
│   ├── entities/       # Entidades de negócio
│   ├── repositories/   # Interfaces de repositórios
│   └── usecases/       # Casos de uso
├── presentation/       # Camada de apresentação
│   ├── screens/        # Telas do aplicativo
│   ├── widgets/        # Widgets reutilizáveis
│   └── providers/      # Provedores de estado
└── main.dart           # Ponto de entrada do aplicativo
```

## Comandos Úteis

### Executar o Aplicativo

```bash
# Executar em modo de desenvolvimento
flutter run

# Especificar um dispositivo
flutter run -d <device_id>

# Verificar dispositivos disponíveis
flutter devices
```

### Compilar o Aplicativo

```bash
# Compilar APK de debug
flutter build apk --debug

# Compilar APK de release
flutter build apk --release

# Compilar IPA para iOS (apenas em macOS)
flutter build ios --release
```

### Testes

```bash
# Executar todos os testes
flutter test

# Executar um teste específico
flutter test test/path/to/test.dart

# Executar testes com cobertura
flutter test --coverage
```

### Limpar e Reconstruir

```bash
# Limpar a compilação anterior
flutter clean

# Obter pacotes novamente
flutter pub get
```

## Padrões de Código

### Regras de Estilo

- Utilize o [Effective Dart](https://dart.dev/guides/language/effective-dart) para formatação
- Execute `flutter format .` para formatar automaticamente
- Use `flutter analyze` para verificar problemas

### Convenções de Nomenclatura

- **Classes:** PascalCase
- **Variáveis e métodos:** camelCase
- **Constantes:** SNAKE_CASE ou kCamelCase
- **Arquivos:** snake_case.dart

### Gerenciamento de Estado

Utilizamos [Provider/Bloc/Riverpod] para gerenciamento de estado.

### Dependências Principais

- `firebase_core`, `firebase_auth`, `cloud_firestore`
- `http` ou `dio` para requisições HTTP
- `shared_preferences` para armazenamento local simples
- `sqflite` para banco de dados local
- `provider` ou `flutter_bloc` para gerenciamento de estado

## Fluxo de Trabalho do Git

1. **Branches:**
   - `main`: Código estável de produção
   - `develop`: Branch de desenvolvimento
   - `feature/*`: Para novas funcionalidades
   - `bugfix/*`: Para correções de bugs

2. **Processo:**
   - Crie um branch a partir de `develop`
   - Desenvolva a funcionalidade
   - Crie um Pull Request para `develop`
   - Após revisão, faça merge

## Problemas Comuns e Soluções

### Erro de Versão do Flutter

**Problema:** Conflitos de versão entre o Flutter instalado e o projeto.
**Solução:** Execute `flutter upgrade` ou use o Flutter version manager (FVM).

### Erros de dependências

**Problema:** Conflitos ou falhas ao obter pacotes.
**Solução:** Execute `flutter clean` e depois `flutter pub get`.

### Falha na Compilação para iOS

**Problema:** Erros de compilação específicos para iOS.
**Solução:** Verifique o CocoaPods com `pod install` dentro de `ios/`.

## Suporte e Recursos Adicionais

- [Documentação do Flutter](https://flutter.dev/docs)
- [Canal do Discord da Equipe](#)
- [Jira/Trello do Projeto](#)
