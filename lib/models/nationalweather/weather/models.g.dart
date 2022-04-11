// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      type: json['type'] as String?,
      properties: json['properties'] == null
          ? null
          : Properties.fromJson(json['properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
    };
