import 'package:json_annotation/json_annotation.dart';

import '../weather/weather.dart';

part 'hourly.g.dart';

@JsonSerializable()
class Hourly {
  double uvi,
      wind_gust,
      wind_speed,
      dew_point,
      feels_like,
      temp,
      pop,
      dt,
      pressure,
      humidity,
      clouds,
      visibility,
      wind_deg;
  List<Weather> weather;

  Hourly({
    required this.dt,
    required this.temp,
    required this.feels_like,
    required this.pressure,
    required this.humidity,
    required this.dew_point,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.wind_speed,
    required this.wind_deg,
    required this.wind_gust,
    required this.pop,
    required this.weather,
  });
  factory Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);
  Map<String, dynamic> toJson() => _$HourlyToJson(this);
}
