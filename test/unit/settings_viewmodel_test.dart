import 'package:flutter_test/flutter_test.dart';
import 'package:nomnom/viewmodels/settings_viewmodel.dart';

/// Unit tests for the SettingsViewModel.
void main() {
  group('SettingsViewModel Tests', () {
    late SettingsViewModel settingsVM;

    // Initialize a fresh instance of SettingsViewModel before each test
    setUp(() {
      settingsVM = SettingsViewModel();
    });

    // Test the default values of the settings
    test('Default settings should be correct', () {
      expect(settingsVM.isDarkTheme, false); // Default theme should not be dark
      expect(settingsVM.fontScale, 1.0); // Default font scale should be 1.0
    });

    // Test toggling the dark theme setting
    test('Toggle dark theme', () {
      settingsVM.setDarkTheme(true);
      expect(settingsVM.isDarkTheme, true); // Theme should now be dark
    });

    // Test updating the font scale
    test('Change font scale', () {
      settingsVM.setFontScale(1.2);
      expect(settingsVM.fontScale, 1.2); // Font scale should update to the new value
    });

    // Test resetting all settings to their default values
    test('Reset to default settings', () {
      // Modify settings to non-default values
      settingsVM.setDarkTheme(true);
      settingsVM.setFontScale(1.2);
      settingsVM.setLanguage('Spanish');
      settingsVM.setNotifications(false);

      // Reset settings to their default values
      settingsVM.resetToDefault();

      // Verify that all settings are reset to their defaults
      expect(settingsVM.isDarkTheme, false);
      expect(settingsVM.fontScale, 1.0);
      expect(settingsVM.selectedLanguage, 'English');
      expect(settingsVM.notificationsEnabled, true);
    });
  });
}
