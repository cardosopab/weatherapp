import 'package:json_annotation/json_annotation.dart';
import 'package:weatherapp/models/geocoding/location/location.dart';

part 'geometry.g.dart';

@JsonSerializable()
class Geometry {
  Location? location;

  Geometry({
    this.location,
  });
  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}
