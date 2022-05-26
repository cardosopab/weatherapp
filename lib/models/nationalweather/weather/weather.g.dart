// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      id: (json['id'] as num).toDouble(),
    )..weather = json['weather'] == null
        ? null
        : Weather.fromJson(json['weather'] as Map<String, dynamic>);

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
      'id': instance.id,
      'weather': instance.weather,
    };
