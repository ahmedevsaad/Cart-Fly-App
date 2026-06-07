import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  String _currency = 'USD';
  Locale get locale => _locale;
  String get currency => _currency;

  static const _localeKey = 'locale';
  static const _currencyKey = 'currency';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final code = p.getString(_localeKey);
    if (code != null) _locale = Locale(code);
    _currency = p.getString(_currencyKey) ?? 'USD';
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString(_localeKey, locale.languageCode);
  }

  void toggleLocale() => setLocale(
      _locale.languageCode == 'en' ? const Locale('ar') : const Locale('en'));

  Future<void> setCurrency(String c) async {
    _currency = c;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString(_currencyKey, c);
  }
}
