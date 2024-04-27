import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../core/resources/string_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/navigation/route_config.dart';
import '../core/utils/dependency.dart';
import '../core/utils/lang/app_localizations.dart';
import 'common/presentation/cubit/locale/locale_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

final routeConfig = RouteConfig();

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: Dependency.providers,
      child: _buildMaterialApp(),
    );
  }

  BlocBuilder<LocaleCubit, LocaleState> _buildMaterialApp() {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return OKToast(
          child: Sizer(
            builder: (context, orientation, deviceType) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                onGenerateRoute: routeConfig.routes,
                supportedLocales: _supportedLocale,
                localizationsDelegates: _localizationDelegates,
                localeResolutionCallback: localeResolution,
                locale: state.getCurrentLocale(),
                builder: EasyLoading.init(),
              );
            },
          ),
        );
      },
    );
  }

  final _supportedLocale = [
    const Locale(StringRes.kLangCodeEN, StringRes.kLangCountryUS),
    const Locale(StringRes.kLangCodeBN, StringRes.kLangCountryBD),
  ];

  final _localizationDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  Locale localeResolution(locale, supportedLocales) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }
}
