import 'package:flutter_test/flutter_test.dart';
import 'package:nomnom/viewmodels/favorites_viewmodel.dart';
import 'package:nomnom/models/recipe.dart';

void main() {
  test('Add and remove favorites', () {
    final favoritesVM = FavoritesViewModel();
    final recipe = Recipe(
      id: 1,
      title: 'Pasta',
      summary: 'Saucy Pasta',
      imageUrl: 'https://example.com/pasta.jpg',
      readyInMinutes: 20,
      ingredients: ['Pasta', 'Sauce'],
      instructions: ['Boil water', 'Cook pasta'],
      isVegan: false,
      isGlutenFree: false,
      dietaryPreferences: [],
    );

    expect(favoritesVM.favorites.isEmpty, true);

    favoritesVM.addFavorite(recipe);
    expect(favoritesVM.favorites.contains(recipe), true);

    favoritesVM.removeFavorite(recipe);
    expect(favoritesVM.favorites.isEmpty, true);
  });
}
