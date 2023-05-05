import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/utils/services/daily_list.dart';
import 'package:weatherapp/utils/services/hourly_list.dart';

import '../../models/sharedpreferences/sharedPref.dart';
import '../functions/current_time.dart';
import 'location_fetch.dart';

class LocationNotifier extends StateNotifier<List<SharedPref>> {
  late final SharedPreferences _prefs;
  LocationNotifier(List<SharedPref> locationList) : super(locationList) {
    _loadLocationList();
  }

  void addLocation(SharedPref location) {
    state = [...state, location];
    _saveLocationList();
  }

  void _updateLocation(SharedPref newlocation) {
    state = state.map((location) {
      return location.name == newlocation.name ? newlocation : location;
    }).toList();
    state.toList();
    _saveLocationList();
  }

  Future<void> updateLocation(name, coordinates, ref) async {
    final api = LocationAPI();
    final newLocation = await api.locationFetch(coordinates);
    print(newLocation.hourly![0].temp);
    ref.read(hourlyProvider.notifier).addList(name, newLocation.hourly!);
    ref.read(dailyProvider.notifier).addList(name, newLocation.daily!);
    _updateLocation(SharedPref(
      icon: newLocation.current!.weather!.first.icon,
      description: newLocation.current!.weather!.first.description,
      temp: newLocation.current!.temp.ceil().toString(),
      coordinates: coordinates,
      humidity: newLocation.daily!.first.humidity.toString(),
      main: newLocation.current!.weather!.first.main,
      moon_phase: newLocation.daily!.first.moon_phase.toString(),
      timezone: newLocation.timezone,
      dt: currentTime(newLocation.current!.dt.toInt(), newLocation.timezone.toString()),
      name: name,
      isDaytime: newLocation.current!.weather!.first.icon.contains('d') ? true : false,
    ));
  }

  Future<void> fetchLocation(name, coordinates, WidgetRef ref) async {
    final api = LocationAPI();
    final newLocation = await api.locationFetch(coordinates);
    print('hourly ${newLocation.hourly?[0].temp}');
    ref.read(hourlyProvider.notifier).addList(name, newLocation.hourly!);
    ref.read(dailyProvider.notifier).addList(name, newLocation.daily!);
    addLocation(SharedPref(
      icon: newLocation.current!.weather!.first.icon,
      description: newLocation.current!.weather!.first.description,
      temp: newLocation.current!.temp.ceil().toString(),
      coordinates: coordinates,
      humidity: newLocation.daily!.first.humidity.toString(),
      main: newLocation.current!.weather!.first.main,
      moon_phase: newLocation.daily!.first.moon_phase.toString(),
      timezone: newLocation.timezone,
      dt: currentTime(newLocation.current!.dt.toInt(), newLocation.timezone.toString()),
      name: name,
      isDaytime: newLocation.current!.weather!.first.icon.contains('d') ? true : false,
    ));
  }

  void removeAt(index) {
    state.removeAt(index);
    state = state.toList();
    _saveLocationList();
  }

  static const _kLocationsKey = 'locationList';

  Future<void> _saveLocationList() async {
    final locationsJson = jsonEncode(state.map((location) => location.toJson()).toList());
    _prefs.setString(_kLocationsKey, locationsJson);
  }

  Future<void> _loadLocationList() async {
    _prefs = await SharedPreferences.getInstance();
    final locationsJson = _prefs.getString(_kLocationsKey);
    if (locationsJson != null) {
      final locationsData = jsonDecode(locationsJson) as List<dynamic>;
      final locationList = locationsData.map((data) => SharedPref.fromJson(data)).toList();
      state = locationList;
    }
  }
}

final locationStateNotifierProvider = StateNotifierProvider<LocationNotifier, List<SharedPref>>((ref) {
  return LocationNotifier([]);
});
