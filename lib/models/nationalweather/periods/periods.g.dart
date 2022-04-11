// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'periods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Periods _$PeriodsFromJson(Map<String, dynamic> json) => Periods(
      name: json['name'] as String?,
      isDaytime: json['isDaytime'] as bool?,
      temperature: json['temperature'] as int?,
      temperatureUnit: json['temperatureUnit'] as String?,
      icon: json['icon'] as String?,
      shortForecast: json['shortForecast'] as String?,
      detailedForecast: json['detailedForecast'] as String?,
    )
      ..startTime = json['startTime'] as String?
      ..endTime = json['endTime'] as String?;

Map<String, dynamic> _$PeriodsToJson(Periods instance) => <String, dynamic>{
      'name': instance.name,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isDaytime': instance.isDaytime,
      'temperature': instance.temperature,
      'temperatureUnit': instance.temperatureUnit,
      'icon': instance.icon,
      'shortForecast': instance.shortForecast,
      'detailedForecast': instance.detailedForecast,
    };
