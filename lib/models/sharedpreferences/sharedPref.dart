import 'package:json_annotation/json_annotation.dart';

part 'sharedPref.g.dart';

@JsonSerializable()
class SharedPref {
  String? icon,
      name,
      description,
      main,
      humidity,
      temp,
      moon_phase,
      coordinates;

  // bool isDaytime;

  SharedPref({
    this.icon,
    this.name,
    this.description,
    this.main,
    this.humidity,
    this.temp,
    this.moon_phase,
    // required this.isDaytime,
    this.coordinates,
  });
  factory SharedPref.fromJson(Map<String, dynamic> json) =>
      _$SharedPrefFromJson(json);
  Map<String, dynamic> toJson() => _$SharedPrefToJson(this);
}
