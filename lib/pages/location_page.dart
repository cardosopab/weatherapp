import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/utils/services/location_object.dart';
import 'package:weatherapp/utils/ui/location_page.dart/body/location_app_bar.dart';
import 'package:weatherapp/utils/ui/location_page.dart/location_body.dart';
import '../models/location/location.dart';
import '../contants.dart';

class LocationPage extends ConsumerWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Location location = ref.watch(locationObjectStateProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: location.isDaytime! ? Constants().dayBackground : Constants().nightBackground,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: const SafeArea(
          child: CustomScrollView(
            slivers: [
              LocationAppBar(),
              LocationBody(),
            ],
          ),
        ),
      ),
    );
  }
}
