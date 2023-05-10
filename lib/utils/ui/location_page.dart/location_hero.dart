import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/utils/functions/convertVelocity.dart';

import '../../../models/location/location.dart';
import '../../../widgets/glass.dart';
import '../../functions/format_unit.dart';
import '../../services/daily_list.dart';
import '../../services/hourly_list.dart';
import '../../services/location_object.dart';
import '../../services/temp_unit.dart';

class LocationHero extends ConsumerWidget {
  const LocationHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Location location = ref.watch(locationObjectStateProvider);
    final tempUnit = ref.watch(tempUnitStateNotifierProvider);
    final hourlyList = ref.watch(hourlyProvider);
    final hourlyItem = hourlyList[location.name];
    final dailyList = ref.watch(dailyProvider);
    final dailyItem = dailyList[location.name];
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 8, 40, 40),
      child: GlassMorphism(
        isDaytime: location.isDaytime,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(location.name!),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${formatUnit(hourlyItem!.first.temp, ref)}°${tempUnit ? 'F' : "C"}",
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(hourlyItem.first.weather.first.main),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "H:${formatUnit(dailyItem!.first.temp.max, ref)}° L:${formatUnit(dailyItem.first.temp.min, ref)}°",
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("HUMIDITY: ${dailyItem.first.humidity}%"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("FEELS LIKE: ${formatUnit(hourlyItem.first.feelsLike, ref)}°"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("WIND SPEED: ${convertVelocity(hourlyItem.first.windSpeed, ref)} ${tempUnit ? "MPH" : "M/S"}"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
