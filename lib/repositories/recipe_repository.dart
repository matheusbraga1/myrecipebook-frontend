import '../models/recipe.dart';
import '../services/api_client.dart';
import '../services/storage_service.dart';

class RecipeRepository {
  final ApiClient _apiClient;

  RecipeRepository({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient;

  Future<RegisteredRecipe> registerRecipe(RegisterRecipeRequest request) async {
    final response = await _apiClient.post('/recipe', request.toJson());
    return RegisteredRecipe.fromJson(response);
  }

  // Métodos futuros para listar, buscar, atualizar e deletar receitas
  // Future<List<Recipe>> getRecipes() async { ... }
  // Future<Recipe> getRecipeById(String id) async { ... }
  // Future<void> updateRecipe(String id, RegisterRecipeRequest request) async { ... }
  // Future<void> deleteRecipe(String id) async { ... }
}