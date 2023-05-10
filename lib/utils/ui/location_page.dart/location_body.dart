import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/utils/ui/location_page.dart/body/hourly_forecast.dart';
import 'package:weatherapp/utils/ui/location_page.dart/body/weekly_forecast.dart';
import 'package:weatherapp/utils/ui/location_page.dart/location_hero.dart';


class LocationBody extends ConsumerWidget {
  const LocationBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList(
      delegate: SliverChildListDelegate(
        const [
          LocationHero(),
          HourlyForecast(),
          WeeklyForecast(),
        ],
      ),
    );
  }
}
