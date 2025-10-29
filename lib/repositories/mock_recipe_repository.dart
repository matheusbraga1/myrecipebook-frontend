import '../models/recipe.dart';
import '../services/storage_service.dart';

class MockRecipeRepository {
  final List<Map<String, dynamic>> _mockRecipes = [];
  int _nextId = 1;

  MockRecipeRepository({
    required StorageService storageService,
  });

  Future<RegisteredRecipe> registerRecipe(RegisterRecipeRequest request) async {
    // Simula delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Validações simuladas
    if (request.title.trim().isEmpty) {
      throw Exception('O título não pode estar vazio');
    }

    if (request.ingredients.isEmpty) {
      throw Exception('A receita deve ter no mínimo um ingrediente');
    }

    if (request.instructions.isEmpty) {
      throw Exception('A receita deve ter no mínimo uma instrução');
    }

    // Verifica se tem ingredientes vazios
    if (request.ingredients.any((i) => i.trim().isEmpty)) {
      throw Exception('O ingrediente não pode estar vazio');
    }

    // Verifica se tem instruções vazias
    if (request.instructions.any((i) => i.text.trim().isEmpty)) {
      throw Exception('O texto da instrução não pode estar vazio');
    }

    // Verifica se tem instruções com step negativo ou zero
    if (request.instructions.any((i) => i.step <= 0)) {
      throw Exception('O passo não pode ser negativo ou igual a zero');
    }

    // Verifica se tem steps duplicados
    final steps = request.instructions.map((i) => i.step).toList();
    if (steps.length != steps.toSet().length) {
      throw Exception('Duas ou mais instruções tem a mesma ordem');
    }

    // Verifica tamanho das instruções
    if (request.instructions.any((i) => i.text.length > 2000)) {
      throw Exception('O texto da instrução excede o limite máximo de caracteres');
    }

    // Gera ID mock (usando padrão similar ao backend com Sqids)
    final mockId = _generateMockId(_nextId);
    _nextId++;

    // Salva receita mockada
    _mockRecipes.add({
      'id': mockId,
      'title': request.title,
      'cookingTime': request.cookingTime?.value,
      'difficulty': request.difficulty?.value,
      'ingredients': request.ingredients,
      'instructions': request.instructions.map((i) => i.toJson()).toList(),
      'dishTypes': request.dishTypes.map((d) => d.value).toList(),
      'userId': 1, // ID do usuário mockado
      'createdAt': DateTime.now().toIso8601String(),
    });

    return RegisteredRecipe(
      id: mockId,
      title: request.title,
    );
  }

  // Simula o encoder Sqids do backend
  String _generateMockId(int id) {
    const alphabet = 'N4O75AEBPt9rYZjDFHCxVGQL62UMKsiw1038';
    const minLength = 3;
    
    String encoded = '';
    int num = id;
    
    while (num > 0 || encoded.length < minLength) {
      encoded = alphabet[num % alphabet.length] + encoded;
      num = num ~/ alphabet.length;
      if (num == 0 && encoded.length < minLength) {
        num = id;
      }
    }
    
    return encoded;
  }

  // Métodos futuros para listar receitas mockadas
  Future<List<Map<String, dynamic>>> getRecipes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockRecipes);
  }

  Future<Map<String, dynamic>?> getRecipeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockRecipes.firstWhere((recipe) => recipe['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteRecipe(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockRecipes.removeWhere((recipe) => recipe['id'] == id);
  }
}