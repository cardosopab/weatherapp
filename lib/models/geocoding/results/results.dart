import 'package:json_annotation/json_annotation.dart';
import 'package:national_weather/models/geocoding/geometry/geometry.dart';

part 'results.g.dart';

@JsonSerializable()
class Results {
  String? status;
  Geometry? geometry;
  // List<Address>? address_components;
  String? formatted_address;

  Results({
    this.geometry,
    this.status,
    // this.address_components,
    this.formatted_address,
  });
  factory Results.fromJson(Map<String, dynamic> json) =>
      _$ResultsFromJson(json);
  Map<String, dynamic> toJson() => _$ResultsToJson(this);
}
