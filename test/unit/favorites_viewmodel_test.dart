import 'package:flutter_test/flutter_test.dart';
import 'package:nomnom/models/recipe.dart';
import 'package:nomnom/viewmodels/favorites_viewmodel.dart';

void main() {
  group('FavoritesViewModel Tests', () {
    late FavoritesViewModel favoritesVM;
    late Recipe sampleRecipe;

    setUp(() {
      favoritesVM = FavoritesViewModel();
      sampleRecipe = Recipe(
        id: 1,
        title: 'Mexican Chicken & Rice Bowl',
        imageUrl: 'https://example.com/mexican-chicken.jpg',
        ingredients: ['Chicken', 'Rice'],
        instructions: ['Cook chicken', 'Add rice'],
        readyInMinutes: 35,
        isVegan: false,
        isGlutenFree: false,
        dietaryPreferences: ['High-Protein'],
      );
    });

    test('Initial favorites list should be empty', () {
      expect(favoritesVM.favorites.isEmpty, true);
    });

    test('Add a recipe to favorites', () async {
      await favoritesVM.addFavorite(sampleRecipe);
      expect(favoritesVM.favorites.contains(sampleRecipe), true);
    });

    test('Remove a recipe from favorites', () async {
      await favoritesVM.addFavorite(sampleRecipe);
      await favoritesVM.removeFavorite(sampleRecipe);
      expect(favoritesVM.favorites.contains(sampleRecipe), false);
    });

    test('Check if a recipe is marked as favorite', () async {
      await favoritesVM.addFavorite(sampleRecipe);
      expect(favoritesVM.isFavorite(sampleRecipe), true);
    });
  });
}
