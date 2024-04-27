import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:weather/features/landing/presentation/cubit/forecast_cubit.dart';
import 'package:weather/features/landing/presentation/cubit/logic_cubit/logical_cubit.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../../core/resources/error_msg_res.dart';
import '../../../../core/utils/nums.dart';
import '../../../common/presentation/widgets/app_dialog.dart';
import '../../data/model/forecast_response.dart';
import '../widgets/horizontal_forecast_list.dart';

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
          final location = state.location;
          final current = state.current;
          final forecast = state.forecast;
          return _detailWeather(context, location, current, forecast);
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

  Widget _detailWeather(
      ctx, Location? location, Current? current, Forecast? forecast) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF97ABFF),
            Color(0xFF123597),
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 30.sp,
          ),
          Center(
            child: Text(
              location?.name ?? '',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32.sp,
              ),
            ),
          ),
          SizedBox(
            height: 5.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/location_1.png',
              ),
              SizedBox(width: 8.sp), // Adjust the spacing between icon and text
              Text(
                'Current Location',
                style: GoogleFonts.inter(
                  color: Colors.white, // Change the color as needed
                  fontWeight: FontWeight.normal,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/partly_cloudy_1.png',
              ),
              SizedBox(width: 8.sp), // Adjust the spacing between icon and text
              Text(
                '${current!.tempC!.toInt()}\u00B0',
                style: GoogleFonts.inter(
                  color: Colors.white, // Change the color as needed
                  fontWeight: FontWeight.normal,
                  fontSize: 90.sp,
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              '${forecast!.forecastday![0].day!.condition!.text!} - '
              'H:${forecast.forecastday![0].day!.maxtempC!.toInt()}\u00B0 '
              'L:${forecast.forecastday![0].day!.mintempC!.toInt()}\u00B0',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 18.sp,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(
                      255, 255, 255, 0.1), // White with 10% opacity
                ),
                child: const Text(
                  'Today',
                  style: TextStyle(
                      color: Colors.white), // Adjust text color as needed
                ),
              ),
              SizedBox(width: 8.sp), // Adjust the spacing between icon and text

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(
                      0, 0, 0, 0.1), // White with 10% opacity
                ),
                child: const Text(
                  'Next Days',
                  style: TextStyle(
                      color: Colors.white), // Adjust text color as needed
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12.sp,
          ),
          SizedBox(
            height: 120.sp,
            child: HorizontalForecastList(
              hours: forecast.forecastday![0].hour!,
            ),
          ),
          SizedBox(
            height: 10.sp,
          ),
          Stack(
            children: [
              SizedBox(
                height: 10.sp,
              ),
              Image.asset(
                'assets/images/subtract.png',
                width: double.infinity,
                // height: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: -10,
                left: (MediaQuery.of(context).size.width - 50) / 2,
                child: Image.asset(
                  'assets/images/ellipse.png',
                  width: 50,
                  height: 50,
                ),
              ),
              Positioned(
                top: 50,
                left: 30,
                child: Container(
                  height: 70.sp,
                  width: 250.sp,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8.sp),
                      Image.asset(
                        'assets/images/sun_fog.png',
                      ),
                      SizedBox(
                          width:
                              8.sp), // Adjust the spacing between icon and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sunrise',
                            style: GoogleFonts.inter(
                              color: Colors.white, // Change the color as needed
                              fontWeight: FontWeight.normal,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            forecast.forecastday![0].astro!.sunrise!,
                            style: GoogleFonts.inter(
                              color: Colors.white, // Change the color as needed
                              fontWeight: FontWeight.normal,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(), // Adjust the spacing between icon and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sunset',
                            style: GoogleFonts.inter(
                              color: Colors.white, // Change the color as needed
                              fontWeight: FontWeight.normal,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            forecast.forecastday![0].astro!.sunset!,
                            style: GoogleFonts.inter(
                              color: Colors.white, // Change the color as needed
                              fontWeight: FontWeight.normal,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 150,
                left: 30,
                child: Container(
                  height: 70.sp,
                  width: 250.sp,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8.sp),
                      Image.asset(
                        'assets/images/sun.png',
                      ),
                      SizedBox(
                          width:
                              8.sp), // Adjust the spacing between icon and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'UV Index',
                            style: GoogleFonts.inter(
                              color: Colors.white, // Change the color as needed
                              fontWeight: FontWeight.normal,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            '${forecast.forecastday![0].day!.uv!.toInt()} '
                            '${_getUVDescription(forecast.forecastday![0].day!.uv!.toInt())}',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(), // Adjust the spacing between icon and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '',
                            style: GoogleFonts.inter(
                              color: Colors.white, // Change the color as needed
                              fontWeight: FontWeight.normal,
                              fontSize: 15.sp,
                            ),
                          ),
                          Text(
                            '',
                            style: GoogleFonts.inter(
                              color: Colors.white, // Change the color as needed
                              fontWeight: FontWeight.normal,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String _getUVDescription(int uvIndex) {
    if (uvIndex <= 2) {
      return "Low";
    } else if (uvIndex <= 5) {
      return "Moderate";
    } else if (uvIndex <= 7) {
      return "High";
    } else if (uvIndex <= 10) {
      return "Very High";
    } else {
      return "Extreme";
    }
  }
}
