import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/location/location.dart';
import '../../../../widgets/glass.dart';
import '../../../functions/format_unit.dart';
import '../../../functions/hourly_time.dart';
import '../../../services/hourly_list.dart';
import '../../../services/location_object.dart';

class HourlyForecast extends ConsumerWidget {
  const HourlyForecast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Location location = ref.watch(locationObjectStateProvider);
    final hourlyList = ref.watch(hourlyProvider);
    final hourlyItem = hourlyList[location.name];
    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GlassMorphism(
          isDaytime: location.isDaytime,
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 8, 4),
                  child: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: Icon(
                            Icons.access_time_filled,
                            size: 15,
                          ),
                        ),
                        TextSpan(text: " HOURLY FORECAST"),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 12,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(hourlyTime(hourlyItem![index].dt!.toInt(), location.timezone!)),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage("assets/images/${hourlyItem[index].weather.first.icon}.png"),
                          ),
                        ),
                        Text(
                          '${formatUnit(hourlyItem[index].temp, ref)}°',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
