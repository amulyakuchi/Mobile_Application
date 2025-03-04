import 'dart:convert'; // For decoding JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For loading assets
import 'package:provider/provider.dart';
import '../viewmodels/recipe_detail_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../models/recipe.dart';

/// Displays detailed information about a selected recipe.
class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({Key? key}) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Map<String, dynamic>? localRecipeDetails; // To store matched recipe details

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final recipe = ModalRoute.of(context)?.settings.arguments as Recipe?;
    final detailVM = Provider.of<RecipeDetailViewModel>(context, listen: false);

    if (recipe != null) {
      detailVM.setRecipe(recipe);
      _loadLocalRecipes(recipe); // Load local recipe details if matched
    }
  }

  /// Loads the recipes.json file and checks for a matching recipe.
  Future<void> _loadLocalRecipes(Recipe selectedRecipe) async {
    try {
      final jsonString =
      await rootBundle.loadString('assets/recipes.json'); // Load JSON file
      final List<dynamic> recipes = json.decode(jsonString);

      // Find a matching recipe by title
      final matchedRecipe = recipes.firstWhere(
            (recipe) => recipe['title'] == selectedRecipe.title,
        orElse: () => null,
      );

      if (matchedRecipe != null) {
        setState(() {
          localRecipeDetails = matchedRecipe; // Store matched recipe details
        });
      }
    } catch (e) {
      debugPrint('Error loading local recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailVM = Provider.of<RecipeDetailViewModel>(context);
    final favoritesVM = Provider.of<FavoritesViewModel>(context, listen: false);
    final settingsVM = Provider.of<SettingsViewModel>(context);
    final fontScale = settingsVM.fontScale;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (detailVM.selectedRecipe == null) {
      return const Scaffold(
        body: Center(child: Text('No recipe selected')),
      );
    }

    final recipe = detailVM.selectedRecipe!;
    final isFavorite = favoritesVM.isFavorite(recipe);

    // Use local details if available, otherwise use API details
    final ingredients = localRecipeDetails?['ingredients'] ?? recipe.ingredients;
    final instructions =
        localRecipeDetails?['instructions'] ?? recipe.instructions;
    final readyInMinutes =
        localRecipeDetails?['readyInMinutes'] ?? recipe.readyInMinutes;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.title,
          style: TextStyle(fontSize: 18 * fontScale),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : (isDarkMode ? Colors.white : Colors.black),
            ),
            onPressed: () {
              setState(() {
                if (isFavorite) {
                  favoritesVM.removeFavorite(recipe);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Removed from Favorites.')),
                  );
                } else {
                  favoritesVM.addFavorite(recipe);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to Favorites.')),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: detailVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ready in $readyInMinutes minutes',
              style: TextStyle(
                fontSize: 18 * fontScale,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.tealAccent : Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 18 * fontScale,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...ingredients.map(
                  (ingredient) => Text(
                '- $ingredient',
                style: TextStyle(fontSize: 16 * fontScale),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Instructions',
              style: TextStyle(
                fontSize: 18 * fontScale,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...instructions.map(
                  (instruction) => Text(
                '- $instruction',
                style: TextStyle(fontSize: 16 * fontScale),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
