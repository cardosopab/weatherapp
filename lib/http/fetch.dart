import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:national_weather/models/nationalweather/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/geocoding/main/main.dart';
import '../models/sharedpreferences/sharedPref.dart';

String coordinates = '';
// String forecastUrl = '';
// String forecastHourlyUrl = '';
// List<List<Periods>> hourlyList = [];
List<List<Model>> forecastList = [];
// final hourlyListProvider = StateProvider((_) => hourlyList);
final forecastListProvider = StateProvider((_) => forecastList);

SharedPref location = SharedPref();
late SharedPreferences sharedPreferencesInstance;
List<SharedPref> sharedPreferencesList = <SharedPref>[];

Future<Main> getCoordinates(address) async {
  // Google Geocoding API KEY
  var GEOCODING = dotenv.env["GEOCODING"];
  var localgeocoding = dotenv.env["localgeocoding"];
  // final response = await http.get(Uri.parse(localgeocoding.toString()));
  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$GEOCODING'));
  if (response.statusCode == 200) {
    var jsonBody = await convert.json.decode(response.body);
    Main listResults = Main.fromJson(jsonBody);
    print("getCoordinates: ${listResults.results?.first.formatted_address}");
    return listResults;
  } else {
    throw "getCoordinates Status !200: ${response.statusCode}";
  }
}

Future<Model> fetchForecast(coordinates) async {
  print(coordinates);
  // openWeatherAPI
  var openWeatherAPI = dotenv.env["openWeatherAPI"];
  var localhost = dotenv.env["localhost"];
  // final response = await http.get(Uri.parse(localhost.toString()));
  final response = await http.get(Uri.parse(
      "https://api.openweathermap.org/data/2.5/onecall?$coordinates&exclude=minutely&appid=$openWeatherAPI"));
  if (response.statusCode == 200) {
    var jsonBody = convert.json.decode(response.body);

    Model forecastResponse = Model.fromJson(jsonBody);
    return forecastResponse;
  } else {
    throw "fetchForecast Status !200: ${response.statusCode}";
  }
}

void savePreferences() {
  List<String> spList = sharedPreferencesList
      .map((item) => convert.jsonEncode(item.toJson()))
      .toList();
  sharedPreferencesInstance.setStringList('location', spList);
}

Future loadPreferences() async {
  List<String>? spList = sharedPreferencesInstance.getStringList('location');
  sharedPreferencesList =
      spList?.map((e) => SharedPref.fromJson(convert.jsonDecode(e))).toList() ??
          [];
  // setState(() {});
}

void addLocationValue(SharedPref value) {
  sharedPreferencesList.add(value);
  savePreferences();
}

Future findLocation(address) async {
  await getCoordinates(address).then(
    (listResults) {
      var lat = listResults.results?.first.geometry?.location?.lat.toString();
      var lng = listResults.results?.first.geometry?.location?.lng.toString();
      var name = listResults.results?.first.formatted_address;
      location.name = name.toString().substring(
            0,
            name?.indexOf(','),
          );
      print("location.name: ${location.name}");
      return coordinates = 'lat=$lat&lon=$lng';
    },
  ).then(
    (coordinates) async {
      // print(forecastHourlyUrl);
      await fetchForecast(coordinates).then(
        (forecastResponse) {
          location.icon = forecastResponse.current.weather.first.icon;
          location.description =
              forecastResponse.current.weather.first.description;
          location.temp = forecastResponse.current.temp.toString();
          location.coordinates = coordinates;
          location.humidity = forecastResponse.daily.first.humidity.toString();
          location.main = forecastResponse.current.weather.first.main;
          location.moon_phase =
              forecastResponse.daily.first.moon_phase.toString();

          print("location.temp: ${location.temp}");
          print("location.coordinates: ${location.coordinates}");

          return location;
          // List<Model> list = [];
          // num length = weatherHourly.properties?.periods?.length as num;
          // for (var k = 0; k < length; k++) {
          //   list.add(weatherHourly.properties!.periods![k]);
          // }
          // hourlyList.add(list);
        },
      ).then(
        (location) {
          print(location.coordinates);
          // loadPreferences();
          if (sharedPreferencesList.isEmpty) {
            addLocationValue(
              SharedPref(
                icon: location.icon,
                name: location.name,
                description: location.description,
                temp: location.temp,
                coordinates: location.coordinates,
                // isDaytime: location.isDaytime,
                humidity: location.humidity,
                main: location.main,
                moon_phase: location.moon_phase,
              ),
            );
            return;
          }
          bool inList = false;
          for (var i = 0; i < sharedPreferencesList.length; i++) {
            if (sharedPreferencesList[i]
                .toJson()
                .containsValue(location.name)) {
              inList = true;
            } else {
              inList = false;
            }
          }
          if (inList == false) {
            addLocationValue(
              SharedPref(
                icon: location.icon,
                name: location.name,
                description: location.description,
                temp: location.temp,
                coordinates: location.coordinates,
                // isDaytime: location.isDaytime,
                humidity: location.humidity,
                main: location.main,
                moon_phase: location.moon_phase,
              ),
            );
          }
          // for (var i = 0; i < sharedPreferencesList.length; i++) {
          //   fetchForecast(sharedPreferencesList[i].coordinates).then(
          //     (forecastResponse) {
          //       List<Model> list = [];
          //       num length = forecastResponse.properties?.periods?.length as num;
          //       for (var j = 0; j < length; j++) {
          //         list.add(forecastResponseproperties!.periods![j]);
          //       }
          //       forecastList.add(list);
          //     },
          //   );
          // }
        },
      );
    },
  );
}

Future initSharedPreferences() async {
  sharedPreferencesInstance = await SharedPreferences.getInstance();
  await loadPreferences();
  // for (var i = 0; i < sharedPreferencesList.length; i++) {
  //   await fetchForecast(
  //     sharedPreferencesList[i].forecastHourlyUrl.toString(),
  //   ).then(
  //     (forecastResponse) {
  //       sharedPreferencesList[i].icon = forecastResponse.current.weather.icon;
  //       sharedPreferencesList[i].shortForecast =
  //           forecastResponse.current.weather.main;
  //       sharedPreferencesList[i].temperature =
  //           forecastResponse.current.temp.toString();
  //     },
  //   );
  // }
}
