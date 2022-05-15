import 'dart:developer';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:national_weather/Widgets/glass.dart';
import 'package:flutter/material.dart';
import 'package:national_weather/models/nationalweather/daily/daily.dart';
import 'package:national_weather/models/nationalweather/hourly/hourly.dart';
import 'package:national_weather/models/sharedpreferences/sharedPref.dart';
import '../http/fetch.dart';
import 'package:readmore/readmore.dart';

var day = [
  // Color(0xFF3c9dd0),
  // Color(0xFF086ca2),
  // Color(0xFF235b79),
  // Color(0xFF034569),
  // Color(0xFF1c3464),
  Color(0xFF1f61cd),
  Color(0xFF3049dd),
  Color(0xFF3755cc),
  Color(0xFF3c62da),
  Color(0xFF1a48bc),
];
var night = [
  Color(0xFF3a4ca3),
  Color(0xFF2143a1),
  Color(0xFF062965),
  Color(0xFF051d2f),
  Color(0xFF1b233e),
];

class WeatherPage extends ConsumerStatefulWidget {
  final SharedPref sharedPref;
  const WeatherPage({Key? key, required this.sharedPref}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  // Weather weather = Weather();
  // Weather weatherHourly = Weather();

  @override
  Widget build(BuildContext context) {
    final List<List<Hourly>> hourlyList = ref.watch(hourlyListProvider);
    final List<List<Daily>> dailyList = ref.watch(dailyListProvider);
    double blur = 30;
    double opacity = .5;
    int listIndex = widget.sharedPref.index ?? 0;
    print(listIndex);
    // for (var i = 0; i < dailyList.length; i++) {
    // log("dailyList: ${dailyList[listIndex][i].toJson()}");
    // }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.sharedPref.isDaytime! ? day : night,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 8, 40, 40),
                  child: GlassMorphism(
                    isDaytime: widget.sharedPref.isDaytime,
                    // hourlyList[listIndex?.toInt() ?? 0].first.isDaytime,
                    blur: blur,
                    opacity: opacity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.sharedPref.name.toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${hourlyList[listIndex].first.temp.ceil().toString()}°",
                                  style: const TextStyle(fontSize: 50),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(hourlyList[listIndex]
                                    .first
                                    .weather
                                    .first
                                    .main),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "H:${dailyList[listIndex].first.temp.max.ceil().toString()}° L:${dailyList[listIndex].first.temp.min.ceil().toString()}°",
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "HUMIDITY: ${dailyList[listIndex].first.humidity.toString()}%"),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Text(
                              //       "Moon Phase: ${widget.sharedPref.moon_phase.toString()}%"),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Text(
                              //       "Clouds: ${hourlyList[listIndex].first.clouds.toString()}%"),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "FEELS LIKE: ${hourlyList[listIndex].first.feels_like.toString()}°"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "WIND SPEED: ${hourlyList[listIndex].first.wind_speed.toString()} mph"),
                              ),
                              // Padding(
                              // padding: const EdgeInsets.all(8.0),
                              // child: Text(
                              // "WIND SPEED: ${hourlyList[listIndex].first.visibility.toString()} mph"),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GlassMorphism(
                      isDaytime: widget.sharedPref.isDaytime,
                      blur: blur,
                      opacity: opacity,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 10, 8, 4),
                              child: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.access_time_filled,
                                        // color: Colors.blue,
                                        size: 15,
                                      ),
                                    ),
                                    TextSpan(text: " HOURLY FORECAST"),
                                  ],
                                ),
                                // style: widget.sharedPref.isDaytime! ? day : night,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 12,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    // Text(
                                    //   DateFormat("E h a")
                                    //       .format(
                                    //         DateTime.fromMillisecondsSinceEpoch(
                                    //           hourlyList[listIndex][index]
                                    //                   .dt
                                    //                   .toInt() *
                                    //               1000,
                                    //         ),
                                    //       )
                                    //       .toString(),
                                    // ),
                                    Text(hourlyTime(
                                        hourlyList[listIndex][index].dt.toInt(),
                                        widget.sharedPref.timezone.toString())),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(
                                          "http://openweathermap.org/img/wn/${hourlyList[listIndex][index].weather.first.icon}.png",
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${hourlyList[listIndex][index].temp.ceil().toString()}°',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GlassMorphism(
                    isDaytime: widget.sharedPref.isDaytime,
                    blur: blur,
                    opacity: opacity,
                    child: Container(
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 10, 8, 8),
                              child: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.calendar_month_outlined,
                                        // color: Colors.blue,
                                        size: 15,
                                      ),
                                    ),
                                    TextSpan(text: " 7-DAY FORECAST"),
                                  ],
                                ),
                                // style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              SizedBox(
                                width: 30,
                                child: Text(""),
                              ),
                              SizedBox(
                                width: 30,
                                child: Text(""),
                              ),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  "MORN",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  "DAY",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  "EVE",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  "NIGHT",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dailyList[listIndex].length,
                            itemBuilder: (context, index) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    DateFormat("E").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        dailyList[listIndex][index].dt.toInt() *
                                            1000,
                                      ),
                                    ),
                                  ),
                                ),
                                // Text(dailyList[listIndex][index].temp.morn.toString()),
                                SizedBox(
                                  width: 40,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                      "http://openweathermap.org/img/wn/${dailyList[listIndex][index].weather.first.icon}.png",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    "${dailyList[listIndex][index].temp.morn.ceil().toString()}°",
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    "${dailyList[listIndex][index].temp.day.ceil().toString()}°",
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    "${dailyList[listIndex][index].temp.eve.ceil().toString()}°",
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    "${dailyList[listIndex][index].temp.night.ceil().toString()}°",
                                  ),
                                ),
                                // Column(
                                //   children: [
                                //     Text(
                                //         dailyList[listIndex][index].temp.day.toString())
                                // SizedBox(
                                //   width: 75,
                                //   child: Text(dailyList[listIndex ?? 0][index]
                                //       .weather
                                //       .first
                                //       .main),
                                // ),
                                // Text(
                                //   dailyList[listIndex ?? 0][index].isDaytime ==
                                //           false
                                //       ? "Low ${dailyList[listIndex ?? 0][index].temperature.toString()}°${dailyList[listIndex ?? 0][index].temperatureUnit.toString()}"
                                //       : "High ${dailyList[listIndex ?? 0][index].temperature.toString()} °${dailyList[listIndex ?? 0][index].temperatureUnit.toString()}",
                                // ),
                                // ],
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: CircleAvatar(
                                //     backgroundImage: NetworkImage(
                                //       "http://openweathermap.org/img/wn/${dailyList[listIndex?.toInt() ?? 0][index].weather.first.icon.toString()}.png",
                                //     ),
                                //   ),
                                // ),
                                // Expanded(
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: ReadMoreText(
                                //       dailyList[listIndex ?? 0][index]
                                //           .weather
                                //           .first
                                //           .description,
                                //       style: const TextStyle(color: Colors.white),
                                //       trimLines: 3,
                                //       trimMode: TrimMode.Line,
                                //       trimCollapsedText: 'Read More',
                                //       trimExpandedText: 'Read Less',
                                //       lessStyle: const TextStyle(
                                //           color: Colors.white,
                                //           fontWeight: FontWeight.bold),
                                //       moreStyle: const TextStyle(
                                //           color: Colors.white,
                                //           fontWeight: FontWeight.bold),
                                //       colorClickableText: Colors.pink,
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
