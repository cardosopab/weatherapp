// import 'dart:ui';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:national_weather/Widgets/glass.dart';
// import 'package:flutter/material.dart';
// import 'package:national_weather/models/sharedpreferences/sharedPref.dart';
// import '../http/fetch.dart';
// import 'package:readmore/readmore.dart';

// class WeatherPage extends ConsumerStatefulWidget {
//   final SharedPref sharedPref;
//   const WeatherPage({Key? key, required this.sharedPref}) : super(key: key);

//   @override
//   _WeatherPageState createState() => _WeatherPageState();
// }

// class _WeatherPageState extends ConsumerState<WeatherPage> {
//   // Weather weather = Weather();
//   // Weather weatherHourly = Weather();

//   @override
//   Widget build(BuildContext context) {
//     // final List<List<Periods>> hourlyList = ref.watch(hourlyListProvider);
//     // final List<List<Periods>> forecastList = ref.watch(forecastListProvider);
//     double blur = 30;
//     double opacity = .4;
//     int? listIndex = widget.sharedPref.index;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//       ),
//       body: DecoratedBox(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: NetworkImage(hourlyList[listIndex?.toInt() ?? 0]
//                     .first
//                     .icon
//                     .toString()))),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(
//             sigmaX: 10,
//             sigmaY: 10,
//           ),
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(40.0),
//                     child: GlassMorphism(
//                       isDaytime:
//                           hourlyList[listIndex?.toInt() ?? 0].first.isDaytime,
//                       blur: blur,
//                       opacity: opacity,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child:
//                                   Text(widget.sharedPref.short_name.toString()),
//                             ),
//                             Text(
//                               hourlyList[listIndex?.toInt() ?? 0]
//                                   .first
//                                   .temperature
//                                   .toString(),
//                               style: const TextStyle(fontSize: 50),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(hourlyList[listIndex?.toInt() ?? 0]
//                                       .first
//                                       .shortForecast ??
//                                   ''),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 125,
//                     width: MediaQuery.of(context).size.width,
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: 10,
//                         itemBuilder: (context, index) => Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: GlassMorphism(
//                             isDaytime:
//                                 hourlyList[listIndex ?? 0][index].isDaytime,
//                             blur: blur,
//                             opacity: opacity,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     DateFormat.j().format(DateTime.parse(
//                                         (hourlyList[listIndex ?? 0][index]
//                                             .startTime
//                                             .toString()
//                                             .substring(0, 19)))),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: CircleAvatar(
//                                       backgroundImage: NetworkImage(
//                                           hourlyList[listIndex ?? 0][index]
//                                               .icon
//                                               .toString()),
//                                     ),
//                                   ),
//                                   Text(
//                                     '${hourlyList[listIndex ?? 0][index].temperature.toString()}°',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: 10,
//                     itemBuilder: (context, index) => Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: GlassMorphism(
//                         isDaytime: hourlyList[listIndex ?? 0][index].isDaytime,
//                         blur: blur,
//                         opacity: opacity,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Column(
//                                 children: [
//                                   SizedBox(
//                                     width: 75,
//                                     child: Text(forecastList[listIndex ?? 0]
//                                                 [index]
//                                             .name ??
//                                         ''),
//                                   ),
//                                   Text(
//                                     forecastList[listIndex ?? 0][index]
//                                                 .isDaytime ==
//                                             false
//                                         ? "Low ${forecastList[listIndex ?? 0][index].temperature.toString()}°${forecastList[listIndex ?? 0][index].temperatureUnit.toString()}"
//                                         : "High ${forecastList[listIndex ?? 0][index].temperature.toString()} °${forecastList[listIndex ?? 0][index].temperatureUnit.toString()}",
//                                   ),
//                                 ],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: CircleAvatar(
//                                   backgroundImage: NetworkImage(
//                                       forecastList[listIndex ?? 0][index]
//                                           .icon
//                                           .toString()),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: ReadMoreText(
//                                     forecastList[listIndex ?? 0][index]
//                                         .detailedForecast
//                                         .toString(),
//                                     style: const TextStyle(color: Colors.white),
//                                     trimLines: 3,
//                                     trimMode: TrimMode.Line,
//                                     trimCollapsedText: 'Read More',
//                                     trimExpandedText: 'Read Less',
//                                     lessStyle: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                     moreStyle: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                     colorClickableText: Colors.pink,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
