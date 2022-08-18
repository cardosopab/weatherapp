import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weatherapp/models/openweather/daily/daily.dart';
import 'package:weatherapp/models/openweather/hourly/hourly.dart';
import 'package:weatherapp/models/openweather/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';
import 'package:weatherapp/models/openCoding/result.dart';
import '../models/sharedpreferences/sharedPref.dart';
import 'dart:async';

String coordinates = '';
List<List<Hourly>> hourlyList = [];
List<List<Daily>> dailyList = [];
final hourlyListProvider = StateProvider((_) => hourlyList);
final dailyListProvider = StateProvider((_) => dailyList);
late SharedPreferences sharedPreferencesInstance;
final Future<SharedPreferences> _sharedPreferencesInstance = SharedPreferences.getInstance();

bool tempCheck = true;

List<SharedPref> sharedPreferencesList = <SharedPref>[];

var googleCloudPlatform = dotenv.env["googleCloudPlatform"].toString();

Future<List<OpenCoding>> fetchLocation(location) async {
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

    return locationResponse;
  } else {
    throw "fetchForecast Status !200: ${response.statusCode}";
  }
}

Future<Model> fetchForecast(coordinates) async {
  var openWeatherAPI = dotenv.env["openWeatherAPI"];
  var units = tempCheck ? "imperial" : "metric";
  var lang = "en";
  var url = "https://api.openweathermap.org/data/2.5/onecall?$coordinates&exclude=minutely&appid=$openWeatherAPI&units=$units&lang=$lang";

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var jsonBody = convert.json.decode(response.body);

    Model forecastResponse = Model.fromJson(jsonBody);
    return forecastResponse;
  } else {
    throw "fetchForecast Status !200: ${response.statusCode}";
  }
}

void savePreferences() {
  List<String> spList = sharedPreferencesList.map((item) => convert.jsonEncode(item.toJson())).toList();
  sharedPreferencesInstance.setStringList('location', spList);
}

Future loadPreferences() async {
  List<String>? spList = sharedPreferencesInstance.getStringList('location');
  sharedPreferencesList = spList?.map((e) => SharedPref.fromJson(convert.jsonDecode(e))).toList() ?? [];
}

void addLocationValue(SharedPref value) {
  sharedPreferencesList.add(value);
  savePreferences();
}

Future findLocation(coordinates, name) async {
  await fetchForecast(coordinates).then(
    (forecastResponse) {
      if (sharedPreferencesList.isEmpty) {
        hourlyList.add(forecastResponse.hourly);
        dailyList.add(forecastResponse.daily);
        addLocationValue(
          SharedPref(
            icon: forecastResponse.current.weather.first.icon,
            description: forecastResponse.current.weather.first.description,
            temp: forecastResponse.current.temp.ceil().toString(),
            coordinates: coordinates,
            humidity: forecastResponse.daily.first.humidity.toString(),
            main: forecastResponse.current.weather.first.main,
            moon_phase: forecastResponse.daily.first.moon_phase.toString(),
            timezone: forecastResponse.timezone,
            dt: currentTime(forecastResponse.current.dt.toInt(), forecastResponse.timezone.toString()),
            name: name,
            isDaytime: forecastResponse.current.weather.first.icon.contains('d') ? true : false,
            index: 0,
          ),
        );
      } else {
        bool inList = false;
        for (var i = 0; i < sharedPreferencesList.length; i++) {
          if (sharedPreferencesList[i].toJson().containsValue(name)) {
            inList = true;
          } else {
            inList = false;
          }
        }
        if (inList == false) {
          hourlyList.add(forecastResponse.hourly);
          dailyList.add(forecastResponse.daily);
          addLocationValue(
            SharedPref(
              icon: forecastResponse.current.weather.first.icon,
              description: forecastResponse.current.weather.first.description,
              temp: forecastResponse.current.temp.ceil().toString(),
              coordinates: coordinates,
              humidity: forecastResponse.daily.first.humidity.toString(),
              main: forecastResponse.current.weather.first.main,
              moon_phase: forecastResponse.daily.first.moon_phase.toString(),
              timezone: forecastResponse.timezone,
              dt: currentTime(forecastResponse.current.dt.toInt(), forecastResponse.timezone.toString()),
              name: name,
              isDaytime: forecastResponse.current.weather.first.icon.contains('d') ? true : false,
              index: sharedPreferencesList.length,
            ),
          );
        }
      }
    },
  );
}

Future initSharedPreferences() async {
  sharedPreferencesInstance = await _sharedPreferencesInstance;
  await loadPreferences();

  if (sharedPreferencesInstance.getBool("tempCheck") == null) {
    sharedPreferencesInstance.setBool("tempCheck", true);
  } else {
    tempCheck = sharedPreferencesInstance.getBool("tempCheck")!;
    for (var i = 0; i < sharedPreferencesList.length; i++) {
      await fetchForecast(
        sharedPreferencesList[i].coordinates,
      ).then(
        (forecastResponse) {
          sharedPreferencesList[i].icon = forecastResponse.current.weather.first.icon;
          sharedPreferencesList[i].main = forecastResponse.current.weather.first.main;
          sharedPreferencesList[i].temp = forecastResponse.current.temp.ceil().toString();
          sharedPreferencesList[i].timezone = forecastResponse.timezone;

          sharedPreferencesList[i].dt = currentTime(forecastResponse.current.dt.toInt(), sharedPreferencesList[i].timezone.toString());
          sharedPreferencesList[i].isDaytime = forecastResponse.current.weather.first.icon.contains('d') ? true : false;
          hourlyList.add(forecastResponse.hourly);
          dailyList.add(forecastResponse.daily);
        },
      );
    }
  }
}

String reverseStringUsingSplit(String input) {
  var chars = input.split('');
  return chars.reversed.join();
}

String hourlyTime(int dt, String timezone) {
  DateTime local = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
  final locationTime = TZDateTime.from(local, getLocation(timezone));
  String? result;
  print("locationTime: $locationTime");
  var reversed = reverseStringUsingSplit(locationTime.toString());
  if (reversed.contains("+")) {
    var index = reversed.indexOf("+");
    var string = reversed.substring(index + 1, reversed.length);
    result = reverseStringUsingSplit(string);
    // print(result);
  } else if (reversed.contains("-")) {
    var index = reversed.indexOf("-");
    var string = reversed.substring(index + 1, reversed.length);
    result = reverseStringUsingSplit(string);
  }
  print(result);
  var locationFormat = DateFormat("h a").format(DateTime.parse(result!));
  print(locationFormat);
  return locationFormat;
}

String currentTime(int dt, String timezone) {
  DateTime local = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
  final locationTime = TZDateTime.from(local, getLocation(timezone));
  String? result;
  var reversed = reverseStringUsingSplit(locationTime.toString());
  if (reversed.contains("+")) {
    var index = reversed.indexOf("+");
    var string = reversed.substring(index + 1, reversed.length);
    result = reverseStringUsingSplit(string);
  } else if (reversed.contains("-")) {
    var index = reversed.indexOf("-");
    var string = reversed.substring(index + 1, reversed.length);
    result = reverseStringUsingSplit(string);
  }
  var locationFormat = DateFormat("h:mm a").format(DateTime.parse(result!));
  return locationFormat;
}
