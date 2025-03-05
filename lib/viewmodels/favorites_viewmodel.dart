
import 'package:flutter/foundation.dart';

import '../models/recipe.dart';


class FavoritesViewModel extends ChangeNotifier {
  List<Recipe> favorites = [];
  bool isLoading = false;
  String errorMessage = '';
  Map<int, String> recipeNotes = {};

  Future<void> fetchFavorites() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      errorMessage = 'Failed to load favorites: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> addFavorite(Recipe recipe) async {
    if (!favorites.contains(recipe)) {
      favorites.add(recipe);
      notifyListeners();
    }
  }


  Future<void> removeFavorite(Recipe recipe) async {
    favorites.removeWhere((r) => r.id == recipe.id);
    notifyListeners();
  }


  bool isFavorite(Recipe recipe) {
    return favorites.any((fav) => fav.id == recipe.id);
  }
  void setNoteForRecipe(Recipe recipe, String note) {
    if (note.trim().isEmpty) {
      recipeNotes.remove(recipe.id);
    } else {
      recipeNotes[recipe.id] = note;
    }
    notifyListeners();
  }
  String getNoteForRecipe(Recipe recipe) {
    return recipeNotes[recipe.id] ?? '';
  }
}