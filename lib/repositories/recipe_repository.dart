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
}