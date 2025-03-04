import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nomnom/views/settings_screen.dart';
import 'package:nomnom/viewmodels/settings_viewmodel.dart';

void main() {
  group('SettingsScreen Theme Toggle Test', () {
    late SettingsViewModel settingsVM;

    setUp(() {
      settingsVM = SettingsViewModel(); // Initialize SettingsViewModel before each test
    });

    testWidgets('Verify theme toggle UI interaction', (WidgetTester tester) async {
      // Wrap SettingsScreen with a Provider for SettingsViewModel
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SettingsViewModel>.value(
            value: settingsVM,
            child: const SettingsScreen(),
          ),
        ),
      );

      // Verify initial state (Switch is OFF for light theme)
      expect(find.text('Dark Theme'), findsOneWidget, reason: 'Dark Theme toggle should be visible.');
      final switchFinder = find.byType(Switch); // Locate the Switch widget
      expect(switchFinder, findsOneWidget, reason: 'Switch widget should be present.');
      expect(
        tester.widget<Switch>(switchFinder).value,
        false,
        reason: 'Switch should be OFF by default (Light theme).',
      );

      // Toggle the switch to enable dark theme
      await tester.tap(switchFinder); // Simulate user tapping the switch
      await tester.pumpAndSettle(); // Wait for UI update

      // Verify the switch is now ON (Dark theme)
      expect(
        tester.widget<Switch>(switchFinder).value,
        true,
        reason: 'Switch should be ON after toggling (Dark theme).',
      );

      // Toggle the switch back to disable dark theme
      await tester.tap(switchFinder); // Simulate user toggling back
      await tester.pumpAndSettle(); // Wait for UI update

      // Verify the switch is back OFF (Light theme)
      expect(
        tester.widget<Switch>(switchFinder).value,
        false,
        reason: 'Switch should be OFF after toggling back (Light theme).',
      );
    });
  });
}
