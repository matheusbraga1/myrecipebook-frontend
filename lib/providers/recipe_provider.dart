import 'package:flutter/foundation.dart';
import '../models/recipe.dart';

class RecipeProvider with ChangeNotifier {
  final dynamic _recipeRepository;
  
  bool _isLoading = false;
  String? _errorMessage;
  List<RegisteredRecipe> _recipes = [];
  RegisteredRecipe? _lastRegisteredRecipe;

  RecipeProvider({required dynamic recipeRepository})
      : _recipeRepository = recipeRepository;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<RegisteredRecipe> get recipes => _recipes;
  RegisteredRecipe? get lastRegisteredRecipe => _lastRegisteredRecipe;

  Future<bool> registerRecipe(RegisterRecipeRequest request) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _lastRegisteredRecipe = await _recipeRepository.registerRecipe(request);
      
      // Adiciona a receita na lista local
      _recipes.add(_lastRegisteredRecipe!);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Métodos futuros para outras operações
  Future<void> loadRecipes() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Implementar quando tiver endpoint de listagem
      // _recipes = await _recipeRepository.getRecipes();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteRecipe(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      _recipes.removeWhere((recipe) => recipe.id == id);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearLastRegisteredRecipe() {
    _lastRegisteredRecipe = null;
    notifyListeners();
  }
}