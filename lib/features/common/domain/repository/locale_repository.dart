import 'package:flutter/material.dart';

abstract class LocaleRepository {
  Future<bool> saveLocale(Locale locale);
  Locale readLocale();
}
