part of 'locale_cubit.dart';

class LocaleState extends Equatable {
  final String langCode;
  final String countryCode;

  const LocaleState({
    this.langCode = StringRes.kLangCodeEN,
    this.countryCode = StringRes.kLangCountryUS,
  });

  Locale getCurrentLocale() {
    return Locale(langCode, countryCode);
  }

  @override
  List<Object> get props => [langCode, countryCode];
}
