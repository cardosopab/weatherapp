import 'package:json_annotation/json_annotation.dart';

import '../feelsLike/feelsLike.dart';
import '../temp/temp.dart';
import '../weather/weather.dart';

part 'daily.g.dart';

@JsonSerializable()
class Daily {
  double pop,
      wind_gust,
      wind_speed,
      dew_point,
      moon_phase,
      uvi,
      dt,
      sunrise,
      sunset,
      moonrise,
      moonset,
      pressure,
      humidity,
      wind_deg,
      clouds;
  Temp temp;
  FeelsLike feels_like;
  List<Weather> weather;

  Daily({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moon_phase,
    required this.pressure,
    required this.humidity,
    required this.dew_point,
    required this.wind_speed,
    required this.wind_deg,
    required this.wind_gust,
    required this.clouds,
    required this.pop,
    required this.uvi,
    required this.temp,
    required this.feels_like,
    required this.weather,
  });
  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);
  Map<String, dynamic> toJson() => _$DailyToJson(this);
}
