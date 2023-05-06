import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  String? icon, name, description, main, humidity, dt, moon_phase, coordinates, timezone;

  double? temp;

  bool? isDaytime;

  Location({
    this.icon,
    this.name,
    this.description,
    this.main,
    this.humidity,
    this.temp,
    this.moon_phase,
    this.isDaytime,
    this.coordinates,
    this.dt,
    this.timezone,
  });
  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
