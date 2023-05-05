import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/openweather/daily/daily.dart';

class DailyList extends StateNotifier<Map<String, List<Daily>>> {
  DailyList(Map<String, List<Daily>> state) : super(state);

  void addList(String key, List<Daily> newList) {
    state = {...state, key: newList};
  }

  void deleteList() {
    state.clear();
  }
}

final dailyProvider = StateNotifierProvider<DailyList, Map<String, List<Daily>>>((ref) {
  return DailyList({});
});
