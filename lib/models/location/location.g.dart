// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      icon: json['icon'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      main: json['main'] as String?,
      humidity: json['humidity'] as String?,
      temp: (json['temp'] as num?)?.toDouble(),
      moon_phase: json['moon_phase'] as String?,
      isDaytime: json['isDaytime'] as bool?,
      coordinates: json['coordinates'] as String?,
      dt: json['dt'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'icon': instance.icon,
      'name': instance.name,
      'description': instance.description,
      'main': instance.main,
      'humidity': instance.humidity,
      'dt': instance.dt,
      'moon_phase': instance.moon_phase,
      'coordinates': instance.coordinates,
      'timezone': instance.timezone,
      'temp': instance.temp,
      'isDaytime': instance.isDaytime,
    };
