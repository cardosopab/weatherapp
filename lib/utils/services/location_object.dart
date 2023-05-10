import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/location/location.dart';

class LocationObject extends StateNotifier<Location> {
  LocationObject(Location location) : super(location);

  void saveLocation(Location location) async {
    state = location;
  }
}

final locationObjectStateProvider = StateNotifierProvider<LocationObject, Location>((ref) {
  return LocationObject(Location());
});
