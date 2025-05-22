import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// [HistoryScreen] exibe o histórico de receitas visualizadas pelo usuário.
/// Permite ver e acessar receitas consultadas anteriormente.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Lista de histórico (exemplo)
  final List<Map<String, dynamic>> _historyItems = [
    {
      'id': '1',
      'title': 'Risoto de Cogumelos',
      'image': 'https://via.placeholder.com/400x300?text=Risoto+de+Cogumelos',
      'viewedAt': DateTime.now().subtract(const Duration(hours: 2)),
      'isFavorite': true,
    },
    {
      'id': '3',
      'title': 'Bolo de Cenoura',
      'image': 'https://via.placeholder.com/400x300?text=Bolo+de+Cenoura',
      'viewedAt': DateTime.now().subtract(const Duration(days: 1)),
      'isFavorite': true,
    },
    {
      'id': '7',
      'title': 'Sopa de Legumes',
      'image': 'https://via.placeholder.com/400x300?text=Sopa+de+Legumes',
      'viewedAt': DateTime.now().subtract(const Duration(days: 2)),
      'isFavorite': false,
    },
    {
      'id': '4',
      'title': 'Salada Caesar',
      'image': 'https://via.placeholder.com/400x300?text=Salada+Caesar',
      'viewedAt': DateTime.now().subtract(const Duration(days: 3)),
      'isFavorite': false,
    },
    {
      'id': '9',
      'title': 'Panquecas Americanas',
      'image': 'https://via.placeholder.com/400x300?text=Panquecas+Americanas',
      'viewedAt': DateTime.now().subtract(const Duration(days: 4)),
      'isFavorite': false,
    },
    {
      'id': '10',
      'title': 'Smoothie de Frutas Vermelhas',
      'image': 'https://via.placeholder.com/400x300?text=Smoothie+de+Frutas+Vermelhas',
      'viewedAt': DateTime.now().subtract(const Duration(days: 5)),
      'isFavorite': true,
    },
  ];

  List<Map<String, dynamic>> _filteredHistoryItems = [];
  
  @override
  void initState() {
    super.initState();
    _filteredHistoryItems = [..._historyItems];
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _searchHistory(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredHistoryItems = [..._historyItems];
      });
      return;
    }
    
    setState(() {
      _filteredHistoryItems = _historyItems
          .where((item) => 
              item['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
  
  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar histórico'),
        content: const Text('Tem certeza que deseja limpar todo o seu histórico de receitas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _historyItems.clear();
                _filteredHistoryItems.clear();
              });
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Histórico limpo com sucesso'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(String id) {
    setState(() {
      final index = _historyItems.indexWhere((item) => item['id'] == id);
      if (index >= 0) {
        _historyItems[index]['isFavorite'] = !_historyItems[index]['isFavorite'];
        
        // Atualizar a lista filtrada também
        final filteredIndex = _filteredHistoryItems.indexWhere((item) => item['id'] == id);
        if (filteredIndex >= 0) {
          _filteredHistoryItems[filteredIndex]['isFavorite'] = _historyItems[index]['isFavorite'];
        }
      }
    });
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'Hoje, ${DateFormat.Hm().format(dateTime)}';
    } else if (date == yesterday) {
      return 'Ontem, ${DateFormat.Hm().format(dateTime)}';
    } else {
      return DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Agrupar por data
    final Map<String, List<Map<String, dynamic>>> groupedHistory = {};
    
    for (final item in _filteredHistoryItems) {
      final viewedAt = item['viewedAt'] as DateTime;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final itemDate = DateTime(viewedAt.year, viewedAt.month, viewedAt.day);
      
      String dateKey;
      if (itemDate == today) {
        dateKey = 'Hoje';
      } else if (itemDate == yesterday) {
        dateKey = 'Ontem';
      } else {
        dateKey = DateFormat('dd/MM/yyyy').format(viewedAt);
      }
      
      if (!groupedHistory.containsKey(dateKey)) {
        groupedHistory[dateKey] = [];
      }
      
      groupedHistory[dateKey]!.add(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        centerTitle: true,
        actions: [
          if (_historyItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearHistory,
              tooltip: 'Limpar histórico',
            ),
        ],
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar no histórico...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchHistory('');
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
              onChanged: _searchHistory,
            ),
          ),

          // Histórico agrupado por data
          Expanded(
            child: _filteredHistoryItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sem histórico de receitas',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'As receitas que você visualizar aparecerão aqui',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade500,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: groupedHistory.length,
                    itemBuilder: (context, index) {
                      final dateKey = groupedHistory.keys.elementAt(index);
                      final items = groupedHistory[dateKey]!;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cabeçalho da data
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              dateKey,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          // Lista de itens para esta data
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, i) {
                              final item = items[i];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['image'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  'Visualizado às ${DateFormat.Hm().format(item['viewedAt'])}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    item['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                    color: item['isFavorite'] ? Theme.of(context).colorScheme.error : null,
                                  ),
                                  onPressed: () => _toggleFavorite(item['id']),
                                ),
                                onTap: () => context.push('/recipe/${item['id']}'),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
