import 'dart:convert'; // For JSON parsing
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; // For loading JSON assets
import '../models/recipe.dart';

/// ViewModel for managing favorite recipes in the application
/// This class handles favorite recipes locally within the app.
class FavoritesViewModel extends ChangeNotifier {
  // List to store the user's favorite recipes
  List<Recipe> favorites = [];

  // State variable to indicate if data is being loaded
  bool isLoading = false;

  // Variable to store error messages if any operation fails
  String errorMessage = '';

  /// Fetches the list of favorite recipes
  /// Since Firebase has been removed, this method only updates the local list.
  Future<void> fetchFavorites() async {
    try {
      isLoading = true; // Indicate loading state
      errorMessage = ''; // Clear any previous errors
      notifyListeners();

      // Simulate data fetching or use persistent storage (if needed in the future)
      await Future.delayed(const Duration(milliseconds: 500)); // Simulating delay
    } catch (e) {
      errorMessage = 'Failed to load favorites: $e'; // Capture error message
    } finally {
      isLoading = false; // Reset loading state
      notifyListeners();
    }
  }

  /// Adds a recipe to the favorites list
  Future<void> addFavorite(Recipe recipe) async {
    if (!favorites.contains(recipe)) {
      favorites.add(recipe); // Add to local list
      notifyListeners(); // Notify listeners to update UI
    }
  }

  /// Removes a recipe from the favorites list
  Future<void> removeFavorite(Recipe recipe) async {
    favorites.removeWhere((r) => r.id == recipe.id); // Remove from the local list
    notifyListeners(); // Notify listeners to update UI
  }

  /// Checks if a given recipe is already marked as a favorite
  bool isFavorite(Recipe recipe) {
    return favorites.any((fav) => fav.id == recipe.id);
  }

  /// Loads the recipes.json file and checks for a matching recipe.
  Future<Map<String, dynamic>?> loadLocalRecipe(Recipe selectedRecipe) async {
    try {
      final jsonString =
      await rootBundle.loadString('assets/recipes.json'); // Load JSON file
      final List<dynamic> recipes = json.decode(jsonString);

      // Find a matching recipe by title
      final matchedRecipe = recipes.firstWhere(
            (recipe) => recipe['title'] == selectedRecipe.title,
        orElse: () => null,
      );

      return matchedRecipe; // Return matched recipe details if found
    } catch (e) {
      debugPrint('Error loading local recipes: $e');
      return null;
    }
  }
}
