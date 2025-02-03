import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _language = "ar";

  bool get isDarkMode => _isDarkMode;
  String get language => _language;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _language = prefs.getString('language') ?? "ar";
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    _isDarkMode = value;
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', lang);
  _language = lang;
  Get.updateLocale(Locale(lang)); // تحديث اللغة في التطبيق بالكامل
  notifyListeners();
}

}
