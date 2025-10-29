import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recipe.dart';
import '../../models/recipe_enums.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class RegisterRecipeScreen extends StatefulWidget {
  const RegisterRecipeScreen({super.key});

  @override
  State<RegisterRecipeScreen> createState() => _RegisterRecipeScreenState();
}

class _RegisterRecipeScreenState extends State<RegisterRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  
  CookingTime? _selectedCookingTime;
  Difficulty? _selectedDifficulty;
  final Set<DishType> _selectedDishTypes = {};
  
  final List<TextEditingController> _ingredientControllers = [TextEditingController()];
  final List<TextEditingController> _instructionControllers = [TextEditingController()];

  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var controller in _instructionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredient(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() {
        _ingredientControllers[index].dispose();
        _ingredientControllers.removeAt(index);
      });
    }
  }

  void _addInstruction() {
    setState(() {
      _instructionControllers.add(TextEditingController());
    });
  }

  void _removeInstruction(int index) {
    if (_instructionControllers.length > 1) {
      setState(() {
        _instructionControllers[index].dispose();
        _instructionControllers.removeAt(index);
      });
    }
  }

  Future<void> _handleSaveRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ingredients = _ingredientControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos um ingrediente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final instructions = <Instruction>[];
    for (int i = 0; i < _instructionControllers.length; i++) {
      final text = _instructionControllers[i].text.trim();
      if (text.isNotEmpty) {
        instructions.add(Instruction(
          step: i + 1,
          text: text,
        ));
      }
    }

    if (instructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos uma instrução'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = RegisterRecipeRequest(
      title: _titleController.text.trim(),
      cookingTime: _selectedCookingTime,
      difficulty: _selectedDifficulty,
      ingredients: ingredients,
      instructions: instructions,
      dishTypes: _selectedDishTypes.toList(),
    );

    final recipeProvider = context.read<RecipeProvider>();
    final success = await recipeProvider.registerRecipe(request);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receita salva com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(recipeProvider.errorMessage ?? 'Erro ao salvar receita'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Receita'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título
                CustomTextField(
                  controller: _titleController,
                  label: 'Título da Receita',
                  hint: 'Ex: Bolo de Chocolate',
                  prefixIcon: Icons.restaurant_menu,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O título não pode estar vazio';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Tempo de Preparo
                Text(
                  'Tempo de Preparo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildCookingTimeTags(),
                
                const SizedBox(height: 24),
                
                // Dificuldade
                Text(
                  'Dificuldade',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDifficultyTags(),
                
                const SizedBox(height: 24),
                
                // Tipo de Prato
                Text(
                  'Tipo de Prato',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecione um ou mais tipos',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                _buildDishTypeTags(),
                
                const SizedBox(height: 24),
                
                // Ingredientes
                _buildIngredientsSection(),
                
                const SizedBox(height: 24),
                
                // Modo de Preparo
                _buildInstructionsSection(),
                
                const SizedBox(height: 32),
                
                // Botão de Salvar
                Consumer<RecipeProvider>(
                  builder: (context, recipeProvider, _) {
                    return CustomButton(
                      text: 'Salvar Receita',
                      icon: Icons.save,
                      onPressed: _handleSaveRecipe,
                      isLoading: recipeProvider.isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCookingTimeTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: CookingTime.values.map((time) {
        final isSelected = _selectedCookingTime == time;
        return _SelectableTag(
          label: time.label,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedCookingTime = isSelected ? null : time;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDifficultyTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Difficulty.values.map((difficulty) {
        final isSelected = _selectedDifficulty == difficulty;
        return _SelectableTag(
          label: difficulty.label,
          isSelected: isSelected,
          icon: _getDifficultyIcon(difficulty),
          onTap: () {
            setState(() {
              _selectedDifficulty = isSelected ? null : difficulty;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDishTypeTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: DishType.values.map((type) {
        final isSelected = _selectedDishTypes.contains(type);
        return _SelectableTag(
          label: type.label,
          isSelected: isSelected,
          icon: _getDishTypeIcon(type),
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedDishTypes.remove(type);
              } else {
                _selectedDishTypes.add(type);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ingredientes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addIngredient,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Adicionar'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _ingredientControllers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _ingredientControllers[index],
                    label: 'Ingrediente ${index + 1}',
                    hint: 'Ex: 2 xícaras de farinha',
                    prefixIcon: Icons.shopping_basket,
                  ),
                ),
                if (_ingredientControllers.length > 1) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _removeIngredient(index),
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.red,
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Modo de Preparo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addInstruction,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Adicionar'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _instructionControllers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: _instructionControllers[index],
                    label: 'Passo ${index + 1}',
                    hint: 'Descreva o passo',
                    maxLines: 3,
                    prefixIcon: Icons.format_list_numbered,
                  ),
                ),
                if (_instructionControllers.length > 1) ...[
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: IconButton(
                      onPressed: () => _removeInstruction(index),
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.red,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  IconData _getDifficultyIcon(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.low:
        return Icons.sentiment_satisfied;
      case Difficulty.medium:
        return Icons.sentiment_neutral;
      case Difficulty.high:
        return Icons.sentiment_dissatisfied;
    }
  }

  IconData _getDishTypeIcon(DishType type) {
    switch (type) {
      case DishType.breakfast:
        return Icons.free_breakfast;
      case DishType.lunch:
        return Icons.lunch_dining;
      case DishType.appetizers:
        return Icons.tapas;
      case DishType.snack:
        return Icons.fastfood;
      case DishType.dessert:
        return Icons.cake;
      case DishType.dinner:
        return Icons.dinner_dining;
      case DishType.drinks:
        return Icons.local_drink;
    }
  }
}

class _SelectableTag extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _SelectableTag({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}