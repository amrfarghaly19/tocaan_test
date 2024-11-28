



import 'package:flutter/material.dart';
import 'package:gymjoe/localization/prividerlanguage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configre/globale_variables.dart';
import '../localization/app_localization.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../theme/widgets/bottombar_provider.dart';

class LanguageSelect extends StatefulWidget {
  final String Token;
  LanguageSelect({required this.Token});

  @override
  State<LanguageSelect> createState() => _LanguageSelectState();
}

class _LanguageSelectState extends State<LanguageSelect> {
  String selectedLanguage = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final savedLanguage = await AppLocalization.getLanguage();
    if (mounted) {
      setState(() {
        selectedLanguage = savedLanguage ?? 'en';
      });
    }
  }

  Future<void> _setSelectedLanguage(BuildContext context, String languageCode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('language', languageCode);
    AppLocalization.of(context).setLanguage(languageCode);

    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.setSelectedLanguage(languageCode);

    if (mounted) {
      setState(() {
        selectedLanguage = languageCode;
      });
    }
    await _updateLanguage();
    Navigator.pop(context);
    Provider.of<NavigationProvider>(context, listen: false).setIndex(0); // For example, to navigate to the third tab

    // Close the dialog
  }

  Future<void> _updateLanguage() async {
    var url = Uri.parse("${Config.baseURL}/change-language/en");
    var headers = {
      'Authorization': "Bearer ${widget.Token}",
      'Accept': 'application/json',
      'Connection': 'keep-alive',
    };

    var response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      // Capture cookies if returned in response headers
      String? cookies = response.headers['set-cookie'];
      if (cookies != null) {
        await saveCookies("laravel_session=z3uRiMkVY0raDqzynCSdACOgqFG03qhosD9BbXr9");
      }
      print("Language changed successfully: ${response.body}");
    } else {
      print("Failed to change language: ${response.body}");
      throw Exception('Failed to change language');
    }
  }
  Future<void> saveCookies(String cookies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cookies', cookies);
  }

// Retrieve cookies from storage
  Future<String?> getCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cookies');
  }

 /* Future<void> _updateLanguage() async {
    print("selectedLanguage $selectedLanguage");
    print("selectedLanguage ${widget.Token}");

    var url = Uri.parse("${Config.baseURL}/change-language/en");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.Token}'
    };

    var response2 = await http.post(url, headers: headers);
   // allData = json.decode(response.body);
    //var url = Uri.parse("${Config.baseURL}/change-language/ar");
   // var request = http.MultipartRequest('POST', url);
    print(url);
    print(headers);

    // Add header

   // var response2 = await request.send();
   // var responseData = await response2.stream.bytesToString();
    var loginMap = json.decode(response2.body);

    print(loginMap);
   // Provider.of<NavigationProvider>(context, listen: false).setIndex(0); // For example, to navigate to the third tab

  }*/


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child:  Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color:Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                _buildLanguageOption(
                  context,
                  'English',
                  '🇬🇧',
                  'en',
                  selectedLanguage == 'en',
                ),
                SizedBox(height: 15),
                _buildLanguageOption(
                  context,
                  'العربية',
                  '🇸🇦',
                  'ar',
                  selectedLanguage == 'ar',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language, String asset, String code, bool isSelected) {
    return GestureDetector(
      onTap: () => _setSelectedLanguage(context, code),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Color(0xFFFF0336) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Replace with your own image or icon for flag representation
           // Image.asset(asset, width: 24, height: 24),
            Text(
              asset,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                language,
                style: TextStyle(fontSize: 18,
                  fontFamily: 'Cairo',color: Colors.white),
              ),
            ),
            isSelected ?
              Icon(
                Icons.check_circle,
                color: Color(0xFFFF0336),
              ):  Icon(
              Icons.circle_outlined,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
