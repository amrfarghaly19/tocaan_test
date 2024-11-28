/*
import 'package:flutter/foundation.dart';

class LanguageProvider with ChangeNotifier {
  String selectedLanguage = '';

  void setSelectedLanguage(String languageCode) {
    selectedLanguage = languageCode;
    notifyListeners();
  }
}
*/


import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _selectedLanguage = 'en';

  String get selectedLanguage => _selectedLanguage;

  void setSelectedLanguage(String languageCode) {
    _selectedLanguage = languageCode;
    notifyListeners();
  }
}
