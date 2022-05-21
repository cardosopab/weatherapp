import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:national_weather/Widgets/glass.dart';
import 'package:national_weather/models/geocoding/main/main.dart';
import 'package:national_weather/my_icons_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../http/fetch.dart';
import 'weatherpage.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FlutterGooglePlacesSdk googlePlaces;
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;

  // var googleCloudPlatform = dotenv.env["googleCloudPlatform"].toString();

  @override
  void initState() {
    super.initState();
    googlePlaces = FlutterGooglePlacesSdk(googleCloudPlatform);
    initSharedPreferences().then((_) => setState(() {}));
    print("sharedPreferencesList.length: ${sharedPreferencesList.length}");
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlaces.findAutocompletePredictions(value);
    // if (result != null && result.predictions != null && mounted) {
    print("result: $result");
    setState(() {
      // predictions = result.predictions;
      predictions = result.predictions;
    });
    print("predictions: $predictions");
    // }
  }

  final TextEditingController _addressController = TextEditingController();
  Main listResults = Main();

  void clear() {
    _addressController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print("tempCheck: $tempCheck");
    return Scaffold(
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      //       child: IconButton(
      //         onPressed: () {
      //           bool? unitPref = sharedPreferencesInstance.getBool('unitPref');
      //           unitPref = !unitPref!;
      //           sharedPreferencesInstance.setBool('unitPref', unitPref);
      //           print("onPressed unitPref: $unitPref");
      //           initSharedPreferences().then((_) => setState(() {}));
      //           // dummyFetch();
      //         },
      //         icon: tempCheck ?? true
      //             ? const Icon(
      //                 MyIcons.celcius,
      //                 size: 40,
      //               )
      //             : const Icon(
      //                 MyIcons.fahrenheit,
      //                 size: 40,
      //               ),
      //       ),
      //     ),
      //   ],
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   centerTitle: true,
      //   // title: Text(widget.title),
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF146ac9),
              Color(0xFF3814d8),
              Color(0xFF5b0dae),
              Color(0xFF0c9bb0),
              Color(0xFF33bdf2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: IconButton(
                      onPressed: () {
                        // bool? unitPref =
                        //     sharedPreferencesInstance.getBool('unitPref');
                        // unitPref = !unitPref;
                        // print("onPressed unitPref: $unitPref");
                        tempCheck = !tempCheck;
                        sharedPreferencesInstance.setBool(
                            'tempCheck', tempCheck);
                        initSharedPreferences().then((_) => setState(() {}));
                        // dummyFetch();
                      },
                      icon: tempCheck
                          ? const Icon(
                              MyIcons.celcius,
                              size: 40,
                            )
                          : const Icon(
                              MyIcons.fahrenheit,
                              size: 40,
                            ),
                    ),
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    // ElevatedButton(
                    //     onPressed: () {
                    //       final bool? prePref =
                    //           sharedPreferencesInstance.getBool('unitPref');
                    //       // print("unitPref: $unitPref");
                    //       print("prePref: $prePref");
                    //       sharedPreferencesInstance.remove('unitPref');
                    //       sharedPreferencesList.clear();
                    //       savePreferences();
                    //       setState(() {});

                    //       final bool? postPref =
                    //           sharedPreferencesInstance.getBool('unitPref');
                    //       // print("unitPref: $unitPref");
                    //       print("postPref: $postPref");
                    //     },
                    //     child: const Text("delete")),
                    // Text(unitPref.toString()),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Open Weather Maps",
                            style: TextStyle(fontSize: 30),
                          ),
                        )),
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
                          suffixIcon: Visibility(
                            visible: _addressController.text.isNotEmpty ||
                                predictions.isNotEmpty,
                            child: IconButton(
                              color: Colors.white,
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                clear();
                                predictions = [];
                              },
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          hintText: 'Search weather location.',
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        controller: _addressController,
                        onSubmitted: (_addressController) async {
                          if (_addressController.isNotEmpty) {
                            clear();
                            // await findLocation(_addressController)
                            //     .then((_) => setState(() {}));
                            // await findLocation(_addressController);
                            // setState(() {});
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: ((context) => WeatherPage(
                            //         sharedPref: sharedPreferencesList.last)),
                            //   ),
                            // );
                          }
                        },
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 1000), () {
                            if (value.isNotEmpty) {
                              autoCompleteSearch(value);
                            } else {
                              clear();
                            }
                          });
                        },
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: predictions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                              "${predictions[index].primaryText}, ${predictions[index].secondaryText}"),
                          onTap: () async {
                            final placeId = predictions[index].placeId;
                            print("placeId: $placeId");
                            print(
                                "predictions[index].placeId: ${predictions[index].placeId}");

                            final details = await googlePlaces
                                .fetchPlace(placeId, fields: placeFields);
                            // await googlePlaces.details.get(placeId);
                            if (mounted) {
                              var lat = details.place!.latLng!.lat;
                              var lng = details.place!.latLng!.lng;
                              final coordinates = 'lat=$lat&lon=$lng';
                              var name = predictions[index].primaryText;
                              await findLocation(coordinates, name).then((_) {
                                setState(() {});
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => WeatherPage(
                                        sharedPref:
                                            sharedPreferencesList.last)),
                                  ),
                                );
                              }).then((_) {
                                predictions = [];
                                clear();
                              });
                            }
                          },
                        );
                      },
                    ),
                    ListView.builder(
                      reverse: true,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: sharedPreferencesList.length,
                      itemBuilder: (context, index) {
                        final sharedListIndex = sharedPreferencesList[index];
                        // print(
                        //     "sharedPreferencesList[index].index: ${sharedPreferencesList[index].index}");
                        // print("sharedListIndex: $sharedListIndex");
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: (() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) =>
                                      WeatherPage(sharedPref: sharedListIndex)),
                                ),
                              );
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
                              child: GlassMorphism(
                                isDaytime: sharedListIndex.isDaytime,
                                // blur: 2,
                                // opacity: .2,
                                blur: 30,
                                opacity: .5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 16, 0, 16),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 8),
                                            child: Text(
                                              sharedListIndex.name.toString(),
                                              style:
                                                  const TextStyle(fontSize: 25),
                                            ),
                                          ),
                                          Text(sharedListIndex.main.toString(),
                                              style: const TextStyle(
                                                  fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 8),
                                          child: Text(
                                            '${sharedListIndex.temp} °${tempCheck ? 'F' : "C"}',
                                            style:
                                                const TextStyle(fontSize: 25),
                                          ),
                                        ),
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/${sharedListIndex.icon}.png"),
                                                // "https://openweathermap.org/img/wn/${sharedListIndex.icon}.png"),

                                                fit: BoxFit.none),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // ),
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
                                    text: 'Google Places API',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        color: Colors.white),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        var url =
                                            'https://developers.google.com/maps/documentation/places/web-service';
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
                                    text: 'Open Weather Maps API',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        color: Colors.white),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        var url =
                                            'https://openweathermap.org/api';
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
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor:
                                      const Color.fromRGBO(255, 255, 255, .1),
                                  child: Image.asset(
                                    'assets/images/google-maps-logo.png',
                                    fit: BoxFit.none,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    'assets/images/logo_white_cropped.png',
                                    fit: BoxFit.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     Container(
                          //       width: 40,
                          //       height: 40,
                          //       decoration: const BoxDecoration(
                          //         // shape: BoxShape.circle,
                          //         image: DecorationImage(
                          //             image:
                          //                 AssetImage('assets/images/favicon.ico'),
                          //             fit: BoxFit.fill),
                          //       ),
                          //     ),
                          //     // Container(
                          //     //   width: 200,
                          //     //   height: 20,
                          //     //   decoration: const BoxDecoration(
                          //     //     shape: BoxShape.circle,
                          //     //     image: DecorationImage(
                          //     //         image: AssetImage(
                          //     //             'assets/images/places_icon.svg'),
                          //     //         fit: BoxFit.fill),
                          //     //   ),
                          //     // ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void doNothing(BuildContext context) {}

// void convertLocalToDetroit() async {
// DateTime indiaTime = DateTime.now(); //Emulator time is India time
//   final detroitTime =
//       new TZDateTime.from(indiaTime, getLocation('America/Detroit'));
// print('Local India Time: ' + indiaTime.toString());
//   print('Detroit Time: ' + detroitTime.toString());
// }