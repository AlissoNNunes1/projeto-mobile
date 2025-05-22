import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';

/// [IngredientsInputScreen] permite que os usuários adicionem e gerenciem os ingredientes
/// que têm disponíveis para gerar receitas personalizadas.
class IngredientsInputScreen extends StatefulWidget {
  const IngredientsInputScreen({super.key});

  @override
  State<IngredientsInputScreen> createState() => _IngredientsInputScreenState();
}

class _IngredientsInputScreenState extends State<IngredientsInputScreen> {
  final _searchController = TextEditingController();
  final List<String> _selectedIngredients = [];
  bool _isSearching = false;

  // Lista de ingredientes sugeridos (exemplo)
  final List<String> _suggestedIngredients = [
    'Arroz', 'Feijão', 'Batata', 'Cenoura', 'Frango',
    'Carne Moída', 'Tomate', 'Cebola', 'Alho', 'Pimentão',
    'Azeite', 'Sal', 'Pimenta', 'Leite', 'Queijo',
    'Ovo', 'Farinha de Trigo', 'Açúcar', 'Manteiga', 'Óleo',
  ];

  // Resultados da busca
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // Inicialmente os resultados são os ingredientes sugeridos
    _searchResults = [..._suggestedIngredients];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectIngredient(String ingredient) {
    if (!_selectedIngredients.contains(ingredient)) {
      setState(() {
        _selectedIngredients.add(ingredient);
      });
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _selectedIngredients.remove(ingredient);
    });
  }

  void _searchIngredients(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [..._suggestedIngredients];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _suggestedIngredients
          .where((ingredient) => ingredient.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _findRecipes() {
    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione ao menos um ingrediente para continuar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implementar a busca de receitas com os ingredientes selecionados
    // Por enquanto, apenas volta para a tela inicial
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Ingredientes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar ingredientes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchIngredients('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
              ),
              onChanged: _searchIngredients,
            ),
          ),

          // Ingredientes selecionados
          if (_selectedIngredients.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingredientes Selecionados (${_selectedIngredients.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedIngredients.map((ingredient) {
                      return Chip(
                        label: Text(ingredient),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => _removeIngredient(ingredient),
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        deleteIconColor: Theme.of(context).colorScheme.primary,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

          // Resultados da busca ou ingredientes sugeridos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isSearching ? 'Resultados da Busca' : 'Ingredientes Sugeridos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _searchResults.isEmpty
                        ? Center(
                            child: Text(
                              'Nenhum ingrediente encontrado',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final ingredient = _searchResults[index];
                              final isSelected = _selectedIngredients.contains(ingredient);
                              
                              return InkWell(
                                onTap: () => isSelected
                                    ? _removeIngredient(ingredient)
                                    : _selectIngredient(ingredient),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isSelected ? Icons.check : Icons.add,
                                        color: isSelected
                                            ? Colors.white
                                            : Theme.of(context).colorScheme.primary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        ingredient,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryButton(
                onPressed: _findRecipes,
                text: 'Encontrar Receitas',
                icon: Icons.search,
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                onPressed: () => context.pop(),
                text: 'Cancelar',
                outlined: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
