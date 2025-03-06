import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/spoonacular_api_service.dart';

class SearchViewModel extends ChangeNotifier {
  final SpoonacularApiService _apiService = SpoonacularApiService();
  bool isLoading = false;
  String errorMessage = '';
  List<Recipe> recipes = [];

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

      recipes = await _apiService.fetchRecipesByCustomFilters(
        ingredients: ingredients,
        dietaryPreference: dietaryPreference,
        numberOfResults: numberOfResults,
        cuisine: cuisine,
        dishType: dishType,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
