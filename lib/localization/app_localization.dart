import 'package:shared_preferences/shared_preferences.dart';

import 'ar_eg/ar_eg_translations.dart';
import 'en_us/en_us_translations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

class AppLocalization {
  AppLocalization(this.locale);

  Locale locale;

  Future<void> setLanguage(String languageCode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('language', languageCode);
    locale = Locale(languageCode);
  }

  static Future<String?> getLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('language');
  }

  static final Map<String, Map<String, String>> _localizedValues = {'en': enUs, 'ar': arEG};

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  static List<String> languages() => _localizedValues.keys.toList();
  String getString(String text) =>
      _localizedValues[locale.languageCode]![text] ?? text;

  TextDirection getAppDirection() {
    return locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  Future<AppLocalization> load(Locale locale) async {
    final savedLanguage = await AppLocalization.getLanguage();
    final languageCode = savedLanguage ?? locale.languageCode;
    return AppLocalization(Locale(languageCode));
  }

  @override
  bool isSupported(Locale locale) =>
      AppLocalization.languages().contains(locale.languageCode);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}

extension BuildContextExtension on BuildContext {
  AppLocalization get appLocalization {
    final appLocalization =
    Localizations.of<AppLocalization>(this, AppLocalization);
    assert(appLocalization != null,
    'appLocalization must not be null. Make sure you have properly set up the localization delegates.');
    return appLocalization!;
  }
}
/*

extension LocalizationExtension on String {
  String tr(BuildContext context) => AppLocalization.of(context).getString(this);
}
*/

extension LocalizationExtension on String {
  String tr(BuildContext context, {List<String>? args}) {
    final localization = AppLocalization.of(context);
    String text = localization.getString(this);

    if (args != null && args.isNotEmpty) {
      for (var i = 0; i < args.length; i++) {
        text = text.replaceAll('{$i}', args[i]);
      }
    }

    return text;
  }
}


