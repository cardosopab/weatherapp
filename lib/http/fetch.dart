import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:national_weather/models/nationalweather/daily/daily.dart';
import 'package:national_weather/models/nationalweather/hourly/hourly.dart';
import 'package:national_weather/models/nationalweather/model/models.dart';
import 'package:national_weather/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';
import '../main.dart';
import '../models/geocoding/main/main.dart';
import '../models/sharedpreferences/sharedPref.dart';
import 'dart:async';

String coordinates = '';
// String forecastUrl = '';
// String forecastHourlyUrl = '';
List<List<Hourly>> hourlyList = [];
List<List<Daily>> dailyList = [];
final hourlyListProvider = StateProvider((_) => hourlyList);
final dailyListProvider = StateProvider((_) => dailyList);
// bool unitPref = true;
var tempCheck;

SharedPref location = SharedPref();
late SharedPreferences sharedPreferencesInstance;
List<SharedPref> sharedPreferencesList = <SharedPref>[];

late GooglePlace googlePlace;
List<AutocompletePrediction> predictions = [];
DetailsResult? locationResult;
// Timer? _debounce;

var googleCloudPlatform = dotenv.env["googleCloudPlatform"].toString();

// @override
// void initState() {
//   super.initState();
//   googlePlace = GooglePlace(googleCloudPlatform);
//   initSharedPreferences().then((_) => setState(() {}));
// }

// void autoCompleteSearch(String value) async {
//   var result = await googlePlace.autocomplete.get(value);
//   if (result != null && result.predictions != null && mounted) {
//     print(result.predictions!.first.description);
//     setState(() {
//       predictions = result.predictions!;
//     });
//   }
// }

void dummyFetch() {
  // unitPref = !unitPref;
  // sharedPreferencesInstance.setBool('unitPref', unitPref);
  final bool? instancePref = sharedPreferencesInstance.getBool('unitPref');
  print("instancePref: $instancePref");
}

Future<Main> getCoordinates(address) async {
  // Google Geocoding API KEY & googleCloudPlatform credentials

  var googleCloudPlatform = dotenv.env["googleCloudPlatform"];
  var url =
      'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$googleCloudPlatform';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var jsonBody = await convert.json.decode(response.body);
    Main listResults = Main.fromJson(jsonBody);
    // print("getCoordinates: ${listResults.results?.first.formatted_address}");
    return listResults;
  } else {
    throw "getCoordinates Status !200: ${response.statusCode}";
  }
}

Future<Model> fetchForecast(coordinates) async {
  // print(coordinates);
  // openWeatherAPI

  var openWeatherAPI = dotenv.env["openWeatherAPI"];
  final bool? instancePref = sharedPreferencesInstance.getBool('unitPref');

  print("instancePref: $instancePref");
  // var bool = unitsBool;
  var units = instancePref! ? "imperial" : "metric";
  // print("unitsBool: $unitsBool");
  // print("units: $units");
  var lang = "en";
  var url =
      "https://api.openweathermap.org/data/2.5/onecall?$coordinates&exclude=minutely&appid=$openWeatherAPI&units=$units&lang=$lang";

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

Future findLocation(coordinates, name) async {
  location.name = name;
  if (sharedPreferencesInstance.getBool('unitPref') == null) {
    sharedPreferencesInstance.setBool('unitPref', true);
  }
  await fetchForecast(coordinates).then(
    (forecastResponse) {
      //     location.icon = forecastResponse.current.weather.first.icon;
      //     location.description = forecastResponse.current.weather.first.description;
      //     location.temp = forecastResponse.current.temp.ceil().toString();
      //     location.coordinates = coordinates;
      //     location.humidity = forecastResponse.daily.first.humidity.toString();
      //     location.main = forecastResponse.current.weather.first.main;
      //     location.moon_phase = forecastResponse.daily.first.moon_phase.toString();
      //     location.timezone = forecastResponse.timezone;
      //     location.dt = currentTime(forecastResponse.current.dt.toInt(),
      //         forecastResponse.timezone.toString());
      //     location.isDaytime = false;
      //     if (forecastResponse.current.weather.first.icon.contains('d')) {
      //       location.isDaytime = true;
      //     }
      //     // print("location.isDaytime: ${location.isDaytime}");
      if (sharedPreferencesList.isEmpty) {
        print("before hourlyList.length: ${hourlyList.length}");
        print("before dailyList.length: ${dailyList.length}");
        for (var i = 0; i < forecastResponse.hourly.length; i++) {
          hourlyList.add(forecastResponse.hourly);
        }
        for (var i = 0; i < forecastResponse.daily.length; i++) {
          dailyList.add(forecastResponse.daily);
        }
        print("hourlyList.length: ${hourlyList.length}");
        print("dailyList.length: ${dailyList.length}");
        //     return location;
        //   },
        // ).then(
        //   (location) {

        // print(location.coordinates);
        // loadPreferences();
        var dayTime = forecastResponse.current.weather.first.icon.contains('d')
            ? true
            : false;
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
            dt: currentTime(forecastResponse.current.dt.toInt(),
                forecastResponse.timezone.toString()),
            name: name,
            isDaytime: dayTime,
            index: 0,
          ),
        );
        print(sharedPreferencesList.first.toJson());
        // print(
        //     "sharedPreferencesList.first.index: ${sharedPreferencesList.first.index}");
        // return;
      } else {
        bool inList = false;
        for (var i = 0; i < sharedPreferencesList.length; i++) {
          if (sharedPreferencesList[i].toJson().containsValue(location.name)) {
            inList = true;
          } else {
            inList = false;
          }
        }
        if (inList == false) {
          print("before hourlyList.length: ${hourlyList.length}");
          print("before dailyList.length: ${dailyList.length}");
          for (var i = 0; i < forecastResponse.hourly.length; i++) {
            hourlyList.add(forecastResponse.hourly);
          }
          for (var i = 0; i < forecastResponse.daily.length; i++) {
            dailyList.add(forecastResponse.daily);
          }
          print("hourlyList.length: ${hourlyList.length}");
          print("dailyList.length: ${dailyList.length}");
          var dayTime =
              forecastResponse.current.weather.first.icon.contains('d')
                  ? true
                  : false;
          print(
              "sharedPreferencesList.last.index: ${sharedPreferencesList.last.index}");
          print(
              "sharedPreferencesList.length: ${sharedPreferencesList.length}");
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
              dt: currentTime(forecastResponse.current.dt.toInt(),
                  forecastResponse.timezone.toString()),
              name: name,
              isDaytime: dayTime,
              // icon: location.icon,
              // name: location.name,
              // description: location.description,
              // temp: location.temp,
              // coordinates: location.coordinates,
              // isDaytime: location.isDaytime,
              // humidity: location.humidity,
              // main: location.main,
              // moon_phase: location.moon_phase,
              index: sharedPreferencesList.length,
              // timezone: location.timezone,
              // dt: location.dt,
            ),
          );
          print(
              "sharedPreferencesList.length: ${sharedPreferencesList.length}");
          print(
              "sharedPreferencesList.last.index: ${sharedPreferencesList.last.index}");
          print(
              "sharedPreferencesList.last.toJson(): ${sharedPreferencesList.last.toJson()}");
        }
      }
      // final sharedPrefIndex = sharedPreferencesList.last.index;
      // print("sharedPrefIndex: $sharedPrefIndex");
      // return sharedPrefIndex;
    },
  );
}

Future initSharedPreferences() async {
  sharedPreferencesInstance = await SharedPreferences.getInstance();
  await loadPreferences();
  if (sharedPreferencesList.isNotEmpty) {
    tempCheck = sharedPreferencesInstance.getBool('unitPref');
    hourlyList.clear();
    dailyList.clear();
    for (var i = 0; i < sharedPreferencesList.length; i++) {
      await fetchForecast(
        sharedPreferencesList[i].coordinates,
      ).then(
        (forecastResponse) {
          sharedPreferencesList[i].icon =
              forecastResponse.current.weather.first.icon;
          sharedPreferencesList[i].main =
              forecastResponse.current.weather.first.main;
          sharedPreferencesList[i].temp =
              forecastResponse.current.temp.ceil().toString();
          sharedPreferencesList[i].timezone = forecastResponse.timezone;
          print(sharedPreferencesList[i].timezone);

          sharedPreferencesList[i].dt = currentTime(
              forecastResponse.current.dt.toInt(),
              sharedPreferencesList[i].timezone.toString());

          hourlyList.add(forecastResponse.hourly);
          dailyList.add(forecastResponse.daily);

          sharedPreferencesList[i].isDaytime = false;
          if (forecastResponse.current.weather.first.icon.contains('d')) {
            sharedPreferencesList[i].isDaytime = true;
          }
          print("isDaytime: ${sharedPreferencesList[i].isDaytime}");
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
  // print("local: $local");
  final locationTime = TZDateTime.from(local, getLocation(timezone));
  // print("locationTime: $locationTime");
  var result;
  var reversed = reverseStringUsingSplit(locationTime.toString());
  if (reversed.contains("+")) {
    var index = reversed.indexOf("+");
    // print("index: $index");
    var string = reversed.substring(index + 1, reversed.length);
    result = reverseStringUsingSplit(string);
    // print("result: $result");
  } else if (reversed.contains("-")) {
    var index = reversed.indexOf("-");
    // print("index: $index");
    var string = reversed.substring(index + 1, reversed.length);
    result = reverseStringUsingSplit(string);
    // print("result: $result");
  }
  var locationFormat = DateFormat("h a").format(DateTime.parse(result));
  return locationFormat;
}

String currentTime(int dt, String timezone) {
  DateTime local = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
  // print("local: $local");
  final locationTime = TZDateTime.from(local, getLocation(timezone));
  // print("locationTime: $locationTime");
  var result;
  var reversed = reverseStringUsingSplit(locationTime.toString());
  if (reversed.contains("+")) {
    var index = reversed.indexOf("+");
    // print("index: $index");
    var string = reversed.substring(index + 1, reversed.length);
    result = reverseStringUsingSplit(string);
    // print("result: $result");
  } else if (reversed.contains("-")) {
    var index = reversed.indexOf("-");
    // print("index: $index");
    var string = reversed.substring(index + 1, reversed.length);
    result = reverseStringUsingSplit(string);
    // print("result: $result");
  }
  var locationFormat = DateFormat("h:mm a").format(DateTime.parse(result));
  return locationFormat;
}
