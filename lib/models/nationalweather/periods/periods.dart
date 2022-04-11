import 'package:json_annotation/json_annotation.dart';

part 'periods.g.dart';

@JsonSerializable()
class Periods {
  String? name;
  String? startTime;
  String? endTime;
  bool? isDaytime;
  int? temperature;
  String? temperatureUnit;
  String? icon;
  String? shortForecast;
  String? detailedForecast;

  Periods(
      {this.name,
      this.isDaytime,
      this.temperature,
      this.temperatureUnit,
      this.icon,
      this.shortForecast,
      this.detailedForecast});
  factory Periods.fromJson(Map<String, dynamic> json) =>
      _$PeriodsFromJson(json);
  Map<String, dynamic> toJson() => _$PeriodsToJson(this);
}
