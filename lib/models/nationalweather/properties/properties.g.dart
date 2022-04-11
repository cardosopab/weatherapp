// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Properties _$PropertiesFromJson(Map<String, dynamic> json) => Properties(
      forecastGenerator: json['forecastGenerator'] as String?,
      updateTime: json['updateTime'] as String?,
      periods: (json['periods'] as List<dynamic>?)
          ?.map((e) => Periods.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PropertiesToJson(Properties instance) =>
    <String, dynamic>{
      'forecastGenerator': instance.forecastGenerator,
      'updateTime': instance.updateTime,
      'periods': instance.periods,
    };
