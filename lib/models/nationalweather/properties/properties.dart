import 'package:json_annotation/json_annotation.dart';

import '../periods/periods.dart';

part 'properties.g.dart';

@JsonSerializable()
class Properties {
  String? forecastGenerator;
  String? updateTime;
  List<Periods>? periods;
  // List<Properties>? Properties;

  Properties({this.forecastGenerator, this.updateTime, this.periods});
  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$PropertiesToJson(this);
}
