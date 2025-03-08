import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/spoonacular_api_service.dart';

class RecipeDetailViewModel extends ChangeNotifier {
  Recipe? selectedRecipe;
  bool isLoading = false;
  List<String> recipeIngredients = [];
  List<String> recipeInstructions = [];
  final SpoonacularApiService _apiService = SpoonacularApiService();

  void setRecipe(Recipe recipe) {
    selectedRecipe = recipe;
  }

  Future<void> fetchDetails() async {
    if (selectedRecipe == null) return;

    isLoading = true;
    notifyListeners();

    try {
      final details = await _apiService.fetchRecipeDetails(selectedRecipe!.id);

      recipeIngredients = details['ingredients'] as List<String>;
      recipeInstructions = details['instructions'] as List<String>;
    } catch (e) {
      debugPrint('Error fetching recipe details: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
