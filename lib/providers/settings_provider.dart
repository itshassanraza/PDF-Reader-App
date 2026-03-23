import 'package:flutter/material.dart';
// import 'package:shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class SettingsProvider with ChangeNotifier {
  bool _darkMode = false;
  bool _autoOpen = true;
  bool _showThumbnails = true;
  String _defaultViewMode = 'list';

  bool get darkMode => _darkMode;
  bool get autoOpen => _autoOpen;
  bool get showThumbnails => _showThumbnails;
  String get defaultViewMode => _defaultViewMode;

  ThemeMode get themeMode => _darkMode ? ThemeMode.dark : ThemeMode.light;

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool(AppConstants.keyDarkMode) ?? false;
    _autoOpen = prefs.getBool(AppConstants.keyAutoOpen) ?? true;
    _showThumbnails = prefs.getBool('show_thumbnails') ?? true;
    _defaultViewMode = prefs.getString('default_view_mode') ?? 'list';
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyDarkMode, value);
    notifyListeners();
  }

  Future<void> setAutoOpen(bool value) async {
    _autoOpen = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyAutoOpen, value);
    notifyListeners();
  }

  Future<void> setShowThumbnails(bool value) async {
    _showThumbnails = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_thumbnails', value);
    notifyListeners();
  }

  Future<void> setDefaultViewMode(String value) async {
    _defaultViewMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('default_view_mode', value);
    notifyListeners();
  }
}
