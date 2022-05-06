import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:national_weather/Widgets/glass.dart';
import 'package:national_weather/models/geocoding/main/main.dart';
import 'package:national_weather/models/sharedpreferences/sharedPref.dart';
import 'package:url_launcher/url_launcher.dart';
import '../http/fetch.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  final TextEditingController _addressController = TextEditingController();
  // Weather weatherHourly = Weather();
  // Weather weather = Weather();
  Main listResults = Main();
  // Office office = Office();
  // SharedPref location = SharedPref();

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
            ElevatedButton(
                onPressed: () {
                  sharedPreferencesList.clear();
                  savePreferences();
                  loadPreferences();
                },
                child: const Text('Delete List')),
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
                    findLocation(_addressController);
                    setState(() {});
                  }
                },
              ),
            ),
            ListView.builder(
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sharedPreferencesList.length,
              itemBuilder: (context, index) {
                final sharedPref = sharedPreferencesList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (() {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: ((context) =>
                      //         WeatherPage(sharedPref: sharedPref)),
                      //   ),
                      // );
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
                          isDaytime: true,
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
                                          sharedPref.name.toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(sharedPref.main.toString()),
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
                                          '${sharedPref.temp}°',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          '${sharedPref.humidity}%',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.all(4.0),
                                      //   child: CircleAvatar(
                                      //     backgroundImage: NetworkImage(
                                      //         sharedPref.icon.toString()),
                                      //   ),
                                      // ),
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
                          const TextSpan(
                            text: 'Learn more about the ',
                            style: TextStyle(color: Colors.white),
                          ),
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
                          const TextSpan(
                            text: 'And the ',
                            style: TextStyle(color: Colors.white),
                          ),
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
