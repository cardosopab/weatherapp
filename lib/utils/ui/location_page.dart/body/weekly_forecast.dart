import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/utils/ui/location_page.dart/body/weekly_header.dart';
import 'package:weatherapp/utils/ui/location_page.dart/body/weekly_list.dart';

import '../../../../models/location/location.dart';
import '../../../../widgets/glass.dart';
import '../../../services/location_object.dart';

class WeeklyForecast extends ConsumerWidget {
  const WeeklyForecast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Location location = ref.watch(locationObjectStateProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GlassMorphism(
        isDaytime: location.isDaytime,
        child: Column(
          children: const [
            WeeklyHeader(),
            WeeklyList(),
          ],
        ),
      ),
    );
  }
}
