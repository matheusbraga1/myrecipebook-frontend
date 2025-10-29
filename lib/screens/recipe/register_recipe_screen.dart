import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/strings.dart';
import '../../models/recipe.dart';
import '../../models/recipe_enums.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/selectable_tag.dart';

class RegisterRecipeScreen extends StatefulWidget {
  const RegisterRecipeScreen({super.key});

  @override
  State<RegisterRecipeScreen> createState() => _RegisterRecipeScreenState();
}

class _RegisterRecipeScreenState extends State<RegisterRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _titleController = TextEditingController();

  CookingTime? _selectedCookingTime;
  Difficulty? _selectedDifficulty;
  final Set<DishType> _selectedDishTypes = {};

  final List<TextEditingController> _ingredientControllers = [TextEditingController()];
  final List<TextEditingController> _instructionControllers = [TextEditingController()];

  @override
  void dispose() {
    _scrollController.dispose();
    _titleController.dispose();
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var controller in _instructionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _hasUnsavedData() {
    return _titleController.text.isNotEmpty ||
        _selectedCookingTime != null ||
        _selectedDifficulty != null ||
        _selectedDishTypes.isNotEmpty ||
        _ingredientControllers.any((c) => c.text.isNotEmpty) ||
        _instructionControllers.any((c) => c.text.isNotEmpty);
  }

  Future<bool> _showExitConfirmation() async {
    if (!_hasUnsavedData()) {
      return true;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(Strings.discardChangesTitle),
        content: const Text(Strings.discardChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(Strings.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(Strings.exitButton),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  void _addIngredient() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });

    // Scroll para o final após adicionar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _removeIngredient(int index) async {
    if (_ingredientControllers.length <= 1) return;

    if (_ingredientControllers[index].text.isNotEmpty) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(Strings.removeIngredientTitle),
          content: const Text(Strings.removeIngredientMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(Strings.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(Strings.removeButton),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    setState(() {
      _ingredientControllers[index].dispose();
      _ingredientControllers.removeAt(index);
    });
  }

  void _addInstruction() {
    setState(() {
      _instructionControllers.add(TextEditingController());
    });

    // Scroll para o final após adicionar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _removeInstruction(int index) async {
    if (_instructionControllers.length <= 1) return;

    if (_instructionControllers[index].text.isNotEmpty) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(Strings.removeStepTitle),
          content: const Text(Strings.removeStepMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(Strings.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(Strings.removeButton),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    setState(() {
      _instructionControllers[index].dispose();
      _instructionControllers.removeAt(index);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _handleSaveRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validação de tempo de preparo
    if (_selectedCookingTime == null) {
      _showError(Strings.cookingTimeRequiredError);
      return;
    }

    // Validação de dificuldade
    if (_selectedDifficulty == null) {
      _showError(Strings.difficultyRequiredError);
      return;
    }

    // Validação de tipo de prato
    if (_selectedDishTypes.isEmpty) {
      _showError(Strings.dishTypeRequiredError);
      return;
    }

    final ingredients = _ingredientControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      _showError(Strings.ingredientRequiredError);
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
      _showError(Strings.instructionRequiredError);
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
            content: Text(Strings.recipeSavedSuccess),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();
      } else {
        _showError(recipeProvider.errorMessage ?? Strings.recipeSaveError);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await _showExitConfirmation();
        if (shouldExit && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.newRecipeTitle),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  CustomTextField(
                    controller: _titleController,
                    label: '${Strings.recipeTitleLabel} *',
                    hint: Strings.recipeTitleHint,
                    prefixIcon: Icons.restaurant_menu,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.titleEmptyError;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Tempo de Preparo
                  Text(
                    '${Strings.cookingTimeLabel} *',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCookingTimeTags(),

                  const SizedBox(height: 24),

                  // Dificuldade
                  Text(
                    '${Strings.difficultyLabel} *',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDifficultyTags(),

                  const SizedBox(height: 24),

                  // Tipo de Prato
                  Text(
                    '${Strings.dishTypeLabel} *',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Strings.dishTypeSubtitle,
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
                        text: Strings.saveRecipeButton,
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
      ),
    );
  }

  Widget _buildCookingTimeTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: CookingTime.values.map((time) {
        final isSelected = _selectedCookingTime == time;
        return SelectableTag(
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
        return SelectableTag(
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
        return SelectableTag(
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
              '${Strings.ingredientsLabel} *',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addIngredient,
              icon: const Icon(Icons.add, size: 20),
              label: const Text(Strings.addButton),
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
                    label: '${Strings.ingredientLabel} ${index + 1}',
                    hint: Strings.ingredientHint,
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
              '${Strings.instructionsLabel} *',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addInstruction,
              icon: const Icon(Icons.add, size: 20),
              label: const Text(Strings.addButton),
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
                    label: '${Strings.stepLabel} ${index + 1}',
                    hint: Strings.stepHint,
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