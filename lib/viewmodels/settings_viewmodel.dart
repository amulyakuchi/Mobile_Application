import 'package:flutter/material.dart';

/// ViewModel for managing app settings such as theme, font size, language, and notifications.
///
/// Provides functionality to update individual settings and reset them to default values.
class SettingsViewModel extends ChangeNotifier {
  // Theme management
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  /// Toggles between dark and light themes.
  void setDarkTheme(bool value) {
    if (_isDarkTheme != value) {
      _isDarkTheme = value;
      notifyListeners();
    }
  }

  // Font scale for adjusting text size
  double _fontScale = 1.0;
  double get fontScale => _fontScale;

  /// Updates the font scale within valid bounds (0.8x to 1.5x).
  void setFontScale(double value) {
    if (value >= 0.8 && value <= 1.5 && _fontScale != value) {
      _fontScale = value;
      notifyListeners();
    }
  }

  // Language management
  final List<String> _availableLanguages = ['English', 'Spanish', 'French', 'German'];
  String _selectedLanguage = 'English';
  String get selectedLanguage => _selectedLanguage;
  List<String> get availableLanguages => _availableLanguages;

  /// Sets the app language if it is in the list of available options.
  void setLanguage(String language) {
    if (_availableLanguages.contains(language) && _selectedLanguage != language) {
      _selectedLanguage = language;
      notifyListeners();
    }
  }

  // Notification toggle
  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  /// Enables or disables app notifications.
  void setNotifications(bool value) {
    if (_notificationsEnabled != value) {
      _notificationsEnabled = value;
      notifyListeners();
    }
  }

  /// Resets all settings to their default values.
  void resetToDefault() {
    bool shouldNotify = !_isDarkTheme ||
        _fontScale != 1.0 ||
        _selectedLanguage != 'English' ||
        !_notificationsEnabled;

    _isDarkTheme = false;
    _fontScale = 1.0;
    _selectedLanguage = 'English';
    _notificationsEnabled = true;

    if (shouldNotify) {
      notifyListeners();
    }
  }
}