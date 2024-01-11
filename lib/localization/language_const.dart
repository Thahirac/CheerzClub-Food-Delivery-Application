import 'package:cheersclub/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String FRENCH = 'fr';
const String NEDERLANDS = 'nl';
const String GERMAN = 'de';
const String SPANISH = 'es';


Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case FRENCH:
      return  Locale(FRENCH, 'FR');
    case NEDERLANDS:
      return Locale(NEDERLANDS,'NL');
    case GERMAN:
      return Locale(GERMAN,'DE');
    case SPANISH:
      return  Locale(SPANISH,'ES');
    default:
      return Locale(ENGLISH, 'US');
  }
}


 getTranslated(BuildContext context, String key) {
  return AppLocalizations.of(context).translate(key);
}
