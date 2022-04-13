import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:national_weather/Widgets/glass.dart';
import 'package:national_weather/Widgets/isDaytime.dart';
import 'package:national_weather/models/geocoding/main/main.dart';
import 'package:national_weather/models/office/office.dart';
import 'package:national_weather/models/sharedpreferences/sharedPref.dart';
import 'package:national_weather/pages/weatherpage.dart';
import '../models/nationalweather/periods/periods.dart';
import '../models/nationalweather/properties/properties.dart';
import '../models/nationalweather/weather/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

final coordinatesProvider = StateProvider((_) => coordinates);
final forecastProvider = StateProvider((_) => forecastUrl);
final forecastHourlyProvider = StateProvider((_) => forecastHourlyUrl);
String coordinates = '';
String forecastUrl = '';
String forecastHourlyUrl = '';

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
    initSharedPreferences().then((_) async {
      // return null;
      // final value = ref.read(isDaytimeProvider);
      // print(value);
      ref.read(isDaytimeProvider.notifier).state =
          sharedPreferencesList.first.isDaytime!;
      // sharedPreferencesList.first.isDaytime;
      print(sharedPreferencesList.first.isDaytime);
      // sharedPreferencesList.first.isDaytime = await ref.read(isDaytimeProvider);
      print(isDaytimeProvider);
    });
  }

  Future initSharedPreferences() async {
    sharedPreferencesInstance = await SharedPreferences.getInstance();
    await loadPreferences();
    for (var i = 0; i < sharedPreferencesList.length; i++) {
      await fetchHourlyForecast(
              sharedPreferencesList[i].forecastHourlyUrl.toString())
          .then((_) {
        // var name = listResults.results?.first.formatted_address;

        // location.short_name = name.toString().substring(
        //       0,
        //       name?.indexOf(','),
        //     );
        sharedPreferencesList[i].icon =
            weatherHourly.properties?.periods?.first.icon;
        sharedPreferencesList[i].shortForecast =
            weatherHourly.properties?.periods?.first.shortForecast;
        sharedPreferencesList[i].temperature =
            weatherHourly.properties?.periods?.first.temperature.toString();
        sharedPreferencesList[i].isDaytime =
            weatherHourly.properties?.periods?.first.isDaytime;
        // print(weatherHourly.properties?.periods?.first.isDaytime);
        // location.forecastHourlyUrl = forecastHourlyUrl;
        // location.forecastUrl = forecastUrl;
        // print('ForecastUrl: $forecastUrl');
        // print('Location ForecastUrl:${location.forecastUrl}');
      });
      // print(
      //     'initSharedPreferences sharedPref:${sharedPreferencesList[i].toJson().toString()}');
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

  // void doNothing(BuildContext context) {}
  final TextEditingController _addressController = TextEditingController();
  Weather weatherHourly = Weather();
  Properties propertiesHourly = Properties();
  Periods periodsHourly = Periods();
  Weather weather = Weather();
  Properties properties = Properties();
  Periods periods = Periods();
  Main listResults = Main();
  Office office = Office();
  // Locations location = Locations();
  SharedPref location = SharedPref();

  Future<String> getCoordinates(address) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyBqaeoTwpKK-ORtYwrqwbnkqAgxUInOzJc'));
    // 'http://192.168.56.1:8000/geocoding'));
    // 'http://10.0.2.2:8000/geocoding'));
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
    print('get Office Coordinates $coordinates');
    final response = await http
        .get(Uri.parse('https://api.weather.gov/points/$coordinates'));
    // final response = await http.get(Uri.parse('http://10.0.2.2:8000/points'));
    var jsonBody = await convert.json.decode(response.body);
    // log(jsonBody.toString());
    office = Office.fromJson(jsonBody);
    forecastUrl = office.properties?.forecast.toString() ?? 'null';
    forecastHourlyUrl = office.properties?.forecastHourly.toString() ?? 'null';
    print('getOffice ForecastHourlyUrl: $forecastHourlyUrl');
    print('getOffice ForecastUrl: $forecastUrl');

    setState(() {
      forecastUrl;
      forecastHourlyUrl;
      print('SetState: $forecastUrl');
    });
    // return {forecastHourlyUrl, forecastUrl};
    // return forecastHourlyUrl;
  }

  Future fetchHourlyForecast(url) async {
    final response = await http.get(Uri.parse(url));
    // final response =
    // await http.get(Uri.parse('http://10.0.2.2:8000/forecast/hourly'));
    var jsonBody = await convert.json.decode(response.body);
    weatherHourly = Weather.fromJson(jsonBody);
    propertiesHourly = Properties.fromJson(jsonBody);
    periodsHourly = Periods.fromJson(jsonBody);
    setState(() {
      weatherHourly;
      propertiesHourly;
      periodsHourly;
    });
    // return weatherHourly;
  }

  Future fetchForecast(url) async {
    final response = await http.get(Uri.parse(url));
    // final response = await http.get(Uri.parse('http://10.0.2.2:8000/forecast'));
    var jsonBody = convert.json.decode(response.body);

    weather = Weather.fromJson(jsonBody);
    properties = Properties.fromJson(jsonBody);
    periods = Periods.fromJson(jsonBody);
    setState(() {
      weather;
      properties;
      periods;
    });
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
                // textAlign: TextAlign.center,
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
                        (_) {
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
                          print('ForecastUrl: $forecastUrl');
                          print('Location ForecastUrl:${location.forecastUrl}');
                        },
                      ).then(
                        (_) {
                          print('loop');
                          loadPreferences();
                          print('SharedList: $sharedPreferencesList');
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
                            print(
                                'List: ${sharedPreferencesList[i].toJson().toString()}');
                            print(location.short_name);
                            if (sharedPreferencesList[i]
                                .toJson()
                                .containsValue(location.short_name)) {
                              inList = true;
                            } else {
                              inList = false;
                            }
                          }
                          print(inList);
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
                    setState(() {});
                    print('onSubmitted coordinates: $coordinates');
                    print('onSubmitted forecastUrl: $forecastUrl');
                    print('onSubmitted forecastHourlyUrl: $forecastHourlyUrl');
                    //
                  }
                },
              ),
            ),
            // TextButton(
            //   onPressed: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: ((context) => WeatherPage(
            //                 // title: sharedPreferencesList.first.short_name.toString()
            //                 title: sharedPreferencesList.first.short_name
            //                     .toString(),
            //               )))),
            //   child: const Text('WeatherPage'),
            // ),
            // TextButton(
            //     onPressed: () {
            //       setState(() {
            //         sharedPreferencesList = [];
            //         savePreferences();
            //         loadPreferences();
            //         print(sharedPreferencesList);
            //       });
            //     },
            //     child: const Text('Erase List')),
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
                        // dismissible: DismissiblePane(onDismissed: () {}),
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
                                      // const Text(''),
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
          ],
        ),
      ),
    );
  }
}

void doNothing(BuildContext context) {}
