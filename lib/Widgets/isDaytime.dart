import 'package:flutter_riverpod/flutter_riverpod.dart';

bool isDaytime = true;
final isDaytimeProvider = StateProvider<bool>((ref) => isDaytime);
