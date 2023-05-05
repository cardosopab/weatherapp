import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../models/openCoding/result.dart';

class GeoCodingAPI {
  Future<List<OpenCoding>> geofetch(location) async {
    List<OpenCoding> locationResponse = [];
    var openWeatherAPI = dotenv.env["openWeatherAPI"];
    var url = "https://api.openweathermap.org/geo/1.0/direct?q=$location&limit=5&appid=$openWeatherAPI";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonBody = await convert.json.decode(response.body);
      for (var data in jsonBody) {
        OpenCoding obj = OpenCoding(
          name: data['name'],
          lat: data['lat'],
          lon: data['lon'],
          country: data['country'],
          state: data['state'],
        );
        locationResponse.add(obj);
      }

      print('GeoCodeAPI');
      return locationResponse;
    } else {
      throw "fetchForecast Status !200: ${response.statusCode}";
    }
  }
}
