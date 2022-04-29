import 'package:json_annotation/json_annotation.dart';

part 'sharedPref.g.dart';

@JsonSerializable()
class SharedPref {
  String? icon,
      short_name,
      shortForecast,
      temperature,
      forecastHourlyUrl,
      forecastUrl;
  bool? isDaytime;
  int? index;

  SharedPref({
    this.short_name,
    this.shortForecast,
    this.icon,
    this.temperature,
    this.forecastHourlyUrl,
    this.forecastUrl,
    this.isDaytime,
    this.index,
  });
  factory SharedPref.fromJson(Map<String, dynamic> json) =>
      _$SharedPrefFromJson(json);
  Map<String, dynamic> toJson() => _$SharedPrefToJson(this);
}





// import 'package:json_annotation/json_annotation.dart';

// // part 'model.g.dart';

// // @JsonSerializable()
// class SharedPref {
//   String? icon, short_name, shortForecast, temperature, forecastHourlyUrl;

//   SharedPref({
//     this.short_name,
//     this.shortForecast,
//     this.icon,
//     this.temperature,
//     this.forecastHourlyUrl,
//   });
//   // factory SharedPref.fromJson(Map<String, dynamic> json) =>
//   //     _$SharedPrefFromJson(json);
//   // Map<String, dynamic> toJson() => _$SharedPrefToJson(this);
//   SharedPref.fromMap(Map map)
//       : icon = map['icon'],
//         short_name = map['short_name'],
//         shortForecast = map['shortForecast'],
//         temperature = map['temperature'],
//         forecastHourlyUrl = map['forecastHourlyUrl'];

//   Map toMap() {
//     return {
//       'icon': icon,
//       'short_name': short_name,
//       'shortForecast': shortForecast,
//       'temperature': temperature,
//       'forecastHourlyUrl': forecastHourlyUrl,
//     };
//   }
// }
