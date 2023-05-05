import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/openCoding/result.dart';
import '../functions/geo_fetch.dart';

class GeocodingList extends StateNotifier<List<OpenCoding>> {
  GeocodingList(List<OpenCoding> state) : super(state);

  Future<void> fetchGeocode(location) async {
    final api = GeoCodingAPI();
    final newGeocode = await api.geofetch(location);
    state = [...state, ...newGeocode];
  }

  void deleteList() {
    state.clear();
  }
}

final geoCodingProvider = StateNotifierProvider<GeocodingList, List<OpenCoding>>((ref) {
  return GeocodingList([]);
});
