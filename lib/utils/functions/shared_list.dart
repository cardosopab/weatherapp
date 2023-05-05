import 'package:weatherapp/utils/services/location_fetch.dart';

// Future findLocation(coordinates, name) async {
//   await LocationAPI().locationFetch(coordinates).then(
//     (forecastResponse) {
//       if (sharedPreferencesList.isEmpty) {
//         hourlyList.add(forecastResponse.hourly!);
//         dailyList.add(forecastResponse.daily!);
//         addLocationValue(
//           SharedPref(
//             icon: forecastResponse.current!.weather!.first.icon,
//             description: forecastResponse.current!.weather!.first.description,
//             temp: forecastResponse.current!.temp.ceil().toString(),
//             coordinates: coordinates,
//             humidity: forecastResponse.daily!.first.humidity.toString(),
//             main: forecastResponse.current!.weather!.first.main,
//             moon_phase: forecastResponse.daily!.first.moon_phase.toString(),
//             timezone: forecastResponse.timezone,
//             dt: currentTime(forecastResponse.current!.dt.toInt(), forecastResponse.timezone.toString()),
//             name: name,
//             isDaytime: forecastResponse.current!.weather!.first.icon.contains('d') ? true : false,
//             index: 0,
//           ),
//         );
//       } else {
//         bool inList = false;
//         for (var i = 0; i < sharedPreferencesList.length; i++) {
//           if (sharedPreferencesList[i].toJson().containsValue(name)) {
//             inList = true;
//           } else {
//             inList = false;
//           }
//         }
//         if (inList == false) {
//           hourlyList.add(forecastResponse.hourly!);
//           dailyList.add(forecastResponse.daily!);
//           addLocationValue(
//             SharedPref(
//               icon: forecastResponse.current!.weather!.first.icon,
//               description: forecastResponse.current!.weather!.first.description,
//               temp: forecastResponse.current!.temp.ceil().toString(),
//               coordinates: coordinates,
//               humidity: forecastResponse.daily!.first.humidity.toString(),
//               main: forecastResponse.current!.weather!.first.main,
//               moon_phase: forecastResponse.daily!.first.moon_phase.toString(),
//               timezone: forecastResponse.timezone,
//               dt: currentTime(forecastResponse.current!.dt.toInt(), forecastResponse.timezone.toString()),
//               name: name,
//               isDaytime: forecastResponse.current!.weather!.first.icon.contains('d') ? true : false,
//               index: sharedPreferencesList.length,
//             ),
//           );
//         }
//       }
//     },
//   );
// }