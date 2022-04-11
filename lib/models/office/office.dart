import 'package:json_annotation/json_annotation.dart';
import 'package:national_weather/models/office/properties.dart';

part 'office.g.dart';

@JsonSerializable()
class Office {
  Properties? properties;
  Office({
    this.properties,
  });
  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeToJson(this);
}
