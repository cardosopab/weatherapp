import 'dart:convert' as convert;
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:national_weather/Widgets/glass.dart';
import 'package:flutter/material.dart';
import 'package:national_weather/Widgets/isDaytime.dart';
import 'package:national_weather/models/sharedpreferences/sharedPref.dart';
import 'package:national_weather/pages/homepage.dart';
import '../models/nationalweather/periods/periods.dart';
import '../models/nationalweather/properties/properties.dart';
import '../models/nationalweather/weather/models.dart';
import 'package:readmore/readmore.dart';

class WeatherPage extends ConsumerStatefulWidget {
  final SharedPref sharedPref;
  const WeatherPage({Key? key, required this.sharedPref}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  Weather weather = Weather();
  Properties properties = Properties();
  Periods periods = Periods();
  Weather weatherHourly = Weather();
  Properties propertiesHourly = Properties();
  Periods periodsHourly = Periods();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await fetchForecast(widget.sharedPref.forecastUrl.toString());
      await fetchHourlyForecast(widget.sharedPref.forecastHourlyUrl.toString());
      // print('Forecast: ${widget.sharedPref.forecastUrl}');
      print('isDaytime: ${widget.sharedPref.isDaytime}');
      print(widget.sharedPref.icon);
    });
    super.initState();
  }

  Future fetchHourlyForecast(url) async {
    final response = await http.get(Uri.parse(url));
    // final response =
    //     await http.get(Uri.parse('http://10.0.2.2:8000/forecast/hourly'));
    var jsonBody = convert.json.decode(response.body);
    weatherHourly = Weather.fromJson(jsonBody);
    propertiesHourly = Properties.fromJson(jsonBody);
    periodsHourly = Periods.fromJson(jsonBody);
    setState(() {
      weatherHourly;
      propertiesHourly;
      periodsHourly;
      // print('After Hourly: ${weatherHourly.type}');
    });
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

  @override
  Widget build(BuildContext context) {
    double blur = 30;
    double opacity = .4;
    // final coordinates = ref.watch(coordinatesProvider);
    // bool isDaytime = ref.watch(isDaytimeProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // title: Text(widget.title),
      ),
      body: weather.type == null && weatherHourly.type == null
          ? const CircularProgressIndicator()
          : DecoratedBox(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(weatherHourly
                              .properties?.periods?.first.icon
                              .toString() ??
                          'null'))),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: GlassMorphism(
                            blur: blur,
                            opacity: opacity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // Text(coordinates.toString()),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(widget.sharedPref.short_name
                                        .toString()),
                                  ),
                                  // Text(),
                                  Text(
                                    '${weatherHourly.properties?.periods?.first.temperature.toString()}°',
                                    style: const TextStyle(fontSize: 50),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(weatherHourly.properties
                                            ?.periods?.first.shortForecast
                                            .toString() ??
                                        'null'),
                                  ),
                                  // Text(DateFormat.jm().format(DateTime.now())),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 125,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                                // weatherHourly.properties?.periods?.length,
                                // weatherHourly.properties?.periods
                                //             .toString()
                                //             .length <
                                //         10
                                //     ? weatherHourly.properties?.periods
                                //         .toString()
                                //         .length
                                //     : 10,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GlassMorphism(
                                    blur: blur,
                                    opacity: opacity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          // Text(weatherHourly.properties?
                                          //     .periods?[index].startTime
                                          //     .toString()),
                                          // Text(DateTime.now().toString()),
                                          Text(
                                            DateFormat.j().format(
                                                DateTime.parse((weatherHourly
                                                        .properties
                                                        ?.periods?[index]
                                                        .startTime
                                                        .toString()
                                                        .substring(0, 19) ??
                                                    '2022-03-26T10:00:00'))),
                                            // Text(DateFormat.j().format(
                                            //     DateTime.parse(weatherHourly
                                            //             .properties?
                                            //             .periods ?[index]
                                            //             .startTime
                                            //             .toString()
                                            //             .substring(0, 19) ??
                                            //         'null'))),
                                            // Text(DateFormat.j().format(
                                            //     DateTime.parse(
                                            //         '2022-03-26T10:00:00'))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  weatherHourly.properties
                                                          ?.periods?[index].icon
                                                          .toString() ??
                                                      'null'),
                                            ),
                                          ),
                                          Text(
                                            '${weatherHourly.properties?.periods?[index].temperature.toString()}°',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          // itemCount: weather.properties?.periods?.length,
                          itemCount: 10,
                          // weather.properties?.periods.toString().length < 10
                          //     ? weather.properties?.periods.toString().length
                          //     : 10,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GlassMorphism(
                              blur: blur,
                              opacity: opacity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 75,
                                          child: Text(weather.properties
                                                  ?.periods?[index].name
                                                  .toString() ??
                                              'null'),
                                        ),
                                        Text(
                                          weather.properties?.periods?[index]
                                                      .isDaytime ==
                                                  false
                                              ? "Low ${weather.properties?.periods?[index].temperature.toString()}°${weather.properties?.periods?[index].temperatureUnit.toString()}"
                                              : "High ${weather.properties?.periods?[index].temperature.toString()} °${weather.properties?.periods?[index].temperatureUnit.toString()}",
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(weather
                                                .properties
                                                ?.periods?[index]
                                                .icon
                                                .toString() ??
                                            'null'),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ReadMoreText(
                                          weather.properties?.periods?[index]
                                                  .detailedForecast
                                                  .toString() ??
                                              'null',
                                          trimLines: 3,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'Read More',
                                          trimExpandedText: 'Read Less',
                                          lessStyle: const TextStyle(
                                              color: Colors.purple),
                                          moreStyle: const TextStyle(
                                              color: Colors.purple),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
