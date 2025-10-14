import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  late Box _settingsBox;
  
  // Theme settings
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 1.0;
  bool _animationsEnabled = true;
  
  // Reading settings
  String _preferredTranslation = 'English (Translator A)';
  bool _autoScrollEnabled = false;
  double _readingSpeed = 1.0;
  
  // Audio settings
  bool _ttsEnabled = true;
  String _ttsVoice = 'Default';
  double _ttsRate = 1.0;
  double _ttsVolume = 0.8;
  
  // Notification settings
  bool _dailyNotificationsEnabled = true;
  TimeOfDay _dailyReminderTime = const TimeOfDay(hour: 9, minute: 0);
  bool _streakNotificationsEnabled = true;

  // Getters
  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  double get fontSizeScalar => _fontSize; // Add this getter
  bool get animationsEnabled => _animationsEnabled;
  String get preferredTranslation => _preferredTranslation;
  bool get autoScrollEnabled => _autoScrollEnabled;
  double get readingSpeed => _readingSpeed;
  bool get ttsEnabled => _ttsEnabled;
  String get ttsVoice => _ttsVoice;
  double get ttsRate => _ttsRate;
  double get ttsVolume => _ttsVolume;
  bool get dailyNotificationsEnabled => _dailyNotificationsEnabled;
  TimeOfDay get dailyReminderTime => _dailyReminderTime;
  bool get streakNotificationsEnabled => _streakNotificationsEnabled;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _settingsBox = await Hive.openBox('settings');
    
    _themeMode = ThemeMode.values[_settingsBox.get('theme_mode', defaultValue: 0)];
    _fontSize = _settingsBox.get('font_size', defaultValue: 1.0);
    _animationsEnabled = _settingsBox.get('animations_enabled', defaultValue: true);
    
    _preferredTranslation = _settingsBox.get('preferred_translation', defaultValue: 'English (Translator A)');
    _autoScrollEnabled = _settingsBox.get('auto_scroll_enabled', defaultValue: false);
    _readingSpeed = _settingsBox.get('reading_speed', defaultValue: 1.0);
    
    _ttsEnabled = _settingsBox.get('tts_enabled', defaultValue: true);
    _ttsVoice = _settingsBox.get('tts_voice', defaultValue: 'Default');
    _ttsRate = _settingsBox.get('tts_rate', defaultValue: 1.0);
    _ttsVolume = _settingsBox.get('tts_volume', defaultValue: 0.8);
    
    _dailyNotificationsEnabled = _settingsBox.get('daily_notifications_enabled', defaultValue: true);
    final reminderHour = _settingsBox.get('daily_reminder_hour', defaultValue: 9);
    final reminderMinute = _settingsBox.get('daily_reminder_minute', defaultValue: 0);
    _dailyReminderTime = TimeOfDay(hour: reminderHour, minute: reminderMinute);
    _streakNotificationsEnabled = _settingsBox.get('streak_notifications_enabled', defaultValue: true);
    
    notifyListeners();
  }

  // Theme setters
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _settingsBox.put('theme_mode', mode.index);
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    await _settingsBox.put('font_size', size);
    notifyListeners();
  }

  Future<void> setAnimationsEnabled(bool enabled) async {
    _animationsEnabled = enabled;
    await _settingsBox.put('animations_enabled', enabled);
    notifyListeners();
  }

  // Reading setters
  Future<void> setPreferredTranslation(String translation) async {
    _preferredTranslation = translation;
    await _settingsBox.put('preferred_translation', translation);
    notifyListeners();
  }

  Future<void> setAutoScrollEnabled(bool enabled) async {
    _autoScrollEnabled = enabled;
    await _settingsBox.put('auto_scroll_enabled', enabled);
    notifyListeners();
  }

  Future<void> setReadingSpeed(double speed) async {
    _readingSpeed = speed;
    await _settingsBox.put('reading_speed', speed);
    notifyListeners();
  }

  // Audio setters
  Future<void> setTtsEnabled(bool enabled) async {
    _ttsEnabled = enabled;
    await _settingsBox.put('tts_enabled', enabled);
    notifyListeners();
  }

  Future<void> setTtsVoice(String voice) async {
    _ttsVoice = voice;
    await _settingsBox.put('tts_voice', voice);
    notifyListeners();
  }

  Future<void> setTtsRate(double rate) async {
    _ttsRate = rate;
    await _settingsBox.put('tts_rate', rate);
    notifyListeners();
  }

  Future<void> setTtsVolume(double volume) async {
    _ttsVolume = volume;
    await _settingsBox.put('tts_volume', volume);
    notifyListeners();
  }

  // Notification setters
  Future<void> setDailyNotificationsEnabled(bool enabled) async {
    _dailyNotificationsEnabled = enabled;
    await _settingsBox.put('daily_notifications_enabled', enabled);
    notifyListeners();
  }

  Future<void> setDailyReminderTime(TimeOfDay time) async {
    _dailyReminderTime = time;
    await _settingsBox.put('daily_reminder_hour', time.hour);
    await _settingsBox.put('daily_reminder_minute', time.minute);
    notifyListeners();
  }

  Future<void> setStreakNotificationsEnabled(bool enabled) async {
    _streakNotificationsEnabled = enabled;
    await _settingsBox.put('streak_notifications_enabled', enabled);
    notifyListeners();
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    await _settingsBox.clear();
    await _loadSettings();
  }
}