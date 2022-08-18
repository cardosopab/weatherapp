import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/Widgets/glass.dart';
import 'package:weatherapp/models/openweather/daily/daily.dart';
import 'package:weatherapp/models/openweather/hourly/hourly.dart';
import 'package:weatherapp/models/sharedpreferences/sharedPref.dart';
import '../http/fetch.dart';

var day = const [
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
var night = const [
  Color(0xFF1b233e),
  Color(0xFF051d2f),
  Color(0xFF062965),
  Color(0xFF2143a1),
  Color(0xFF3a4ca3),
];

class WeatherPage extends ConsumerStatefulWidget {
  final SharedPref sharedPref;
  const WeatherPage({Key? key, required this.sharedPref}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    final List<List<Hourly>> hourlyList = ref.watch(hourlyListProvider);
    final List<List<Daily>> dailyList = ref.watch(dailyListProvider);
    double blur = 30;
    double opacity = .5;
    int listIndex = widget.sharedPref.index!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.sharedPref.isDaytime! ? day : night,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                leading: IconButton(onPressed: (() => Navigator.pop(context)), icon: const Icon(Icons.arrow_back_ios)),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 8, 40, 40),
                      child: GlassMorphism(
                        isDaytime: widget.sharedPref.isDaytime,
                        blur: blur,
                        opacity: opacity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            fit: BoxFit.contain,
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
                                        "${hourlyList[listIndex].first.temp.ceil().toString()}°${tempCheck ? 'F' : "C"}",
                                        style: const TextStyle(fontSize: 50),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(hourlyList[listIndex].first.weather.first.main),
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
                                      child: Text("HUMIDITY: ${dailyList[listIndex].first.humidity.toString()}%"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("FEELS LIKE: ${hourlyList[listIndex].first.feels_like.toString()}°"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("WIND SPEED: ${hourlyList[listIndex].first.wind_speed.toString()} ${tempCheck ? "MPH" : "KPH"}"),
                                    ),
                                  ],
                                )
                              ],
                            ),
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
                                            size: 15,
                                          ),
                                        ),
                                        TextSpan(text: " HOURLY FORECAST"),
                                      ],
                                    ),
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
                                        Text(hourlyTime(hourlyList[listIndex][index].dt.toInt(), widget.sharedPref.timezone.toString())),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: AssetImage("assets/images/${hourlyList[listIndex][index].weather.first.icon}.png"),
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
                                          size: 15,
                                        ),
                                      ),
                                      TextSpan(text: " 7-DAY FORECAST"),
                                    ],
                                  ),
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
                                          dailyList[listIndex][index].dt.toInt() * 1000,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                        "https://openweathermap.org/img/wn/${dailyList[listIndex][index].weather.first.icon}.png",
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
                                ],
                              ),
                            ),
                          ],
                        ),
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
