import 'dart:convert'; // For decoding JSON responses
import 'package:http/http.dart' as http; // For making HTTP requests
import '../models/recipe.dart'; // Import the Recipe model

/// A service class for interacting with the Spoonacular API.
class SpoonacularApiService {
  static const String _baseUrl = 'api.spoonacular.com'; // Base URL for the API
  static const String _apiKey = '333d89ccc79f495cbecf856641bbe79a'; // API key

  /// Validates if an ingredient is valid using the Spoonacular API.
  ///
  /// [ingredient] - The ingredient name to validate.
  /// Returns true if the ingredient is valid, otherwise false.
  Future<bool> validateIngredient(String ingredient) async {
    final uri = Uri.https(
      _baseUrl,
      '/food/ingredients/autocomplete',
      {
        'apiKey': _apiKey,
        'query': ingredient,
        'number': '1', // Return only one result
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Check if the response contains a non-empty list
        return data is List && data.isNotEmpty;
      } else {
        // Log API errors for debugging
        print('Ingredient Validation API Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      // Log exceptions for debugging
      print('Error validating ingredient: $e');
      return false; // Treat any error as invalid
    }
  }

  /// Fetches a list of recipes based on the provided filters.
  ///
  /// [ingredients] - A comma-separated list of ingredients to include.
  /// [dietaryPreference] - Dietary preferences (e.g., Vegan, Gluten-Free).
  /// [numberOfResults] - The maximum number of recipes to fetch.
  /// [cuisine] - The cuisine type to filter (e.g., Italian, Mexican).
  /// [dishType] - The dish type to filter (e.g., Main Course, Dessert).
  /// Returns a list of Recipe objects matching the filters.
  Future<List<Recipe>> fetchRecipesByCustomFilters({
    required String ingredients,
    required String dietaryPreference,
    required int numberOfResults,
    required String cuisine,
    required String dishType,
  }) async {
    final queryParameters = <String, String>{
      'apiKey': _apiKey,
      'number': numberOfResults.toString(),
    };

    // Add filters dynamically based on user input
    if (ingredients.isNotEmpty) queryParameters['includeIngredients'] = ingredients;
    if (dietaryPreference.isNotEmpty && dietaryPreference != 'Any') {
      queryParameters['diet'] = dietaryPreference;
    }
    if (cuisine.isNotEmpty && cuisine != 'Any') queryParameters['cuisine'] = cuisine;
    if (dishType.isNotEmpty && dishType != 'Any') queryParameters['type'] = dishType;

    final uri = Uri.https(_baseUrl, '/recipes/complexSearch', queryParameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Parse recipe data from API response
        final results = data['results'] as List<dynamic>? ?? [];
        return results.map((json) => Recipe.fromJson(json)).toList();
      } else {
        // Log API errors for debugging
        print('Recipe Fetch API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to fetch recipes');
      }
    } catch (e) {
      // Log exceptions for debugging
      print('Error fetching recipes: $e');
      throw Exception('Error fetching recipes');
    }
  }

  /// Fetches detailed information for a specific recipe.
  ///
  /// [recipeId] - The ID of the recipe to fetch details for.
  /// Returns a map containing ingredients, instructions, and cookingTime.
  Future<Map<String, dynamic>> fetchRecipeDetails(int recipeId) async {
    final uri = Uri.https(
      _baseUrl,
      '/recipes/$recipeId/information',
      {'apiKey': _apiKey},
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract extended ingredients
        final ingredients = (data['extendedIngredients'] as List<dynamic>?)
            ?.map((item) => item['original'] as String)
            .toList() ??
            [];

        // Extract cooking instructions
        final instructions = (data['analyzedInstructions'] as List<dynamic>?)
            ?.expand((instruction) => instruction['steps'] as List<dynamic>)
            .map((step) => step['step'] as String)
            .toList() ??
            [];

        return {
          'ingredients': ingredients,
          'instructions': instructions,
          'cookingTime': data['readyInMinutes'] ?? 0,
        };
      } else {
        // Log API errors for debugging
        print('Recipe Details API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to fetch recipe details');
      }
    } catch (e) {
      // Log exceptions for debugging
      print('Error fetching recipe details: $e');
      throw Exception('Error fetching recipe details');
    }
  }
}