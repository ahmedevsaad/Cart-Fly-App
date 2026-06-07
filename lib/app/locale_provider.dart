import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  static const _key = 'locale';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final code = p.getString(_key);
    if (code != null) _locale = Locale(code);
    notifyListeners();
  }

  Future<void> set(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, locale.languageCode);
  }

  void toggle() => set(
        _locale.languageCode == 'en' ? const Locale('ar') : const Locale('en'),
      );
}
