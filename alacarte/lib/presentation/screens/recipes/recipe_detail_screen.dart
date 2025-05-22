import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';

/// [RecipeDetailScreen] exibe os detalhes de uma receita específica.
/// Inclui ingredientes, instruções, informações nutricionais e outras opções.
class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool _isFavorite = false;
  int _currentStep = 0;
  int _servings = 2;

  // Dados fictícios para demonstração
  late final Map<String, dynamic> _recipeData = {
    'id': widget.recipeId,
    'title': 'Risoto de Cogumelos',
    'description': 'Um delicioso risoto cremoso com cogumelos frescos e queijo parmesão.',
    'image': 'https://via.placeholder.com/400x300?text=Risoto+de+Cogumelos',
    'prepTime': 15,
    'cookTime': 30,
    'servings': 2,
    'difficulty': 'Médio',
    'calories': 450,
    'protein': 12,
    'carbs': 65,
    'fat': 18,
    'ingredients': [
      {'name': 'Arroz arbóreo', 'quantity': '1', 'unit': 'xícara'},
      {'name': 'Cogumelos', 'quantity': '200', 'unit': 'g'},
      {'name': 'Cebola', 'quantity': '1', 'unit': 'unidade'},
      {'name': 'Alho', 'quantity': '2', 'unit': 'dentes'},
      {'name': 'Vinho branco', 'quantity': '1/4', 'unit': 'xícara'},
      {'name': 'Caldo de legumes', 'quantity': '4', 'unit': 'xícaras'},
      {'name': 'Queijo parmesão', 'quantity': '1/2', 'unit': 'xícara'},
      {'name': 'Manteiga', 'quantity': '2', 'unit': 'colheres de sopa'},
      {'name': 'Sal e pimenta', 'quantity': '', 'unit': 'a gosto'},
    ],
    'steps': [
      'Pique a cebola e o alho finamente. Corte os cogumelos em fatias.',
      'Em uma panela média, aqueça metade da manteiga e refogue a cebola e o alho até ficarem transparentes.',
      'Adicione os cogumelos e refogue por mais 3 minutos.',
      'Acrescente o arroz e mexa por 1-2 minutos até que fique levemente translúcido.',
      'Adicione o vinho branco e mexa até evaporar completamente.',
      'Comece a adicionar o caldo de legumes, uma concha por vez, mexendo frequentemente. Adicione mais caldo apenas quando o anterior for absorvido.',
      'Continue esse processo por cerca de 18-20 minutos, até que o arroz esteja al dente.',
      'Retire do fogo e adicione o restante da manteiga e o queijo parmesão. Mexa bem.',
      'Ajuste o sal e a pimenta, e sirva imediatamente.'
    ],
    'tags': ['Vegetariano', 'Italiano', 'Sem Glúten'],
    'rating': 4.7,
    'reviews': 24,
  };

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // TODO: Implementar lógica para salvar nos favoritos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite 
            ? 'Adicionado aos favoritos' 
            : 'Removido dos favoritos'),
        backgroundColor: _isFavorite 
            ? Theme.of(context).colorScheme.primary 
            : Colors.grey.shade700,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _changeServings(int newValue) {
    setState(() {
      _servings = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar com imagem de fundo
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // TODO: Implementar compartilhamento
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagem da receita
                  Image.network(
                    _recipeData['image'],
                    fit: BoxFit.cover,
                  ),
                  // Gradiente para melhorar legibilidade do título
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                  // Título e informações básicas
                  Positioned(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _recipeData['title'],
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_recipeData['prepTime'] + _recipeData['cookTime']} min',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.restaurant,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$_servings porções',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _recipeData['rating'].toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${_recipeData['reviews']})',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Descrição
                  Text(
                    _recipeData['description'],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),

                  // Tags
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      for (var tag in _recipeData['tags'])
                        Chip(
                          label: Text(tag),
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Informações nutricionais
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informações Nutricionais',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildNutrientInfo('Calorias', '${_recipeData['calories']}', 'kcal'),
                              _buildNutrientInfo('Proteínas', '${_recipeData['protein']}', 'g'),
                              _buildNutrientInfo('Carboidratos', '${_recipeData['carbs']}', 'g'),
                              _buildNutrientInfo('Gorduras', '${_recipeData['fat']}', 'g'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Número de porções
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Porções',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _servings > 1 ? () => _changeServings(_servings - 1) : null,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text(
                            '$_servings',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _changeServings(_servings + 1),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Ingredientes
                  Text(
                    'Ingredientes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(
                    _recipeData['ingredients'].length,
                    (index) {
                      final ingredient = _recipeData['ingredients'][index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.fiber_manual_record, size: 12),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: ingredient['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (ingredient['quantity'].isNotEmpty || ingredient['unit'].isNotEmpty)
                                      TextSpan(
                                        text: ' - ${ingredient['quantity']} ${ingredient['unit']}',
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Modo de preparo
                  Text(
                    'Modo de Preparo',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Stepper(
                    currentStep: _currentStep,
                    onStepTapped: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    controlsBuilder: (context, details) {
                      return Row(
                        children: [
                          if (details.currentStep > 0)
                            TextButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Anterior'),
                            ),
                          if (details.currentStep < _recipeData['steps'].length - 1) ...[
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: const Text('Próximo'),
                            ),
                          ],
                        ],
                      );
                    },
                    onStepContinue: () {
                      if (_currentStep < _recipeData['steps'].length - 1) {
                        setState(() {
                          _currentStep++;
                        });
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() {
                          _currentStep--;
                        });
                      }
                    },
                    steps: List.generate(
                      _recipeData['steps'].length,
                      (index) => Step(
                        title: Text('Passo ${index + 1}'),
                        content: Text(_recipeData['steps'][index]),
                        isActive: _currentStep >= index,
                        state: _currentStep > index
                            ? StepState.complete
                            : _currentStep == index
                                ? StepState.editing
                                : StepState.indexed,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Avaliações (seção de exemplo)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Avaliações',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navegar para todas as avaliações
                        },
                        child: const Text('Ver todas'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Exemplo de avaliação
                  Card(
                    elevation: 0,
                    color: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                child: Text('JD'),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'João Silva',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      Icon(
                                        Icons.star_half,
                                        size: 16,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                '2 dias atrás',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Receita incrível e muito fácil de fazer! O risoto ficou cremoso e os cogumelos deram um sabor especial. Recomendo muito!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      // Botão de ação no final
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SecondaryButton(
                onPressed: () {
                  // TODO: Implement pantry check
                  double compatibility = 85.0; // exemplo
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Compatibilidade com sua despensa'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Você possui ${compatibility.toStringAsFixed(0)}% dos ingredientes necessários.'),
                          const SizedBox(height: 8),
                          Text('Faltam:'),
                          const SizedBox(height: 4),
                          Text('- Vinho branco'),
                          Text('- Queijo parmesão'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Fechar'),
                        ),
                      ],
                    ),
                  );
                },
                text: 'Verificar Ingredientes',
                height: 48,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                onPressed: () {
                  // TODO: Implement "começar a cozinhar" mode
                  context.push('/cooking/${widget.recipeId}');
                },
                text: 'Começar a Cozinhar',
                icon: Icons.restaurant_menu,
                height: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
