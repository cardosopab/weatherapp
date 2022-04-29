import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/nationalweather/weather/models.dart';

Future<Weather> fetchForecast(url) async {
  final response = await http.get(Uri.parse(url));
  var jsonBody = convert.json.decode(response.body);

  Weather weather = Weather.fromJson(jsonBody);
  return weather;
}

Future<Weather> fetchHourlyForecast(url) async {
  final response = await http.get(Uri.parse(url));
  var jsonBody = convert.json.decode(response.body);

  Weather weatherHourly = Weather.fromJson(jsonBody);
  return weatherHourly;
}
