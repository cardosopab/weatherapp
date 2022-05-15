// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharedPref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedPref _$SharedPrefFromJson(Map<String, dynamic> json) => SharedPref(
      icon: json['icon'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      main: json['main'] as String?,
      humidity: json['humidity'] as String?,
      temp: json['temp'] as String?,
      moon_phase: json['moon_phase'] as String?,
      isDaytime: json['isDaytime'] as bool?,
      coordinates: json['coordinates'] as String?,
      index: json['index'] as int?,
      dt: json['dt'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$SharedPrefToJson(SharedPref instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'name': instance.name,
      'description': instance.description,
      'main': instance.main,
      'humidity': instance.humidity,
      'temp': instance.temp,
      'dt': instance.dt,
      'moon_phase': instance.moon_phase,
      'coordinates': instance.coordinates,
      'timezone': instance.timezone,
      'index': instance.index,
      'isDaytime': instance.isDaytime,
    };
