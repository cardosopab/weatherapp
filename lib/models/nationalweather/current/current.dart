import 'package:json_annotation/json_annotation.dart';

import '../weather/weather.dart';

part 'current.g.dart';

@JsonSerializable()
class Current {
  double dt,
      sunrise,
      sunset,
      pressure,
      humidity,
      clouds,
      visibility,
      wind_deg,
      uvi,
      wind_speed,
      dew_point,
      feels_like,
      temp;
  List<Weather> weather;

  Current({
    required this.dt,
    required this.sunrise,
    required this.sunset,
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
    required this.weather,
  });
  factory Current.fromJson(Map<String, dynamic> json) =>
      _$CurrentFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentToJson(this);
}
