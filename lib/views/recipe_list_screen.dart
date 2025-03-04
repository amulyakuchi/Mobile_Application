import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';

/// A screen that displays the list of recipes fetched from the search query.
class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchVM = Provider.of<SearchViewModel>(context);
    final favoritesVM = Provider.of<FavoritesViewModel>(context);
    final settingsVM = Provider.of<SettingsViewModel>(context);

    final fontScale = settingsVM.fontScale;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Recipe Results',
          style: TextStyle(fontSize: 20 * fontScale),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Edit Filters',
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: searchVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (searchVM.errorMessage.isNotEmpty)
          ? Center(
        child: Text(
          'Error: ${searchVM.errorMessage}',
          style: TextStyle(fontSize: 16 * fontScale, color: Colors.red),
        ),
      )
          : searchVM.recipes.isEmpty
          ? Center(
        child: Text(
          'No recipes found.',
          style: TextStyle(fontSize: 16 * fontScale),
        ),
      )
          : ListView.builder(
        itemCount: searchVM.recipes.length,
        itemBuilder: (context, index) {
          final recipe = searchVM.recipes[index];
          final isFavorite = favoritesVM.isFavorite(recipe);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  recipe.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image, size: 50),
                ),
              ),
              title: Text(
                recipe.title,
                style: TextStyle(
                  fontSize: 16 * fontScale,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
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
                },
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/recipe_detail',
                  arguments: recipe,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
