import 'package:json_annotation/json_annotation.dart';

import '../current/current.dart';
import '../daily/daily.dart';
import '../hourly/hourly.dart';

part 'models.g.dart';

@JsonSerializable()
class Model {
  String? timezone;
  double? lat, lon, timezone_offset;
  Current? current;
  List<Hourly>? hourly;
  List<Daily>? daily;

  Model({
    this.lat,
    this.lon,
    this.timezone,
    this.timezone_offset,
    this.current,
    this.hourly,
    this.daily,
  });
  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}
