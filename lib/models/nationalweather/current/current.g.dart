// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Current _$CurrentFromJson(Map<String, dynamic> json) => Current(
      dt: (json['dt'] as num).toDouble(),
      sunrise: (json['sunrise'] as num).toDouble(),
      sunset: (json['sunset'] as num).toDouble(),
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
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CurrentToJson(Current instance) => <String, dynamic>{
      'dt': instance.dt,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
      'clouds': instance.clouds,
      'visibility': instance.visibility,
      'wind_deg': instance.wind_deg,
      'uvi': instance.uvi,
      'wind_speed': instance.wind_speed,
      'dew_point': instance.dew_point,
      'feels_like': instance.feels_like,
      'temp': instance.temp,
      'weather': instance.weather,
    };
