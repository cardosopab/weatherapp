import 'package:json_annotation/json_annotation.dart';
import 'package:national_weather/models/nationalweather/properties/properties.dart';

part 'models.g.dart';

@JsonSerializable()
class Weather {
  String? type;
  Properties? properties;
  // List<Weather>? properties;

  Weather({
    this.type,
    // this.properties,
    this.properties,
  });
  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
