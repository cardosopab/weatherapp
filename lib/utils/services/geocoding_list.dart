import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/geocoding/geocoding.dart';
import '../api/geo_fetch.dart';

class GeocodingList extends StateNotifier<List<GeoCoding>> {
  GeocodingList(List<GeoCoding> state) : super(state);

  Future<void> fetchGeocode(location) async {
    final api = GeoCodingAPI();
    final newGeocode = await api.geofetch(location);
    state = [...state, ...newGeocode];
  }

  void deleteList() {
    state.clear();
    state = state.toList();
  }
}

final geoCodingProvider = StateNotifierProvider<GeocodingList, List<GeoCoding>>((ref) {
  return GeocodingList([]);
});
