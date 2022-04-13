// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharedPref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedPref _$SharedPrefFromJson(Map<String, dynamic> json) => SharedPref(
      short_name: json['short_name'] as String?,
      shortForecast: json['shortForecast'] as String?,
      icon: json['icon'] as String?,
      temperature: json['temperature'] as String?,
      forecastHourlyUrl: json['forecastHourlyUrl'] as String?,
      forecastUrl: json['forecastUrl'] as String?,
      isDaytime: json['isDaytime'] as bool?,
    );

Map<String, dynamic> _$SharedPrefToJson(SharedPref instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'short_name': instance.short_name,
      'shortForecast': instance.shortForecast,
      'temperature': instance.temperature,
      'forecastHourlyUrl': instance.forecastHourlyUrl,
      'forecastUrl': instance.forecastUrl,
      'isDaytime': instance.isDaytime,
    };
