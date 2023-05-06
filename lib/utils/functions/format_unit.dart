import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/utils/services/temp_unit.dart';

String formatUnit(k, WidgetRef ref) {
  bool tempUnit = ref.watch(tempUnitStateNotifierProvider);
  double unit = 0;
  if (tempUnit) {
    unit = (((k - 273.15) * 9 / 5) + 32);
  } else {
    unit = k - 273.15;
  }
  return unit.toStringAsFixed(1);
}
