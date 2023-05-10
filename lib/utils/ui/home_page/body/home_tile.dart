import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/location/location.dart';
import '../../../../widgets/glass.dart';
import '../../../functions/format_unit.dart';
import '../../../services/temp_unit.dart';

class HomeTile extends ConsumerWidget {
  Location location;
  HomeTile({super.key, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempUnit = ref.watch(tempUnitStateNotifierProvider);
    return GlassMorphism(
      isDaytime: location.isDaytime,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text(
                    location.name.toString(),
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
                Text(location.main.toString(), style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Text(
                  '${formatUnit(location.temp!, ref)}°${tempUnit ? 'F' : "C"}',
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage("assets/images/${location.icon}.png"), fit: BoxFit.none),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
