import 'package:equatable/equatable.dart';
import 'recipe_enums.dart';

// Instrução da receita
class Instruction extends Equatable {
  final int step;
  final String text;

  const Instruction({
    required this.step,
    required this.text,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      step: json['step'] ?? 0,
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'text': text,
    };
  }

  @override
  List<Object?> get props => [step, text];
}

// Request para registrar receita
class RegisterRecipeRequest extends Equatable {
  final String title;
  final CookingTime? cookingTime;
  final Difficulty? difficulty;
  final List<String> ingredients;
  final List<Instruction> instructions;
  final List<DishType> dishTypes;

  const RegisterRecipeRequest({
    required this.title,
    this.cookingTime,
    this.difficulty,
    required this.ingredients,
    required this.instructions,
    this.dishTypes = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'cookingTime': cookingTime?.value,
      'difficulty': difficulty?.value,
      'ingredients': ingredients,
      'instructions': instructions.map((i) => i.toJson()).toList(),
      'dishTypes': dishTypes.map((d) => d.value).toList(),
    };
  }

  @override
  List<Object?> get props => [
        title,
        cookingTime,
        difficulty,
        ingredients,
        instructions,
        dishTypes,
      ];
}

// Response de receita registrada
class RegisteredRecipe extends Equatable {
  final String id;
  final String title;

  const RegisteredRecipe({
    required this.id,
    required this.title,
  });

  factory RegisteredRecipe.fromJson(Map<String, dynamic> json) {
    return RegisteredRecipe(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, title];
}