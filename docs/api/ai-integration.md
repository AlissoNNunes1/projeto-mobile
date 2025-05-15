# Integração com API de IA - À LaCarte

Este documento detalha a integração do aplicativo À LaCarte com a API de inteligência artificial para recomendação de receitas.

## Visão Geral

O aplicativo utiliza uma API de IA externa para:

1. **Recomendação de receitas** baseada em ingredientes disponíveis
2. **Análise de imagens** para reconhecimento de ingredientes
3. **Processamento de áudio** para captura de ingredientes por voz
4. **Personalização** com base no histórico e preferências do usuário

## Especificações da API

### Endpoint Base

```
https://api.alacarte-ai.example.com/v1/
```

> Nota: Este é um endpoint de exemplo. A URL real deve ser configurada no ambiente adequado.

### Autenticação

A API utiliza autenticação por token JWT:

```
Authorization: Bearer <token>
```

### Endpoints Principais

#### 1. Recomendação de Receitas

**Endpoint:** `/recipes/recommend`

**Método:** POST

**Payload:**

```json
{
  "ingredients": ["tomate", "queijo", "farinha", "ovo"],
  "preferences": {
    "dietary_restrictions": ["vegetariano", "sem glúten"],
    "meal_type": "almoço",
    "prep_time_max": 30,
    "cuisine_preferences": ["italiana", "brasileira"]
  },
  "context": {
    "user_history": ["12345", "67890"], // IDs das receitas visualizadas
    "favorites": ["24680", "13579"],    // IDs das receitas favoritas
    "ratings": [                        // Avaliações do usuário
      {"recipe_id": "12345", "rating": 4},
      {"recipe_id": "67890", "rating": 5}
    ]
  },
  "limit": 5,                           // Quantidade de receitas
  "offset": 0                           // Paginação
}
```

**Resposta:**

```json
{
  "recipes": [
    {
      "id": "recipe_001",
      "title": "Omelete de Queijo e Tomate",
      "image_url": "https://storage.example.com/recipes/omelete.jpg",
      "description": "Uma omelete leve e saborosa",
      "prep_time": 15,
      "servings": 2,
      "ingredients": [
        {"name": "ovo", "quantity": 3, "unit": "unidade"},
        {"name": "tomate", "quantity": 1, "unit": "unidade"},
        {"name": "queijo", "quantity": 50, "unit": "g"}
      ],
      "steps": [
        "Bata os ovos em uma tigela",
        "Adicione o tomate picado e o queijo ralado",
        "Aqueça uma frigideira antiaderente",
        "Despeje a mistura e cozinhe em fogo médio por 3-4 minutos de cada lado"
      ],
      "nutrition": {
        "calories": 280,
        "protein": 18,
        "carbs": 4,
        "fat": 21
      },
      "tags": ["rápido", "vegetariano", "café da manhã"]
    },
    // ... outras receitas ...
  ],
  "total_results": 42,
  "next_offset": 5
}
```

#### 2. Reconhecimento de Ingredientes por Imagem

**Endpoint:** `/ingredients/recognize`

**Método:** POST

**Content-Type:** `multipart/form-data`

**Parâmetros:**
- `image`: Arquivo de imagem (JPEG, PNG)
- `confidence_threshold` (opcional): Nível mínimo de confiança (0.0-1.0)

**Resposta:**

```json
{
  "ingredients": [
    {"name": "tomate", "confidence": 0.97},
    {"name": "cebola", "confidence": 0.94},
    {"name": "alho", "confidence": 0.85},
    {"name": "pimentão", "confidence": 0.76}
  ],
  "suggestions": [
    {"name": "receita de molho", "relevance": 0.89},
    {"name": "salada", "relevance": 0.72}
  ]
}
```

#### 3. Processamento de Áudio

**Endpoint:** `/speech/ingredients`

**Método:** POST

**Content-Type:** `multipart/form-data`

**Parâmetros:**
- `audio`: Arquivo de áudio (WAV, MP3)
- `language` (opcional): Código do idioma (default: "pt-BR")

**Resposta:**

```json
{
  "text": "eu tenho tomate cebola alho e azeite",
  "ingredients": [
    {"name": "tomate", "confidence": 0.98},
    {"name": "cebola", "confidence": 0.97},
    {"name": "alho", "confidence": 0.95},
    {"name": "azeite", "confidence": 0.93}
  ],
  "confidence": 0.94
}
```

## Implementação no App

### Camada de Serviço

```dart
class AIServiceImpl implements AIService {
  final Dio _dio;
  final String _baseUrl;
  final String _apiKey;
  
  AIServiceImpl({
    required String baseUrl,
    required String apiKey,
    Dio? dioClient
  }) : 
    _baseUrl = baseUrl,
    _apiKey = apiKey,
    _dio = dioClient ?? Dio();
  
  @override
  Future<List<Recipe>> getRecipeRecommendations({
    required List<String> ingredients,
    PreferenceSettings? preferences,
    UserContext? context,
    int limit = 10,
    int offset = 0
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/recipes/recommend',
        options: Options(
          headers: {'Authorization': 'Bearer $_apiKey'}
        ),
        data: {
          'ingredients': ingredients,
          'preferences': preferences?.toJson(),
          'context': context?.toJson(),
          'limit': limit,
          'offset': offset
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        return (data['recipes'] as List)
          .map((recipeJson) => Recipe.fromJson(recipeJson))
          .toList();
      } else {
        throw Exception('Failed to get recommendations: ${response.statusCode}');
      }
    } catch (e) {
      throw AIServiceException('Error fetching recipe recommendations: $e');
    }
  }
  
  @override
  Future<List<Ingredient>> recognizeIngredientsFromImage(File image) async {
    // Implementação similar para reconhecimento de imagem
  }
  
  @override
  Future<List<Ingredient>> recognizeIngredientsFromAudio(File audio) async {
    // Implementação similar para processamento de áudio
  }
}
```

### Modelo de Dados

```dart
class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final int prepTime;
  final int servings;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final NutritionInfo? nutrition;
  final List<String> tags;
  
  // Construtor e métodos de fábrica (fromJson)
}

class RecipeIngredient {
  final String name;
  final double quantity;
  final String unit;
  
  // Construtor e métodos de fábrica (fromJson)
}

class UserContext {
  final List<String> userHistory;
  final List<String> favorites;
  final List<Rating> ratings;
  
  Map<String, dynamic> toJson() {
    return {
      'user_history': userHistory,
      'favorites': favorites,
      'ratings': ratings.map((r) => r.toJson()).toList(),
    };
  }
}
```

## Estratégias de Cache

Para otimizar o desempenho e reduzir chamadas à API:

1. **Cache de receitas recomendadas**:
   - Armazenar localmente por 24 horas
   - Invalidar cache quando novos ingredientes são adicionados

2. **Cache de reconhecimento de imagem**:
   - Armazenar hash da imagem com resultados
   - Cache expira após 7 dias

3. **Resultados frequentes**:
   - Pré-carregar combinações comuns de ingredientes

## Tratamento de Erros

| Código | Descrição | Estratégia |
|--------|-----------|------------|
| 400 | Requisição inválida | Validar dados antes do envio |
| 401 | Não autorizado | Renovar token e tentar novamente |
| 429 | Muitas requisições | Implementar exponential backoff |
| 503 | Serviço indisponível | Usar cache offline e notificar usuário |

## Monitoramento e Analytics

Métricas a serem rastreadas:

- Taxa de aceitação de recomendações
- Precisão do reconhecimento de imagem/áudio
- Latência média de respostas da API
- Taxa de falhas por tipo de requisição

## Próximos Passos e Melhorias

1. **Personalização avançada**: Incorporar mais contexto do usuário para melhorar recomendações
2. **Reconhecimento em tempo real**: Usar câmera para identificação instantânea
3. **Adaptação nutricional**: Ajustar receitas às necessidades nutricionais
4. **Modos de conversa**: Interface conversacional para refinamento de receitas
