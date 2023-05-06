import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/utils/services/daily_list.dart';
import 'package:weatherapp/utils/services/hourly_list.dart';
import '../models/location/location.dart';
import '../utils/functions/format_unit.dart';
import '../utils/functions/hourly_time.dart';
import '../utils/services/temp_unit.dart';
import '../widgets/glass.dart';

var day = const [
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

class LocationPage extends ConsumerStatefulWidget {
  final Location location;
  const LocationPage({Key? key, required this.location}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends ConsumerState<LocationPage> {
  @override
  Widget build(BuildContext context) {
    final hourlyList = ref.watch(hourlyProvider);
    final dailyList = ref.watch(dailyProvider);
    double blur = 35;
    double opacity = .5;
    final hourlyItem = hourlyList[widget.location.name];
    final dailyItem = dailyList[widget.location.name];

    final tempUnit = ref.watch(tempUnitStateNotifierProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.location.isDaytime! ? day : night,
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
                        isDaytime: widget.location.isDaytime,
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
                                      child: Text(widget.location.name!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${formatUnit(hourlyItem!.first.temp, ref)}°${tempUnit ? 'F' : "C"}",
                                        style: const TextStyle(fontSize: 50),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(hourlyItem.first.weather!.first.main!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "H:${formatUnit(dailyItem!.first.temp!.max, ref)}° L:${formatUnit(dailyItem.first.temp!.min, ref)}°",
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("HUMIDITY: ${dailyItem.first.humidity}%"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("FEELS LIKE: ${formatUnit(hourlyItem.first.feelsLike, ref)}°"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("WIND SPEED: ${hourlyItem.first.windSpeed} ${tempUnit ? "MPH" : "KPH"}"),
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
                          isDaytime: widget.location.isDaytime,
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
                                        Text(hourlyTime(hourlyItem[index].dt!.toInt(), widget.location.timezone!)),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: AssetImage("assets/images/${hourlyItem[index].weather!.first.icon}.png"),
                                          ),
                                        ),
                                        Text(
                                          '${formatUnit(hourlyItem[index].temp, ref)}°',
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
                        isDaytime: widget.location.isDaytime,
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
                                  width: 35,
                                  child: Text(""),
                                ),
                                SizedBox(
                                  width: 35,
                                  child: Text(""),
                                ),
                                SizedBox(
                                  width: 35,
                                  child: Text(
                                    "MORN",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  child: Text(
                                    "DAY",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  child: Text(
                                    "EVE",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
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
                              itemCount: dailyItem.length,
                              itemBuilder: (context, index) => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 35,
                                    child: Text(
                                      DateFormat("E").format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          dailyItem[index].dt!.toInt() * 1000,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(
                                        "assets/images/${hourlyItem[index].weather!.first.icon}.png",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 35,
                                    child: Text(
                                      "${formatUnit(dailyItem[index].temp!.morn, ref)}°",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 35,
                                    child: Text(
                                      "${formatUnit(dailyItem[index].temp!.day, ref)}°",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 35,
                                    child: Text(
                                      "${formatUnit(dailyItem[index].temp!.eve, ref)}°",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 35,
                                    child: Text(
                                      "${formatUnit(dailyItem[index].temp!.night, ref)}°",
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
