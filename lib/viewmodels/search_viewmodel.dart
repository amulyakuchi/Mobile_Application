import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/spoonacular_api_service.dart';

/// ViewModel for managing recipe search operations.
///
/// Handles the loading state, search results, and error messages when fetching recipes.
class SearchViewModel extends ChangeNotifier {
  // API service instance for fetching recipe data
  final SpoonacularApiService _apiService = SpoonacularApiService();

  // Loading indicator for search operations
  bool isLoading = false;

  // Error message in case of a failed search
  String errorMessage = '';

  // List of recipes from the search results
  List<Recipe> recipes = [];

  /// Executes a search query with given filters and parameters.
  ///
  /// - Parameters:
  ///   - [ingredients]: Comma-separated list of ingredients to include.
  ///   - [dietaryPreference]: Diet filter (e.g., Vegan, Gluten-Free).
  ///   - [numberOfResults]: Maximum number of results to fetch.
  ///   - [cuisine]: Cuisine filter (e.g., Indian, Italian).
  ///   - [dishType]: Type of dish filter (e.g., Dessert, Snack).
  ///
  /// - Updates recipes with the search results or errorMessage in case of failure.
  Future<void> searchRecipes({
    required String ingredients,
    required String dietaryPreference,
    required int numberOfResults,
    required String cuisine,
    required String dishType,
  }) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      // Fetch recipes from the Spoonacular API
      recipes = await _apiService.fetchRecipesByCustomFilters(
        ingredients: ingredients,
        dietaryPreference: dietaryPreference,
        numberOfResults: numberOfResults,
        cuisine: cuisine,
        dishType: dishType,
      );
    } catch (e) {
      errorMessage = e.toString(); // Capture error message
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}