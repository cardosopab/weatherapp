// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hourly _$HourlyFromJson(Map<String, dynamic> json) => Hourly(
      dt: (json['dt'] as num).toDouble(),
      temp: (json['temp'] as num).toDouble(),
      feels_like: (json['feels_like'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      dew_point: (json['dew_point'] as num).toDouble(),
      uvi: (json['uvi'] as num).toDouble(),
      clouds: (json['clouds'] as num).toDouble(),
      visibility: (json['visibility'] as num).toDouble(),
      wind_speed: (json['wind_speed'] as num).toDouble(),
      wind_deg: (json['wind_deg'] as num).toDouble(),
      wind_gust: (json['wind_gust'] as num).toDouble(),
      pop: (json['pop'] as num).toDouble(),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HourlyToJson(Hourly instance) => <String, dynamic>{
      'uvi': instance.uvi,
      'wind_gust': instance.wind_gust,
      'wind_speed': instance.wind_speed,
      'dew_point': instance.dew_point,
      'feels_like': instance.feels_like,
      'temp': instance.temp,
      'pop': instance.pop,
      'dt': instance.dt,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
      'clouds': instance.clouds,
      'visibility': instance.visibility,
      'wind_deg': instance.wind_deg,
      'weather': instance.weather,
    };
