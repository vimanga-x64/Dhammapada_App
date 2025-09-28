import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider with ChangeNotifier {
  late Box _settingsBox;

  SettingsProvider() {
    _settingsBox = Hive.box('settings');
  }

  // Theme settings
  ThemeMode get themeMode {
    final isDarkMode = _settingsBox.get('isDarkMode', defaultValue: false) as bool;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool isDark) {
    _settingsBox.put('isDarkMode', isDark);
    notifyListeners();
  }

  // Font size settings
  double get fontSizeScalar {
    return _settingsBox.get('fontSizeScalar', defaultValue: 1.0) as double;
  }

  void setFontSizeScalar(double value) {
    _settingsBox.put('fontSizeScalar', value);
    notifyListeners();
  }
}