import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      _nameController.text = userProvider.user?.name ?? '';
      _emailController.text = userProvider.user?.email ?? '';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = context.read<UserProvider>();
      
      final success = await userProvider.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );

      if (mounted) {
        if (success) {
          setState(() {
            _isEditing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userProvider.errorMessage ?? 'Erro ao atualizar perfil'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        final userProvider = context.read<UserProvider>();
        _nameController.text = userProvider.user?.name ?? '';
        _emailController.text = userProvider.user?.email ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEdit,
            ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.isLoading && userProvider.user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  CustomTextField(
                    controller: _nameController,
                    label: 'Nome',
                    prefixIcon: Icons.person_outlined,
                    enabled: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O nome não pode estar vazio';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  CustomTextField(
                    controller: _emailController,
                    label: 'E-mail',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    enabled: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O e-mail não pode estar vazio';
                      }
                      if (!value.contains('@')) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  if (_isEditing) ...[
                    CustomButton(
                      text: 'Salvar Alterações',
                      onPressed: _handleUpdate,
                      isLoading: userProvider.isLoading,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: userProvider.isLoading ? null : _toggleEdit,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ],

                  if (!_isEditing) ...[
                    CustomButton(
                      text: 'Alterar Senha',
                      icon: Icons.lock_outline,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/change-password');
                      },
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informações da Conta',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            context,
                            icon: Icons.restaurant_menu,
                            label: 'Receitas',
                            value: '0',
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            icon: Icons.access_time,
                            label: 'Membro desde',
                            value: 'Recente',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}