import 'package:json_annotation/json_annotation.dart';

part 'feelsLike.g.dart';

@JsonSerializable()
class FeelsLike {
  double day, night, eve, morn;

  FeelsLike({
    required this.day,
    required this.night,
    required this.eve,
    required this.morn,
  });
  factory FeelsLike.fromJson(Map<String, dynamic> json) =>
      _$FeelsLikeFromJson(json);
  Map<String, dynamic> toJson() => _$FeelsLikeToJson(this);
}
