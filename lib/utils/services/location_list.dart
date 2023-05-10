import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/utils/services/daily_list.dart';
import 'package:weatherapp/utils/services/hourly_list.dart';

import '../../models/location/location.dart';
import '../../models/weather_api/weather_api.dart';
import '../functions/current_time.dart';
import '../api/location_fetch.dart';

class LocationNotifier extends StateNotifier<List<Location>> {
  late final SharedPreferences _prefs;
  final StateNotifierProviderRef<LocationNotifier, List<Location>> _ref;
  LocationNotifier(List<Location> locationList, this._ref) : super(locationList) {
    _loadLocationList();
  }

  void addLocation(Location location) {
    state = [...state, location];
    _saveLocationList();
  }

  Future<void> updateLocation(ref) async {
    final api = LocationAPI();
    List<Location> locationList = state;
    for (int i = 0; i < locationList.length; i++) {
      WeatherAPI newLocation = await api.locationFetch(locationList[i].coordinates);
      ref.read(hourlyProvider.notifier).addList(locationList[i].name, newLocation.hourly);
      ref.read(dailyProvider.notifier).addList(locationList[i].name, newLocation.daily);
      locationList[i] = Location(
        icon: newLocation.current.weather.first.icon,
        description: newLocation.current.weather.first.description,
        temp: newLocation.current.temp,
        coordinates: locationList[i].coordinates,
        humidity: newLocation.daily.first.humidity.toString(),
        main: newLocation.current.weather.first.main,
        moon_phase: newLocation.daily.first.moonPhase.toString(),
        timezone: newLocation.timezone,
        dt: currentTime(newLocation.current.dt!.toInt(), newLocation.timezone.toString()),
        name: locationList[i].name,
        isDaytime: newLocation.current.weather.first.icon.contains('d') ? true : false,
      );
    }
    state = locationList.toList();
  }

  Future<void> fetchLocation(name, coordinates, WidgetRef ref) async {
    final api = LocationAPI();
    final newLocation = await api.locationFetch(coordinates);
    print('hourly ${newLocation.hourly[0].temp}');
    ref.read(hourlyProvider.notifier).addList(name, newLocation.hourly);
    ref.read(dailyProvider.notifier).addList(name, newLocation.daily);
    addLocation(Location(
      icon: newLocation.current.weather.first.icon,
      description: newLocation.current.weather.first.description,
      temp: newLocation.current.temp,
      coordinates: coordinates,
      humidity: newLocation.daily.first.humidity.toString(),
      main: newLocation.current.weather.first.main,
      moon_phase: newLocation.daily.first.moonPhase.toString(),
      timezone: newLocation.timezone,
      dt: currentTime(newLocation.current.dt!.toInt(), newLocation.timezone.toString()),
      name: name,
      isDaytime: newLocation.current.weather.first.icon.contains('d') ? true : false,
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
    final api = LocationAPI();
    final locationsJson = _prefs.getString(_kLocationsKey);

    if (locationsJson != null) {
      final locationsData = jsonDecode(locationsJson) as List<dynamic>;
      final locationList = <Location>[];
      for (final data in locationsData) {
        Location location = Location.fromJson(data);
        final newLocation = await api.locationFetch(location.coordinates);
        print('hourly ${newLocation.hourly[0].temp}');
        _ref.read(hourlyProvider.notifier).addList(location.name!, newLocation.hourly);
        _ref.read(dailyProvider.notifier).addList(location.name!, newLocation.daily);
        location = Location(
          icon: newLocation.current.weather.first.icon,
          description: newLocation.current.weather.first.description,
          temp: newLocation.current.temp,
          coordinates: location.coordinates,
          humidity: newLocation.daily.first.humidity.toString(),
          main: newLocation.current.weather.first.main,
          moon_phase: newLocation.daily.first.moonPhase.toString(),
          timezone: newLocation.timezone,
          dt: currentTime(newLocation.current.dt!.toInt(), newLocation.timezone.toString()),
          name: location.name,
          isDaytime: newLocation.current.weather.first.icon.contains('d') ? true : false,
        );
        locationList.add(location);
      }
      state = locationList;
    }
  }
}

final locationStateNotifierProvider = StateNotifierProvider<LocationNotifier, List<Location>>((ref) {
  return LocationNotifier([], ref);
});

final locationFutureProvider = FutureProvider<List<Location>>((ref) async {
  print('locationFutureProvider');
  final locationList = ref.watch(locationStateNotifierProvider);
  return locationList;
});
