import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class SpoonacularApiService {
  static const String _baseUrl = 'api.spoonacular.com';
  static const String _apiKey = '333d89ccc79f495cbecf856641bbe79a';

  Future<bool> validateIngredient(String ingredient) async {
    final uri = Uri.https(
      _baseUrl,
      '/food/ingredients/search',
      {'query': ingredient, 'apiKey': _apiKey, 'number': '1'},
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] != null && data['results'].isNotEmpty;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  Future<List<Recipe>> fetchRecipesByCustomFilters({
    required String ingredients,
    required String dietaryPreference,
    required int numberOfResults,
    required String cuisine,
    required String dishType,
  }) async {
    final queryParameters = {
      'apiKey': _apiKey,
      'number': numberOfResults.toString(),
      'addRecipeInformation': 'true',
    };

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
        final results = data['results'] as List<dynamic>? ?? [];
        return results.map((json) => Recipe.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
  Future<Recipe> fetchRecipeDetails(int recipeId) async {
    final uri = Uri.https(_baseUrl, '/recipes/$recipeId/information', {'apiKey': _apiKey});

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Recipe.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch recipe details');
      }
    } catch (e) {
      throw Exception('Error fetching recipe details');
    }
  }
}