import 'dart:convert' as convert;
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:national_weather/Widgets/glass.dart';
import 'package:national_weather/models/geocoding/main/main.dart';
import 'package:national_weather/models/office/office.dart';
import 'package:national_weather/models/sharedpreferences/sharedPref.dart';
import 'package:national_weather/pages/weatherpage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../http/fetch.dart';
import '../models/nationalweather/periods/periods.dart';
import '../models/nationalweather/weather/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

String coordinates = '';
String forecastUrl = '';
String forecastHourlyUrl = '';
List<List<Periods>> hourlyList = [];
List<List<Periods>> forecastList = [];
final hourlyListProvider = StateProvider((_) => hourlyList);
final forecastListProvider = StateProvider((_) => forecastList);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late SharedPreferences sharedPreferencesInstance;
  List<SharedPref> sharedPreferencesList = <SharedPref>[];
  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future initSharedPreferences() async {
    sharedPreferencesInstance = await SharedPreferences.getInstance();
    await loadPreferences();
    for (var i = 0; i < sharedPreferencesList.length; i++) {
      await fetchHourlyForecast(
        sharedPreferencesList[i].forecastHourlyUrl.toString(),
      ).then(
        (weatherHourly) {
          setState(() {
            weatherHourly;
          });
          List<Periods> list = [];
          num length = weatherHourly.properties?.periods?.length as num;
          for (var k = 0; k < length; k++) {
            list.add(weatherHourly.properties!.periods![k]);
          }
          hourlyList.add(list);
          sharedPreferencesList[i].icon =
              weatherHourly.properties?.periods?.first.icon;
          sharedPreferencesList[i].shortForecast =
              weatherHourly.properties?.periods?.first.shortForecast;
          sharedPreferencesList[i].temperature =
              weatherHourly.properties?.periods?.first.temperature.toString();
          sharedPreferencesList[i].isDaytime =
              weatherHourly.properties?.periods?.first.isDaytime;
          sharedPreferencesList[i].index = i;
        },
      );
      await fetchForecast(sharedPreferencesList[i].forecastUrl.toString()).then(
        (weather) {
          setState(() {
            weather;
          });

          List<Periods> list = [];
          num length = weather.properties?.periods?.length as num;
          for (var j = 0; j < length; j++) {
            list.add(weather.properties!.periods![j]);
          }
          forecastList.add(list);
        },
      );
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
    sharedPreferencesList = spList
            ?.map((e) => SharedPref.fromJson(convert.jsonDecode(e)))
            .toList() ??
        [];
    setState(() {});
  }

  void addLocationValue(SharedPref value) {
    sharedPreferencesList.add(value);
    savePreferences();
  }

  final TextEditingController _addressController = TextEditingController();
  Weather weatherHourly = Weather();
  Weather weather = Weather();
  Main listResults = Main();
  Office office = Office();
  SharedPref location = SharedPref();

  Future<String> getCoordinates(address) async {
    var GEOCODING = dotenv.env["GEOCODING"];
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$GEOCODING'));
    var jsonBody = await convert.json.decode(response.body);
    listResults = Main.fromJson(jsonBody);
    var lat = listResults.results?.first.geometry?.location?.lat.toString();
    var lng = listResults.results?.first.geometry?.location?.lng.toString();
    setState(() {
      listResults;
      coordinates = '$lat,$lng';
    });
    return coordinates;
  }

  Future getOffice(coordinates) async {
    // print('get Office Coordinates $coordinates');
    final response = await http
        .get(Uri.parse('https://api.weather.gov/points/$coordinates'));
    // final response = await http.get(Uri.parse('http://10.0.2.2:8000/points'));
    var jsonBody = await convert.json.decode(response.body);
    // log(jsonBody.toString());
    office = Office.fromJson(jsonBody);
    forecastUrl = office.properties?.forecast.toString() ?? 'null';
    forecastHourlyUrl = office.properties?.forecastHourly.toString() ?? 'null';
    // print('getOffice ForecastHourlyUrl: $forecastHourlyUrl');
    // print('getOffice ForecastUrl: $forecastUrl');

    setState(() {
      forecastUrl;
      forecastHourlyUrl;
      // print('SetState: $forecastUrl');
    });
    // return {forecastHourlyUrl, forecastUrl};
    // return forecastHourlyUrl;
  }

  Future findLocation(address) {
    return getCoordinates(address)
        .then((coordinates) => getOffice(coordinates));
  }

  void clear() {
    _addressController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  hintText: 'U.S.A. forecast by "City, St", or ZIP code',
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
                controller: _addressController,
                onSubmitted: (_addressController) {
                  if (_addressController.isNotEmpty) {
                    clear();
                    findLocation(_addressController).then(
                      (_) => fetchHourlyForecast(forecastHourlyUrl).then(
                        (weatherHourly) {
                          setState(() {
                            weatherHourly;
                          });
                          var name =
                              listResults.results?.first.formatted_address;

                          location.short_name = name.toString().substring(
                                0,
                                name?.indexOf(','),
                              );
                          location.icon =
                              weatherHourly.properties?.periods?.first.icon;
                          location.shortForecast = weatherHourly
                              .properties?.periods?.first.shortForecast;
                          location.temperature = weatherHourly
                              .properties?.periods?.first.temperature
                              .toString();
                          location.forecastHourlyUrl = forecastHourlyUrl;
                          location.forecastUrl = forecastUrl;
                          location.isDaytime =
                              weather.properties?.periods?.first.isDaytime;
                        },
                      ).then(
                        (_) {
                          loadPreferences();
                          if (sharedPreferencesList.isEmpty) {
                            addLocationValue(
                              SharedPref(
                                icon: location.icon,
                                short_name: location.short_name,
                                shortForecast: location.shortForecast,
                                temperature: location.temperature,
                                forecastHourlyUrl: location.forecastHourlyUrl,
                                forecastUrl: location.forecastUrl,
                                isDaytime: location.isDaytime,
                              ),
                            );
                            return;
                          }
                          bool inList = false;
                          for (var i = 0;
                              i < sharedPreferencesList.length;
                              i++) {
                            if (sharedPreferencesList[i]
                                .toJson()
                                .containsValue(location.short_name)) {
                              inList = true;
                            } else {
                              inList = false;
                            }
                          }
                          if (inList == false) {
                            addLocationValue(
                              SharedPref(
                                icon: location.icon,
                                short_name: location.short_name,
                                shortForecast: location.shortForecast,
                                temperature: location.temperature,
                                forecastHourlyUrl: location.forecastHourlyUrl,
                                forecastUrl: location.forecastUrl,
                                isDaytime: location.isDaytime,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sharedPreferencesList.length,
              itemBuilder: (context, index) {
                final sharedPref = sharedPreferencesList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  WeatherPage(sharedPref: sharedPref))));
                    }),
                    child: Slidable(
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              setState(() {
                                sharedPreferencesList.removeAt(index);
                                savePreferences();
                                loadPreferences();
                              });
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              sharedPref.icon.toString(),
                            ),
                          ),
                        ),
                        child: GlassMorphism(
                          isDaytime: weatherHourly
                              .properties?.periods?.first.isDaytime,
                          blur: 2,
                          opacity: .2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          sharedPref.short_name.toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(sharedPref.shortForecast
                                            .toString()),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          '${sharedPref.temperature}°',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              sharedPref.icon.toString()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(text: 'Learn more about the '),
                          TextSpan(
                            text: 'National Weather Service',
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                var url = 'https://www.weather.gov/';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Cannot load Url';
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(text: 'And the '),
                          TextSpan(
                            text:
                                'National Oceanic & Atmospheric Administraion',
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                var url = 'https://www.noaa.gov/';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Cannot load Url';
                                }
                              },
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage(
                              'assets/images/180px-US-NationalWeatherService-Logo.svg.png'),
                        ),
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage('assets/images/noaa.png'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void doNothing(BuildContext context) {}
