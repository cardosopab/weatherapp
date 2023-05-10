import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../models/location/location.dart';
import '../../../functions/format_unit.dart';
import '../../../services/daily_list.dart';
import '../../../services/hourly_list.dart';
import '../../../services/location_object.dart';

class WeeklyList extends ConsumerWidget {
  const WeeklyList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Location location = ref.watch(locationObjectStateProvider);
    final hourlyList = ref.watch(hourlyProvider);
    final hourlyItem = hourlyList[location.name];
    final dailyList = ref.watch(dailyProvider);
    final dailyItem = dailyList[location.name];
    return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dailyItem!.length,
              itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 35,
                    child: Text(
                      DateFormat("E").format(
                        DateTime.fromMillisecondsSinceEpoch(
                          dailyItem[index].dt!.toInt() * 1000,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        "assets/images/${hourlyItem![index].weather.first.icon}.png",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 35,
                    child: Text(
                      "${formatUnit(dailyItem[index].temp.morn, ref)}°",
                    ),
                  ),
                  SizedBox(
                    width: 35,
                    child: Text(
                      "${formatUnit(dailyItem[index].temp.day, ref)}°",
                    ),
                  ),
                  SizedBox(
                    width: 35,
                    child: Text(
                      "${formatUnit(dailyItem[index].temp.eve, ref)}°",
                    ),
                  ),
                  SizedBox(
                    width: 35,
                    child: Text(
                      "${formatUnit(dailyItem[index].temp.night, ref)}°",
                    ),
                  ),
                ],
              ),
            );
  }
}