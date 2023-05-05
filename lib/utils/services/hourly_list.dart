import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/openweather/hourly/hourly.dart';

// class HourlyList extends StateNotifier<List<List<Hourly>>> {
//   HourlyList(List<List<Hourly>> state) : super(state);

//   void addList(newList) {
//     state = [...state, newList];
//   }

//   void deleteList() {
//     state.clear();
//   }
// }

// final hourlyProvider = StateNotifierProvider<HourlyList, List<List<Hourly>>>((ref) {
//   return HourlyList([]);
// });

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
