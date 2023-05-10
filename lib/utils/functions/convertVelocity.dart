import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/utils/services/temp_unit.dart';

String convertVelocity(k, WidgetRef ref) {
  bool tempUnit = ref.watch(tempUnitStateNotifierProvider);
  double unit = 0;
  if (tempUnit) {
    unit = k * 2.23694;
  } else {
    unit = k;
  }
  return unit.toStringAsFixed(1);
}
