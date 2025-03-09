import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/spoonacular_api_service.dart';

class RecipeDetailViewModel extends ChangeNotifier {
  Recipe? selectedRecipe;
  bool isLoading = false;
  String errorMessage = '';
  final SpoonacularApiService _apiService = SpoonacularApiService();

  Future<void> setRecipe(Recipe recipe) async {
    selectedRecipe = recipe;
    errorMessage = '';
    notifyListeners();
    await fetchDetails();
  }

  Future<void> fetchDetails() async {
    if (selectedRecipe == null) return;

    isLoading = true;
    notifyListeners();

    try {
      final fetchedRecipe = await _apiService.fetchRecipeDetails(selectedRecipe!.id);
      selectedRecipe = fetchedRecipe;
    } catch (e) {
      errorMessage = 'Failed to load recipe details';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
