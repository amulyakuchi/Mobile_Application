import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/home_screen.dart';
import 'views/ingredient_input_screen.dart';
import 'views/recipe_list_screen.dart';
import 'views/recipe_detail_screen.dart';
import 'views/favorites_screen.dart';
import 'views/settings_screen.dart';

import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/favorites_viewmodel.dart';
import 'viewmodels/recipe_detail_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';

class NomNomApp extends StatelessWidget {
  const NomNomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
        ChangeNotifierProvider(create: (_) => RecipeDetailViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsVM, child) {
          final themeData = settingsVM.isDarkTheme
              ? ThemeData.dark().copyWith(
            primaryColor: Colors.green,
            colorScheme: ThemeData.dark().colorScheme.copyWith(primary: Colors.green),
          )
              : ThemeData.light().copyWith(
            primaryColor: Colors.green,
            colorScheme: ThemeData.light().colorScheme.copyWith(primary: Colors.green),
          );

          return MaterialApp(
            title: 'NomNom',
            theme: themeData,
            initialRoute: '/home',
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
