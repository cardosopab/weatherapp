import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/weather_api/weather_api.dart';

class HourlyList extends StateNotifier<Map<String, List<Hourly>>> {
  HourlyList(Map<String, List<Hourly>> state) : super(state);

  void addList(String key, List<Hourly> newList) {
    state = {...state, key: newList};
  }

  void deleteList(String key) {
    state.clear();
  }
}

final hourlyProvider = StateNotifierProvider<HourlyList, Map<String, List<Hourly>>>((ref) {
  return HourlyList({});
});
