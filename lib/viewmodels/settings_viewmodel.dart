import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  void setDarkTheme(bool value) {
    if (_isDarkTheme != value) {
      _isDarkTheme = value;
      notifyListeners();
    }
  }

  double _fontScale = 1.0;
  double get fontScale => _fontScale;

  void setFontScale(double value) {
    if (value >= 0.8 && value <= 1.5 && _fontScale != value) {
      _fontScale = value;
      notifyListeners();
    }
  }

  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  void setNotifications(bool value) {
    if (_notificationsEnabled != value) {
      _notificationsEnabled = value;
      notifyListeners();
    }
  }

  void resetToDefault() {
    bool shouldNotify = !_isDarkTheme ||
        _fontScale != 1.0 ||
        !_notificationsEnabled;

    _isDarkTheme = false;
    _fontScale = 1.0;
    _notificationsEnabled = true;

    if (shouldNotify) {
      notifyListeners();
    }
  }
}
