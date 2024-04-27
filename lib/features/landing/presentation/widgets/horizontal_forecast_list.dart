import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../data/model/forecast_response.dart';

class HorizontalForecastList extends StatelessWidget {
  final List<Hour> hours;

  HorizontalForecastList({required this.hours});

  @override
  Widget build(BuildContext context) {
    DateTime roundedDateTime(DateTime dateTime) {
      return DateTime(
          dateTime.year, dateTime.month, dateTime.day, dateTime.hour);
    }

    // Get the current hour
    DateTime now = DateTime.now();
    DateTime rounded = roundedDateTime(now);
    int currentHourIndex = hours.indexWhere((hour) {
      // Convert hour string to DateTime for comparison
      DateTime hourTime = DateTime.parse(hour.time!);

      return hourTime.isAtSameMomentAs(
          rounded); // Return true if the hour is after the current time
    });

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(
        width: 5,
      ),
      itemCount: currentHourIndex != -1
          ? hours.length - currentHourIndex
          : 0, // If no match found, display nothing
      itemBuilder: (context, index) {
        var hour = hours[currentHourIndex + index];

        String hourText;
        if (index == 0) {
          hourText = 'Now';
        } else {
          hourText = DateFormat('ha').format(DateTime.parse(hour.time!));
        }

        return Container(
          width: 55.sp,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Color.fromRGBO(255, 255, 255, 0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                hourText, // Assuming time is a string in your data model
                style: const TextStyle(color: Colors.white),
              ),
              Image.network('https:${hour.condition!.icon!}'),
              Text(
                '${hour.tempC!.toInt()}\u00B0', // Assuming tempC is a double in your data model
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              // Add more Text widgets to display additional forecast data
            ],
          ),
        );
      },
    );
  }
}
