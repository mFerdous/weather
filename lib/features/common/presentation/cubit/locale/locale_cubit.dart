import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/string_res.dart';
import '../../../domain/usecase/locale_usecase.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final ReadLocaleUsecase readLocaleUsecase;
  final SaveLocaleUsecase saveLocaleUsecase;

  LocaleCubit({
    required this.readLocaleUsecase,
    required this.saveLocaleUsecase,
  }) : super(const LocaleState()) {
    readFromPreference();
  }

  void changeLanguageToEnglish() {
    saveToPreference(const Locale(
      StringRes.kLangCodeEN,
      StringRes.kLangCountryUS,
    ));
  }

  void changeLanguageToBangla() {
    saveToPreference(const Locale(
      StringRes.kLangCodeBN,
      StringRes.kLangCountryBD,
    ));
  }

  Future<void> saveToPreference(Locale locale) async {
    emit(LocaleState(
      langCode: locale.languageCode,
      countryCode: locale.countryCode!,
    ));
    await saveLocaleUsecase(locale);
  }

  void readFromPreference() {
    final locale = readLocaleUsecase();
    emit(LocaleState(
      langCode: locale.languageCode,
      countryCode: locale.countryCode!,
    ));
  }
}
