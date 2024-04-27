import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/resources/string_res.dart';

abstract class LocaleSource {
  static const String kKeyLangCode = "LANG_CODE";
  static const String kKeyCountryCode = "COUNTRY_CODE";

  Future<bool> saveLocale(Locale locale);
  Locale readLocale();
}

class LocaleSourceImpl implements LocaleSource {
  final SharedPreferences _preferences;

  LocaleSourceImpl(this._preferences);
  @override
  Locale readLocale() {
    return Locale(
      _preferences.getString(LocaleSource.kKeyLangCode) ??
          StringRes.kLangCodeEN,
      _preferences.getString(LocaleSource.kKeyCountryCode) ??
          StringRes.kLangCountryUS,
    );
  }

  @override
  Future<bool> saveLocale(Locale locale) async {
    return await _preferences.setString(
          LocaleSource.kKeyLangCode,
          locale.languageCode,
        ) &&
        await _preferences.setString(
          LocaleSource.kKeyCountryCode,
          locale.countryCode!,
        );
  }
}
