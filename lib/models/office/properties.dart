import 'package:json_annotation/json_annotation.dart';

part 'properties.g.dart';

@JsonSerializable()
class Properties {
  String? forecast;
  String? forecastHourly;

  Properties({
    this.forecast,
    this.forecastHourly,
  });
  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$PropertiesToJson(this);
}
