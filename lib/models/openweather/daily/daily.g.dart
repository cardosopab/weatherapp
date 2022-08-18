// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Daily _$DailyFromJson(Map<String, dynamic> json) => Daily(
      dt: (json['dt'] as num).toDouble(),
      sunrise: (json['sunrise'] as num).toDouble(),
      sunset: (json['sunset'] as num).toDouble(),
      moonrise: (json['moonrise'] as num).toDouble(),
      moonset: (json['moonset'] as num).toDouble(),
      moon_phase: (json['moon_phase'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      dew_point: (json['dew_point'] as num).toDouble(),
      wind_speed: (json['wind_speed'] as num).toDouble(),
      wind_deg: (json['wind_deg'] as num).toDouble(),
      wind_gust: (json['wind_gust'] as num).toDouble(),
      clouds: (json['clouds'] as num).toDouble(),
      pop: (json['pop'] as num).toDouble(),
      uvi: (json['uvi'] as num).toDouble(),
      temp: Temp.fromJson(json['temp'] as Map<String, dynamic>),
      feels_like:
          FeelsLike.fromJson(json['feels_like'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'pop': instance.pop,
      'wind_gust': instance.wind_gust,
      'wind_speed': instance.wind_speed,
      'dew_point': instance.dew_point,
      'moon_phase': instance.moon_phase,
      'uvi': instance.uvi,
      'dt': instance.dt,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'moonrise': instance.moonrise,
      'moonset': instance.moonset,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
      'wind_deg': instance.wind_deg,
      'clouds': instance.clouds,
      'temp': instance.temp,
      'feels_like': instance.feels_like,
      'weather': instance.weather,
    };
