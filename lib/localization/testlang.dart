/*
import 'package:flutter/material.dart';

import 'app_localization.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(
          title: Text('Language Selection'),
        ),
        body: Center(
          child: DropdownButton<String>(
            value: AppLocalization.of().locale.languageCode,
            onChanged: (String? newLanguage) {
              AppLocalization.of().setLanguage(newLanguage!);
              // Rebuild the UI
              Navigator.of(context).popAndPushNamed('/home_screen');
            },
            items: AppLocalization.languages().map<DropdownMenuItem<String>>(
                  (String languageCode) {
                return DropdownMenuItem<String>(
                  value: languageCode,
                  child: Text(languageCode.toUpperCase()),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
*/
