# Arquitetura do À LaCarte

Este documento descreve a arquitetura técnica de alto nível do aplicativo À LaCarte, incluindo os principais componentes, padrões de design e fluxo de dados.

## Visão Geral da Arquitetura

O À LaCarte segue uma arquitetura Clean Architecture com princípios de SOLID e padrão de gerenciamento de estado reativo.

### Diagrama Arquitetural

```
┌───────────────────────────────────┐
│             Presentation          │
│  (UI, Widgets, Screen, ViewModels)│
└───────────────┬───────────────────┘
                │
┌───────────────▼───────────────────┐
│              Domain               │
│   (Use Cases, Entities, Services) │
└───────────────┬───────────────────┘
                │
┌───────────────▼───────────────────┐
│           Data Layer              │
│    (Repositories, Data Sources)   │
└───────────────┬───────────────────┘
                │
┌───────────────▼───────────────────┐
│       External Interfaces         │
│  (Firebase, API, Local Storage)   │
└───────────────────────────────────┘
```

## Camadas da Aplicação

### 1. Presentation Layer (Camada de Apresentação)

Responsável por exibir os dados ao usuário e gerenciar interações.

**Componentes:**
- **Screens:** Páginas do aplicativo (SplashScreen, HomePage, etc.)
- **Widgets:** Componentes reutilizáveis da UI
- **ViewModels:** Gerenciam o estado da UI e processam eventos

**Tecnologias:**
- Flutter Widgets
- Gerenciamento de Estado: [Provider/Bloc/Riverpod] (a definir)

### 2. Domain Layer (Camada de Domínio)

Contém a lógica de negócios da aplicação, independente de UI ou infraestrutura.

**Componentes:**
- **Entidades:** Modelos de dados principais (Receita, Ingrediente, Usuário)
- **Use Cases:** Implementam funcionalidades específicas do negócio
- **Interfaces Repository:** Definem contratos para acesso a dados

### 3. Data Layer (Camada de Dados)

Responsável pela obtenção e persistência de dados.

**Componentes:**
- **Repositories:** Implementam interfaces definidas no domínio
- **Data Sources:** Fornecem dados de fontes específicas
- **Models:** Representações de dados para transferência

### 4. External Interfaces (Interfaces Externas)

Implementações concretas para comunicação com serviços externos.

**Componentes:**
- **Firebase Services:** Auth, Firestore, Storage
- **AI API Client:** Cliente para comunicação com API de IA
- **Local Storage:** Implementação para armazenamento local

## Fluxo de Dados Principais

### Fluxo de Recomendação de Receita

1. Usuário insere ingredientes na UI
2. ViewModel captura evento e solicita use case
3. Use case de recomendação chama repository
4. Repository consulta AI API Client
5. Resposta retorna pelo mesmo caminho até a UI

### Fluxo de Autenticação

1. Usuário fornece credenciais na UI
2. ViewModel encaminha para AuthUseCase
3. AuthUseCase chama AuthRepository
4. Repository utiliza FirebaseAuth
5. Resultado da autenticação retorna à UI

## Gerenciamento de Estado

O aplicativo utiliza um padrão de gerenciamento de estado reativo para:

- Atualização de UI baseada em mudanças de estado
- Comunicação entre componentes
- Tratamento de operações assíncronas

## Estratégias de Cache e Modo Offline

- **Cache de Dados:** Armazenamento local de dados comuns para reduzir chamadas de rede
- **Sincronização:** Estratégia para sincronizar dados locais quando a conexão for retomada
- **Queue de Operações:** Salva operações quando offline para execução posterior

## Segurança

- Autenticação gerenciada pelo Firebase Auth
- Regras de segurança do Firestore para controle de acesso
- Dados sensíveis não armazenados localmente
- Comunicação criptografada com APIs

## Considerações de Performance

- Carregamento lazy de dados e imagens
- Paginação em listas longas
- Compressão de imagens antes do upload
- Cache de consultas frequentes

## Evolução e Escalabilidade

A arquitetura foi projetada para facilitar:

- Adição de novas fontes de dados
- Integração com serviços adicionais
- Expansão para novos recursos
- Testes unitários e de integração
