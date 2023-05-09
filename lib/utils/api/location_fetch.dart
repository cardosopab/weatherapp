import 'dart:convert' as convert;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

import '../../models/weather_api/weather_api.dart';

class LocationAPI {
  Future<WeatherAPI> locationFetch(coordinates) async {
    var openWeatherAPI = dotenv.env["openWeatherAPI"];
    var lang = "en";
    var url = "https://api.openweathermap.org/data/2.5/onecall?$coordinates&exclude=minutely&appid=$openWeatherAPI&lang=$lang";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonBody = convert.json.decode(response.body);

      WeatherAPI forecastResponse = WeatherAPI.fromJson(jsonBody);
      print('LocationAPI');
      return forecastResponse;
    } else {
      throw "fetchForecast Status !200: ${response.statusCode}";
    }
  }
}
