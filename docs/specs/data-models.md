# Modelos de Dados - À LaCarte

Este documento detalha os principais modelos de dados utilizados no aplicativo À LaCarte, incluindo suas propriedades, relacionamentos e armazenamento.

## Visão Geral

O aplicativo utiliza um conjunto de modelos de dados que representam as entidades principais do sistema. Estes modelos são utilizados em diferentes camadas da aplicação:

1. **Entidades de Domínio**: Representações puras dos conceitos de negócio
2. **Modelos de Dados**: Implementações com anotações específicas para persistência
3. **DTOs** (Data Transfer Objects): Objetos para comunicação com APIs externas

## Modelos Principais

### 1. Usuário (User)

Representa um usuário registrado no aplicativo.

```dart
class User {
  final String id;           // ID único (do Firebase Auth)
  final String email;        // Email do usuário
  final String? displayName; // Nome de exibição
  final String? photoUrl;    // URL da foto de perfil
  final DateTime createdAt;  // Data de criação da conta
  final List<String> dietaryRestrictions; // Restrições alimentares
  final Map<String, dynamic> preferences; // Outras preferências do usuário
  
  // Construtores e métodos...
}
```

**Armazenamento**: Firebase Firestore (coleção `users`)

### 2. Receita (Recipe)

Representa uma receita completa.

```dart
class Recipe {
  final String id;           // ID único
  final String title;        // Nome da receita
  final String description;  // Descrição curta
  final String imageUrl;     // URL da imagem principal
  final int prepTime;        // Tempo de preparo (minutos)
  final int cookTime;        // Tempo de cozimento (minutos)
  final int servings;        // Número de porções
  final String difficulty;   // Nível de dificuldade (easy, medium, hard)
  final List<RecipeIngredient> ingredients; // Ingredientes
  final List<String> steps;  // Passos do preparo
  final Map<String, dynamic> nutrition; // Informações nutricionais
  final List<String> tags;   // Tags (categorias)
  final double rating;       // Avaliação média
  final int ratingCount;     // Número de avaliações
  final String? sourceId;    // ID/referência para fonte externa (API)
  final DateTime createdAt;  // Data de criação/adição ao sistema
  
  // Construtores e métodos...
}
```

**Armazenamento**: 
- Firebase Firestore (coleção `recipes`)
- SQLite local para modo offline

### 3. Ingrediente da Receita (RecipeIngredient)

Representa um ingrediente no contexto de uma receita específica.

```dart
class RecipeIngredient {
  final String name;      // Nome do ingrediente
  final double quantity;  // Quantidade
  final String unit;      // Unidade de medida (g, ml, colher, etc.)
  final String? notes;    // Observações específicas (opcional)
  
  // Construtores e métodos...
}
```

**Armazenamento**: Embutido dentro de Recipe

### 4. Ingrediente (Ingredient)

Representa um ingrediente genérico no sistema.

```dart
class Ingredient {
  final String id;           // ID único
  final String name;         // Nome do ingrediente
  final String? category;    // Categoria (vegetais, proteínas, etc.)
  final String? imageUrl;    // URL da imagem do ingrediente
  final Map<String, String>? alternativeMeasurements; // Conversões de medidas
  final List<String>? commonSubstitutes; // Substitutos comuns
  
  // Construtores e métodos...
}
```

**Armazenamento**: 
- Firebase Firestore (coleção `ingredients`)
- Cache local para autocomplete

### 5. Favorito (Favorite)

Representa uma marcação de favorito de uma receita por um usuário.

```dart
class Favorite {
  final String id;        // ID único
  final String userId;    // ID do usuário que favoritou
  final String recipeId;  // ID da receita favoritada
  final DateTime addedAt; // Data de adição aos favoritos
  final String? collectionId; // ID da coleção (opcional)
  
  // Construtores e métodos...
}
```

**Armazenamento**: 
- Firebase Firestore (coleção `favorites`)
- SQLite local para modo offline

### 6. Coleção (Collection)

Representa um agrupamento personalizado de receitas criado pelo usuário.

```dart
class Collection {
  final String id;           // ID único
  final String name;         // Nome da coleção
  final String userId;       // ID do usuário dono da coleção
  final String? description; // Descrição opcional
  final String? imageUrl;    // Imagem de capa (opcional)
  final DateTime createdAt;  // Data de criação
  final List<String> recipeIds; // IDs das receitas na coleção
  
  // Construtores e métodos...
}
```

**Armazenamento**: Firebase Firestore (coleção `collections`)

### 7. Histórico (History)

Registra interações do usuário com receitas.

```dart
class History {
  final String id;        // ID único
  final String userId;    // ID do usuário
  final String recipeId;  // ID da receita
  final DateTime viewedAt; // Data e hora da visualização
  final bool wasPrepared; // Se o usuário marcou como preparada
  final String? notes;    // Notas pessoais (opcional)
  
  // Construtores e métodos...
}
```

**Armazenamento**:
- Firebase Firestore (coleção `history`)
- SQLite local para acesso offline

### 8. Avaliação (Rating)

Avaliação e comentário de um usuário sobre uma receita.

```dart
class Rating {
  final String id;        // ID único
  final String userId;    // ID do usuário que avaliou
  final String recipeId;  // ID da receita avaliada
  final int score;        // Pontuação (1-5)
  final String? comment;  // Comentário (opcional)
  final DateTime createdAt; // Data da avaliação
  final List<String> likes; // IDs de usuários que curtiram este comentário
  
  // Construtores e métodos...
}
```

**Armazenamento**: Firebase Firestore (subcoleção dentro de `recipes`)

### 9. Lista de Compras (ShoppingList)

Lista de itens para compras gerada a partir de receitas.

```dart
class ShoppingList {
  final String id;        // ID único
  final String userId;    // ID do usuário dono da lista
  final String? name;     // Nome da lista (opcional)
  final List<ShoppingItem> items; // Itens da lista
  final DateTime createdAt; // Data de criação
  final DateTime? updatedAt; // Última atualização
  
  // Construtores e métodos...
}

class ShoppingItem {
  final String ingredientName; // Nome do ingrediente
  final double quantity;       // Quantidade
  final String unit;           // Unidade
  final bool isChecked;        // Se foi marcado como comprado
  final String? recipeId;      // Receita de origem (opcional)
  
  // Construtores e métodos...
}
```

**Armazenamento**:
- Firebase Firestore (coleção `shopping_lists`)
- SQLite local para acesso offline

### 10. Preferências do Usuário (UserPreferences)

Configurações e preferências do usuário.

```dart
class UserPreferences {
  final String userId;    // ID do usuário
  final List<String> dietaryRestrictions; // Restrições alimentares
  final List<String> cuisinePreferences; // Cozinhas preferidas
  final Map<String, bool> notificationSettings; // Configurações de notificação
  final String? measurementSystem; // Sistema de medidas (metric, imperial)
  final String? language; // Idioma preferido
  final Map<String, dynamic> uiSettings; // Configurações de interface
  
  // Construtores e métodos...
}
```

**Armazenamento**:
- Firebase Firestore (subcoleção de `users`)
- SharedPreferences para configurações locais

## Relacionamentos entre Modelos

```
User 1:N History
User 1:N Favorite
User 1:N Rating
User 1:1 UserPreferences
User 1:N ShoppingList
User 1:N Collection

Recipe 1:N Rating
Recipe 1:N RecipeIngredient
Recipe N:N Collection (via Favorite)

Collection 1:N Recipe (via recipeIds)

ShoppingList 1:N ShoppingItem
```

## Mapeamento para Firestore

### Coleções Principais
- `users/{userId}`
- `recipes/{recipeId}`
- `ingredients/{ingredientId}`
- `favorites/{favoriteId}`
- `collections/{collectionId}`
- `history/{historyId}`
- `shopping_lists/{listId}`

### Subcoleções
- `users/{userId}/preferences`
- `recipes/{recipeId}/ratings`

## Estratégias de Armazenamento e Sync

### Firebase Firestore
- Dados primários sincronizados na nuvem
- Regras de segurança para controle de acesso
- Consultas otimizadas com índices compostos

### SQLite Local
- Cache de receitas, histórico e favoritos
- Versão offline de dados críticos
- Sincronização em background quando online

### SharedPreferences
- Configurações do aplicativo
- Preferências de UI
- Cache de sessão

## Modelos para API de IA

### Solicitação de Recomendação
```dart
class RecommendationRequest {
  final List<String> ingredients;
  final Map<String, dynamic> preferences;
  final Map<String, dynamic> context;
  final int limit;
  final int offset;
  
  // Construtores e métodos...
}
```

### Resposta de Recomendação
```dart
class RecommendationResponse {
  final List<Recipe> recipes;
  final int totalResults;
  final int nextOffset;
  
  // Construtores e métodos...
}
```

## Serialização e Deserialização

Os modelos implementam métodos para:

- Conversão de/para JSON
- Mapeamento de/para documentos Firestore
- Adaptação para modelos locais (SQLite)

Exemplo de implementação de serialização:

```dart
class Recipe {
  // ...atributos...
  
  // De JSON para objeto
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      prepTime: json['prep_time'],
      // ... outros campos
    );
  }
  
  // De objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'prep_time': prepTime,
      // ... outros campos
    };
  }
}
```
