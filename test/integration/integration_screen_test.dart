import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomnom/app.dart'; // Replace with your app's main file

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Basic Navigation Test', (WidgetTester tester) async {
    // Launch the app
    await tester.pumpWidget(const NomNomApp());

    // Verify HomeScreen is displayed
    expect(find.text('Welcome to NomNom'), findsOneWidget);

    // Navigate to Ingredient Input Screen
    final findRecipesButton = find.text('Find Recipes');
    expect(findRecipesButton, findsOneWidget);
    await tester.tap(findRecipesButton);
    await tester.pumpAndSettle();

    // Verify navigation to Ingredient Input Screen
    expect(find.text('Add Ingredients'), findsOneWidget);

    // Navigate to Settings Screen
    final settingsIcon = find.byIcon(Icons.settings);
    expect(settingsIcon, findsOneWidget);
    await tester.tap(settingsIcon);
    await tester.pumpAndSettle();

    // Verify navigation to Settings Screen
    expect(find.text('Settings'), findsOneWidget);

    // Navigate back to Ingredient Input Screen
    final backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
    await tester.pumpAndSettle();
    expect(find.text('Add Ingredients'), findsOneWidget);

    // Navigate back to HomeScreen
    await tester.tap(backButton);
    await tester.pumpAndSettle();
    expect(find.text('Welcome to NomNom'), findsOneWidget);
  });
}
