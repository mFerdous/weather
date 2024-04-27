import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/common/data/repository_impl/locale_repo_impl.dart';
import '../../features/common/domain/repository/locale_repository.dart';
import '../../features/common/domain/usecase/locale_usecase.dart';
import '../../features/common/presentation/cubit/locale/locale_cubit.dart';
import '../../features/common/data/data_source/local/locale_source.dart';
import '../../features/common/data/data_source/local/token_source.dart';
import '../../features/landing/data/remote/forecast_remote.dart';
import '../../features/landing/data/repository_impl/forecast_repository_impl.dart';
import '../../features/landing/domain/repository/forecast_repository.dart';
import '../../features/landing/domain/usecase/forecast_usecase.dart';
import '../../features/landing/presentation/cubit/forecast_cubit.dart';
import '../../features/landing/presentation/cubit/logic_cubit/logical_cubit.dart';
import '../header_provider/header_provider.dart';

import '../network/connection_checker.dart';

class Dependency {
  static final sl = GetIt.instance;
  Dependency._init();

  static Future<void> init() async {
//-------------------------------------------------------//
    sl.registerLazySingleton<LocaleSource>(() => LocaleSourceImpl(sl()));

    sl.registerLazySingleton<LocaleRepository>(
        () => LocaleRepositoryImpl(sl()));
    sl.registerLazySingleton(() => ReadLocaleUsecase(sl()));
    sl.registerLazySingleton(() => SaveLocaleUsecase(sl()));
    sl.registerLazySingleton(() => LocaleCubit(
          readLocaleUsecase: sl(),
          saveLocaleUsecase: sl(),
        ));
    final sharedPref = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPref);
    sl.registerLazySingleton(() => Client());

    sl.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(),
    );
    sl.registerLazySingleton<TokenSource>(() => TokenSourceImpl(sl()));
    sl.registerLazySingleton<HeaderProvider>(() => HeaderProviderImpl());
    sl.registerLazySingleton(() => AuthHeaderProvider(sl()));
    
//---------------------------Git Repository Start-------------------------------//

    sl.registerLazySingleton<ForecastRemote>(
      () => ForecastRemoteImpl(sl()),
    );

    sl.registerLazySingleton<ForecastRepository>(
      () => ForecastRepositoryImpl(
        sl(),
        sl(),
      ),
    );
    sl.registerLazySingleton(() => ForecastUsecase(sl()));
    sl.registerFactory(() => ForecastCubit(weatherForecastUsecase: sl()));
    sl.registerFactory(() => LogicalCubit());

//---------------------------Git Repository End-------------------------------//
  }

  static final providers = <BlocProvider>[
    BlocProvider<LocaleCubit>(
      create: (context) => Dependency.sl<LocaleCubit>(),
    ),
    BlocProvider<LogicalCubit>(
      create: (context) => Dependency.sl<LogicalCubit>(),
    ),
    BlocProvider<ForecastCubit>(
      create: (context) => Dependency.sl<ForecastCubit>(),
    ),
  ];
}
