import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:national_weather/pages/homepage.dart';
import '../models/geocoding/main/main.dart';
import '../models/nationalweather/weather/models.dart';
import '../models/office/office.dart';

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

Future<Main> getCoordinates(address) async {
  // Google Geocoding API KEY
  var GEOCODING = dotenv.env["GEOCODING"];
  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$GEOCODING'));
  var jsonBody = await convert.json.decode(response.body);
  Main listResults = Main.fromJson(jsonBody);
  print("getCoordinates: ${listResults.results?.first.formatted_address}");
  return listResults;
}

Future<Office> getOffice(coordinates) async {
  final response =
      await http.get(Uri.parse('https://api.weather.gov/points/$coordinates'));
  var jsonBody = await convert.json.decode(response.body);
  Office office = Office.fromJson(jsonBody);
  return office;
}

// Future findLocation(address) {
//   return getCoordinates(address).then((listResults) {
//     var name=listResults.results?.first.formatted_address;
//   var lat = listResults.results?.first.geometry?.location?.lat.toString();
//   var lng = listResults.results?.first.geometry?.location?.lng.toString();
//   coordinates = '$lat,$lng';
//   }).then(
//     (coordinates) => getOffice(coordinates).then(
//       (office) {
//         forecastUrl = office.properties?.forecast.toString() ?? 'null';
//         forecastHourlyUrl =
//             office.properties?.forecastHourly.toString() ?? 'null';
//       },
//     ),
//   );
// }
