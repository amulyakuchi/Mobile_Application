import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomnom/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Basic Navigation Test', (WidgetTester tester) async {
    await tester.pumpWidget(const NomNomApp());

    
    expect(find.text('Welcome to NomNom'), findsOneWidget);

    
    final findRecipesButton = find.text('Find Recipes');
    expect(findRecipesButton, findsOneWidget);
    await tester.tap(findRecipesButton);
    await tester.pumpAndSettle();

    expect(find.text('Add Ingredients'), findsOneWidget);

    final settingsIcon = find.byIcon(Icons.settings);
    expect(settingsIcon, findsOneWidget);
    await tester.tap(settingsIcon);
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);

    final backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
    await tester.pumpAndSettle();
    expect(find.text('Add Ingredients'), findsOneWidget);

    await tester.tap(backButton);
    await tester.pumpAndSettle();
    expect(find.text('Welcome to NomNom'), findsOneWidget);
  });
}
