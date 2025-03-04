import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/spoonacular_api_service.dart';

/// ViewModel for handling the details of a selected recipe.
///
/// Manages the loading state, selected recipe, and its details such as
/// ingredients and cooking instructions.
class RecipeDetailViewModel extends ChangeNotifier {
  // The currently selected recipe
  Recipe? selectedRecipe;

  // Loading indicator for fetching details
  bool isLoading = false;

  // List of ingredients for the selected recipe
  List<String> recipeIngredients = [];

  // List of instructions for the selected recipe
  List<String> recipeInstructions = [];

  // API service instance for fetching recipe details
  final SpoonacularApiService _apiService = SpoonacularApiService();

  /// Sets the recipe to be detailed
  ///
  /// - [recipe]: The recipe object to set as selected.
  void setRecipe(Recipe recipe) {
    selectedRecipe = recipe;
  }

  /// Fetches detailed information for the selected recipe.
  ///
  /// - Fetches the ingredients and instructions using the Spoonacular API.
  /// - Updates the recipeIngredients and recipeInstructions lists.
  /// - Handles errors gracefully and logs them for debugging.
  Future<void> fetchDetails() async {
    if (selectedRecipe == null) return;

    isLoading = true;
    notifyListeners();

    try {
      // Fetch recipe details from the API
      final details = await _apiService.fetchRecipeDetails(selectedRecipe!.id);

      // Update the ingredients and instructions
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
