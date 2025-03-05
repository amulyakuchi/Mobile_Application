import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nomnom/views/settings_screen.dart';
import 'package:nomnom/viewmodels/settings_viewmodel.dart';

void main() {
  group('SettingsScreen Theme Toggle Test', () {
    late SettingsViewModel settingsVM;

    setUp(() {
      settingsVM = SettingsViewModel();
    });

    testWidgets('Verify theme toggle UI interaction', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SettingsViewModel>.value(
            value: settingsVM,
            child: const SettingsScreen(),
          ),
        ),
      );

      
      expect(find.text('Dark Theme'), findsOneWidget, reason: 'Dark Theme toggle should be visible.');
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget, reason: 'Switch widget should be present.');
      expect(
        tester.widget<Switch>(switchFinder).value,
        false,
        reason: 'Switch should be OFF by default (Light theme).',
      );

      
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      
      expect(
        tester.widget<Switch>(switchFinder).value,
        true,
        reason: 'Switch should be ON after toggling (Dark theme).',
      );

    
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      
      expect(
        tester.widget<Switch>(switchFinder).value,
        false,
        reason: 'Switch should be OFF after toggling back (Light theme).',
      );
    });
  });
}

