import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [FavoritesScreen] exibe as receitas favoritas do usuário.
/// Permite visualizar, filtrar e gerenciar as receitas salvas.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Lista de receitas favoritas (exemplo)
  final List<Map<String, dynamic>> _favorites = [
    {
      'id': '1',
      'title': 'Risoto de Cogumelos',
      'image': 'https://via.placeholder.com/400x300?text=Risoto+de+Cogumelos',
      'time': 45,
      'difficulty': 'Médio',
      'calories': 450,
      'tags': ['Vegetariano', 'Italiano'],
    },
    {
      'id': '2',
      'title': 'Frango ao Curry',
      'image': 'https://via.placeholder.com/400x300?text=Frango+ao+Curry',
      'time': 35,
      'difficulty': 'Fácil',
      'calories': 380,
      'tags': ['Proteína', 'Indiano'],
    },
    {
      'id': '3',
      'title': 'Bolo de Cenoura',
      'image': 'https://via.placeholder.com/400x300?text=Bolo+de+Cenoura',
      'time': 60,
      'difficulty': 'Fácil',
      'calories': 320,
      'tags': ['Sobremesa', 'Vegetariano'],
    },
    {
      'id': '4',
      'title': 'Salada Caesar',
      'image': 'https://via.placeholder.com/400x300?text=Salada+Caesar',
      'time': 15,
      'difficulty': 'Fácil',
      'calories': 280,
      'tags': ['Salada', 'Rápido'],
    },
    {
      'id': '5',
      'title': 'Lasanha à Bolonhesa',
      'image': 'https://via.placeholder.com/400x300?text=Lasanha+à+Bolonhesa',
      'time': 80,
      'difficulty': 'Médio',
      'calories': 520,
      'tags': ['Massa', 'Italiano'],
    },
  ];

  List<Map<String, dynamic>> _filteredFavorites = [];
  
  @override
  void initState() {
    super.initState();
    _filteredFavorites = [..._favorites];
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _searchFavorites(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFavorites = [..._favorites];
      });
      return;
    }
    
    setState(() {
      _filteredFavorites = _favorites
          .where((favorite) => 
              favorite['title'].toLowerCase().contains(query.toLowerCase()) ||
              favorite['tags'].any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }
  
  void _removeFromFavorites(String id) {
    setState(() {
      _favorites.removeWhere((favorite) => favorite['id'] == id);
      _filteredFavorites = [..._favorites];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receita removida dos favoritos'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Favoritas'),
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
                hintText: 'Buscar favoritos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchFavorites('');
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
              onChanged: _searchFavorites,
            ),
          ),

          // Resultados da busca
          Expanded(
            child: _filteredFavorites.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma receita favorita encontrada',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adicione receitas aos favoritos para vê-las aqui',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade500,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredFavorites.length,
                    itemBuilder: (context, index) {
                      final favorite = _filteredFavorites[index];
                      return Dismissible(
                        key: Key(favorite['id']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          _removeFromFavorites(favorite['id']);
                        },
                        child: GestureDetector(
                          onTap: () => context.push('/recipe/${favorite['id']}'),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // Imagem da receita
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    favorite['image'],
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Informações da receita
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          favorite['title'],
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        // Informações adicionais
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.timer_outlined,
                                              size: 16,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${favorite['time']} min',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Icon(
                                              Icons.local_fire_department_outlined,
                                              size: 16,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${favorite['calories']} kcal',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        // Tags
                                        Wrap(
                                          spacing: 4,
                                          children: [
                                            for (final tag in favorite['tags'])
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  tag,
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Botão de remover dos favoritos
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                    onPressed: () => _removeFromFavorites(favorite['id']),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
