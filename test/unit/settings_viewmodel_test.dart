import 'package:flutter_test/flutter_test.dart';
import 'package:nomnom/viewmodels/settings_viewmodel.dart';

void main() {
  group('SettingsViewModel Tests', () {
    late SettingsViewModel settingsVM;
    setUp(() {
      settingsVM = SettingsViewModel();
    });
    test('Default settings should be correct', () {
      expect(settingsVM.isDarkTheme, false);
      expect(settingsVM.fontScale, 1.0);
    });

    test('Toggle dark theme', () {
      settingsVM.setDarkTheme(true);
      expect(settingsVM.isDarkTheme, true);
    });

    test('Change font scale', () {
      settingsVM.setFontScale(1.2);
      expect(settingsVM.fontScale, 1.2);
    });

    test('Reset to default settings', () {
      settingsVM.setDarkTheme(true);
      settingsVM.setFontScale(1.2);
      settingsVM.setNotifications(false);

      settingsVM.resetToDefault();
      expect(settingsVM.isDarkTheme, false);
      expect(settingsVM.fontScale, 1.0);
      expect(settingsVM.notificationsEnabled, true);
    });
  });
}
