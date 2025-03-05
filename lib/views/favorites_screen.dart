import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/recipe_detail_viewmodel.dart';
import '../models/recipe.dart';
import '../viewmodels/settings_viewmodel.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();

    final favVM = Provider.of<FavoritesViewModel>(context, listen: false);
    favVM.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final settingsVM = Provider.of<SettingsViewModel>(context);
    final favVM = Provider.of<FavoritesViewModel>(context);
    final detailVM = Provider.of<RecipeDetailViewModel>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Favorites',
          style: TextStyle(fontSize: 20 * settingsVM.fontScale),
        ),
        centerTitle: true,
      ),
      body: favVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : favVM.errorMessage.isNotEmpty
          ? Center(
        child: Text(
          'Error: ${favVM.errorMessage}',
          style: TextStyle(fontSize: 16 * settingsVM.fontScale),
        ),
      )
          : favVM.favorites.isEmpty
          ? Center(
        child: Text(
          'No favorites added yet.',
          style: TextStyle(fontSize: 16 * settingsVM.fontScale),
        ),
      )
          : ListView.builder(
        itemCount: favVM.favorites.length,
        itemBuilder: (context, index) {
          final Recipe recipe = favVM.favorites[index];
          final personalNote= favVM.getNoteForRecipe(recipe);
          return Card(
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ListTile(
              leading: Image.network(
                recipe.imageUrl,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.image, size: 50),
              ),
              title: Text(
                recipe.title,
                style: TextStyle(
                  fontSize: 18 * settingsVM.fontScale,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: personalNote.isNotEmpty? Text('Note: $personalNote',
              style:TextStyle(fontSize:14*settingsVM.fontScale,
              fontStyle:FontStyle.italic,),):null,

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children:[
                  IconButton(icon:const Icon(Icons.edit_note),
                  tooltip:'Add/Edit Note',
                  onPressed:()=>_showAddNotDialog(context,recipe),),
                
              
              
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await favVM.removeFavorite(recipe);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Removed from favorites')),
                  );
                },
              ),
              ],
            ),
              onTap: () {
                detailVM.setRecipe(recipe);
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
  void _showAddNoteDialog(BuildContext context, Recipe recipe) {
    final favVM = Provider.of<FavoritesViewModel>(context, listen: false);

    // Pre-fill with existing note if any
    final existingNote = favVM.getNoteForRecipe(recipe);
    final noteController = TextEditingController(text: existingNote);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add a Personal Note'),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(hintText: 'Enter your note here'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('SAVE'),
              onPressed: () {
                final newNote = noteController.text.trim();
                favVM.setNoteForRecipe(recipe, newNote);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

}
