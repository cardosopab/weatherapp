import 'package:json_annotation/json_annotation.dart';
import 'package:national_weather/models/geocoding/results/results.dart';

part 'main.g.dart';

@JsonSerializable()
class Main {
  List<Results>? results;

  Main({
    this.results,
  });
  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
  Map<String, dynamic> toJson() => _$MainToJson(this);
}
