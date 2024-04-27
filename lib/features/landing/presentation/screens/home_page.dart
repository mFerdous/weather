import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:weather/features/landing/presentation/cubit/forecast_cubit.dart';
import 'package:weather/features/landing/presentation/cubit/logic_cubit/logical_cubit.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../../core/resources/error_msg_res.dart';
import '../../../../core/utils/nums.dart';
import '../../../common/presentation/widgets/app_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Future<void> getPosition() async {
    context.read<LogicalCubit>().getLatLng().then((value) {
      log(value.toString());
      if (value) {
        getWeatherForecast();
      }
    });
  }

  Future<void> getWeatherForecast() async {
    isConnected = await checkInternetConnection();
    if (isConnected) {
      log('message: $isConnected');
      forecast();
    } else {
      const AppDialog(
        title: ErrorMsgRes.kNoInternet,
        isNoInternet: true,
      );
    }
  }

  Future<void> forecast() async {
    await BlocProvider.of<ForecastCubit>(context).getForecast();
  }

  @override
  void initState() {
    getPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForecastCubit, ForecastState>(
      listener: (context, state) {
        if (state is ForecastLoading) {
          Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: Colors.white.withOpacity(0.25),
              size: 50,
            ),
          );
        } else if (state is ForecastSucceed) {
          final nItems = state.model;

          context.read<LogicalCubit>().setForecast(nItems);
        } else if (state is ForecastFailed) {
          // Navigator.pop(context);
          final ex = state.exception;
          if (ex is ServerException) {
            AppDialog(
              title: ex.message ?? '',
              isNoInternet: false,
            );
            //  return showAppDialog(context, title: ex.message ?? '');
          } else if (ex is NoInternetException) {
            const AppDialog(
              title: ErrorMsgRes.kNoInternet,
              isNoInternet: true,
            );
          } else {
            const Text('No data found!');
          }
        }
      },
      child: Scaffold(
        body: RefreshIndicator(
            onRefresh: () async {
              log('refresh call');
             await getPosition();
            },
            child: weatherWidget()),
      ),
    );
  }

  Widget weatherWidget() {
    return BlocBuilder<LogicalCubit, LogicalState>(
      builder: (context, state) {
        if (state.location?.country != null) {
          return Center(
            child: Text(
              '$latitude, $longitude',
            ),
          );
        } else {
          if (isConnected == true) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return const Center(
              child: Text(
                ErrorMsgRes.kNoInternet,
              ),
            );
          }
        }
      },
    );
  }
}
