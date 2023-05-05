import 'package:json_annotation/json_annotation.dart';

part 'sharedPref.g.dart';

@JsonSerializable()
class SharedPref {
  String? icon, name, description, main, humidity, temp, dt, moon_phase, coordinates, timezone;
  // int? index;

  bool? isDaytime;

  SharedPref({
    this.icon,
    this.name,
    this.description,
    this.main,
    this.humidity,
    this.temp,
    this.moon_phase,
    this.isDaytime,
    this.coordinates,
    // this.index,
    this.dt,
    this.timezone,
  });
  factory SharedPref.fromJson(Map<String, dynamic> json) => _$SharedPrefFromJson(json);
  Map<String, dynamic> toJson() => _$SharedPrefToJson(this);
}
