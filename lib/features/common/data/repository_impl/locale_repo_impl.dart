import 'package:flutter/material.dart';

import '../../domain/repository/locale_repository.dart';
import '../data_source/local/locale_source.dart';

class LocaleRepositoryImpl implements LocaleRepository {
  final LocaleSource _localeSource;

  LocaleRepositoryImpl(this._localeSource);
  @override
  Locale readLocale() {
    return _localeSource.readLocale();
  }

  @override
  Future<bool> saveLocale(Locale locale) async {
    return await _localeSource.saveLocale(locale);
  }
}
