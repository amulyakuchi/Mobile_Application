import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importing screens
import 'views/home_screen.dart';
import 'views/ingredient_input_screen.dart';
import 'views/recipe_list_screen.dart';
import 'views/recipe_detail_screen.dart';
import 'views/favorites_screen.dart';
import 'views/settings_screen.dart';

// Importing ViewModels for state management
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/favorites_viewmodel.dart';
import 'viewmodels/recipe_detail_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';

/// The main application class that sets up the app structure and routes.
class NomNomApp extends StatelessWidget {
  const NomNomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // State management for recipe search
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        // State management for favorites
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
        // State management for recipe details
        ChangeNotifierProvider(create: (_) => RecipeDetailViewModel()),
        // State management for app settings
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsVM, child) {
          // Configure theme based on user preferences
          final themeData = settingsVM.isDarkTheme
              ? ThemeData.dark().copyWith(
            primaryColor: Colors.green,
            colorScheme: ThemeData.dark().colorScheme.copyWith(primary: Colors.green),
          )
              : ThemeData.light().copyWith(
            primaryColor: Colors.green,
            colorScheme: ThemeData.light().colorScheme.copyWith(primary: Colors.green),
          );

          // Define the main structure of the app
          return MaterialApp(
            title: 'NomNom', // App name
            theme: themeData, // Dynamic theme
            initialRoute: '/home', // Initial screen
            routes: {
              '/home': (context) => const HomeScreen(),
              '/ingredient_input': (context) => const IngredientInputScreen(),
              '/recipe_list': (context) => const RecipeListScreen(),
              '/recipe_detail': (context) => const RecipeDetailScreen(),
              '/favorites': (context) => const FavoritesScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
