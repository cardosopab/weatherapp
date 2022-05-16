import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:national_weather/Widgets/glass.dart';
import 'package:national_weather/main.dart';
import 'package:national_weather/models/geocoding/main/main.dart';
import 'package:national_weather/my_icons_icons.dart';
import 'package:timezone/timezone.dart';
import 'package:url_launcher/url_launcher.dart';
import '../http/fetch.dart';
import 'weatherpage.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    initSharedPreferences().then((_) => setState(() {}));
  }

  final TextEditingController _addressController = TextEditingController();
  Main listResults = Main();

  void clear() {
    _addressController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              bool? unitPref = sharedPreferencesInstance.getBool('unitPref');
              unitPref = !unitPref!;
              sharedPreferencesInstance.setBool('unitPref', unitPref);
              print("onPressed unitPref: $unitPref");
              initSharedPreferences().then((_) => setState(() {}));
              // dummyFetch();
            },
            icon: tempCheck ?? true
                ? const Icon(MyIcons.celcius)
                : const Icon(MyIcons.fahrenheit),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        // title: Text(widget.title),
      ),
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
              // Color(0xFF3c9dd0),
              // Color(0xFF086ca2),
              // Color(0xFF235b79),
              // Color(0xFF034569),
              // Color(0xFF1c3464),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                    onSubmitted: (_addressController) {
                      if (_addressController.isNotEmpty) {
                        clear();
                        findLocation(_addressController)
                            .then((value) => setState(() {}));
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
                    final sharedListIndex = sharedPreferencesList[index];
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 16, 0, 16),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 8),
                                        child: Text(
                                          sharedListIndex.name.toString(),
                                          style: const TextStyle(fontSize: 25),
                                        ),
                                      ),
                                      Text(sharedListIndex.main.toString(),
                                          style: const TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                      child: Text(
                                        '${sharedListIndex.temp} °${tempCheck ?? true ? 'F' : "C"}',
                                        style: const TextStyle(fontSize: 25),
                                      ),
                                    ),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "http://openweathermap.org/img/wn/${sharedListIndex.icon}.png"),
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
                                text: 'Google Geocoding API',
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    var url =
                                        'https://developers.google.com/maps/documentation/geocoding/';
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
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    var url = 'https://openweathermap.org/api';
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
                              backgroundColor: Colors.transparent,
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