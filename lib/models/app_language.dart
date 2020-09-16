import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('uz');

  Locale get appLocal => _appLocale ?? Locale("uz");
  Future fetchLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('lang') == null) {
      _appLocale = Locale('uz');
      return Null;
    }
    _appLocale = Locale(prefs.getString('lang'));
    return _appLocale;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == Locale("uz")) {
      _appLocale = Locale("uz");
      await prefs.setString('lang', 'uz');
      await prefs.setString('countryCode', 'UZ');
    } else if (type == Locale("ru")) {
      _appLocale = Locale("ru");
      await prefs.setString('lang', 'ru');
      await prefs.setString('countryCode', 'RU');
    } else {
      _appLocale = Locale("uzc");
      await prefs.setString('lang', 'uzc');
      await prefs.setString('countryCode', 'UZ');
    }
    notifyListeners();
  }
}
