import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../view_models/auth/auth_bloc.dart';

/// [ProfileScreen] exibe e permite a edição das informações do perfil do usuário.
/// Também fornece opções de configuração do aplicativo.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Português';
  
  final List<String> _dietaryRestrictions = [];
  final List<String> _availableDietaryRestrictions = [
    'Vegetariano', 'Vegano', 'Sem Glúten', 'Sem Lactose', 
    'Sem Amendoim', 'Low Carb', 'Keto', 'Paleo'
  ];

  void _toggleDietaryRestriction(String restriction) {
    setState(() {
      if (_dietaryRestrictions.contains(restriction)) {
        _dietaryRestrictions.remove(restriction);
      } else {
        _dietaryRestrictions.add(restriction);
      }
    });
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Fechar o diálogo primeiro
              Navigator.of(context).pop();
              
              // Enviar evento de logout
              context.read<AuthBloc>().add(SignOutEvent());
              
              // Redirecionar para login
              context.go('/login');
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informações do perfil
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Text(
                        'JS',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'João Silva',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'joao.silva@exemplo.com',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Navegar para a edição de perfil
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar Perfil'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Estatísticas
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estatísticas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatisticItem(
                            context,
                            'Receitas\nFavoritas',
                            '12',
                            Icons.favorite,
                          ),
                          _buildStatisticItem(
                            context,
                            'Receitas\nCriadas',
                            '3',
                            Icons.restaurant_menu,
                          ),
                          _buildStatisticItem(
                            context,
                            'Ingredientes\nSalvos',
                            '28',
                            Icons.kitchen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Preferências dietéticas
              const Text(
                'Preferências Dietéticas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableDietaryRestrictions.map((restriction) {
                  final isSelected = _dietaryRestrictions.contains(restriction);
                  return FilterChip(
                    label: Text(restriction),
                    selected: isSelected,
                    onSelected: (_) => _toggleDietaryRestriction(restriction),
                    selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.grey.shade100,
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Configurações
              const Text(
                'Configurações',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Notificações'),
                      subtitle: const Text('Receber alertas e novidades'),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Modo Escuro'),
                      subtitle: const Text('Alternar tema claro/escuro'),
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          _darkModeEnabled = value;
                        });
                        // TODO: Implementar alteração do tema
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Idioma'),
                      subtitle: Text(_selectedLanguage),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Implementar seleção de idioma
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: const Text('Selecione o idioma'),
                              children: [
                                SimpleDialogOption(
                                  onPressed: () {
                                    setState(() {
                                      _selectedLanguage = 'Português';
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Português'),
                                ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    setState(() {
                                      _selectedLanguage = 'English';
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('English'),
                                ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    setState(() {
                                      _selectedLanguage = 'Español';
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Español'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Unidades de Medida'),
                      subtitle: const Text('Métrico (g, ml)'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Implementar seleção de unidades
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sobre e Ajuda
              const Text(
                'Sobre e Ajuda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Ajuda e Suporte'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Navegar para tela de ajuda
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('Política de Privacidade'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Navegar para política de privacidade
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Termos de Uso'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Navegar para termos de uso
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Sobre o App'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Navegar para sobre o app
                        showAboutDialog(
                          context: context,
                          applicationName: 'À LaCarte',
                          applicationVersion: '1.0.0',
                          applicationIcon: Image.asset(
                            'assets/images/logo.png',
                            width: 40,
                            height: 40,
                          ),
                          applicationLegalese: '© 2025 À LaCarte. Todos os direitos reservados.',
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              'À LaCarte é um aplicativo que permite encontrar receitas personalizadas com base nos ingredientes disponíveis.',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Botão para sair
              SizedBox(
                width: double.infinity,
                child: SecondaryButton(
                  onPressed: _signOut,
                  text: 'Sair da Conta',
                  icon: Icons.logout,
                  outlined: true,
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatisticItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
