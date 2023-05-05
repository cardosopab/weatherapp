import 'dart:convert' as convert;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:weatherapp/models/sharedpreferences/sharedPref.dart';
import 'package:weatherapp/utils/services/location_list.dart';

import '../../models/openweather/model/models.dart';

class LocationAPI {
  Future<Model> locationFetch(coordinates) async {
    var openWeatherAPI = dotenv.env["openWeatherAPI"];
    // var units = tempCheck ? "imperial" : "metric";
    var units = "imperial";
    var lang = "en";
    var url = "https://api.openweathermap.org/data/2.5/onecall?$coordinates&exclude=minutely&appid=$openWeatherAPI&units=$units&lang=$lang";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonBody = convert.json.decode(response.body);

      Model forecastResponse = Model.fromJson(jsonBody);
      print('LocationAPI');
      return forecastResponse;
    } else {
      throw "fetchForecast Status !200: ${response.statusCode}";
    }
  }
}

final locationListInit = Provider<List<SharedPref>>((ref) {
  final locationList = ref.watch(locationStateNotifierProvider);

  for (final location in locationList) {
    final name = location.name;
    final coordinates = location.coordinates;
    print("locationListInit");
    print(name);
    print(location.temp);

    // ref.read(locationStateNotifierProvider.notifier).updateLocation(name, coordinates, ref);
  }
  return locationList;
});

final locationFutureProvider = FutureProvider<List<SharedPref>>((ref) async {
  return ref.watch(locationListInit);
});
