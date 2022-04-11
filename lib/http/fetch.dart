import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/nationalweather/periods/periods.dart';
import '../models/nationalweather/properties/properties.dart';
import '../models/nationalweather/weather/models.dart';

class HTTP {
  Future fetchHourlyForecast(url) async {
    final response = await http.get(Uri.parse(url));
    // final response =
    //     await http.get(Uri.parse('http://10.0.2.2:8000/forecast/hourly'));
    var jsonBody = convert.json.decode(response.body);
    Weather weatherHourly = Weather.fromJson(jsonBody);
    Properties propertiesHourly = Properties.fromJson(jsonBody);
    Periods periodsHourly = Periods.fromJson(jsonBody);
    // setState(() {
    //   weatherHourly;
    //   propertiesHourly;
    //   periodsHourly;
    //   print('After Hourly: ${weatherHourly.type}');
    // });
  }

  Future fetchForecast(url) async {
    final response = await http.get(Uri.parse(url));
    // final response = await http.get(Uri.parse('http://10.0.2.2:8000/forecast'));
    var jsonBody = convert.json.decode(response.body);

    Weather weather = Weather.fromJson(jsonBody);
    Properties properties = Properties.fromJson(jsonBody);
    Periods periods = Periods.fromJson(jsonBody);
    // setState(() {
    //   weather;
    //   properties;
    //   periods;
    // });
  }
}
