class WeatherAPI {
  late var lat;
  late var lon;
  late String timezone;
  late var timezoneOffset;
  late Current current;
  late List<Hourly> hourly;
  late List<Daily> daily;

  WeatherAPI(
      {required this.lat,
      required this.lon,
      required this.timezone,
      required this.timezoneOffset,
      required this.current,
      required this.hourly,
      required this.daily});

  WeatherAPI.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
    timezone = json['timezone'];
    timezoneOffset = json['timezone_offset'];
    current = (json['current'] != null ? Current.fromJson(json['current']) : null)!;
    if (json['hourly'] != null) {
      hourly = <Hourly>[];
      json['hourly'].forEach((v) {
        hourly.add(Hourly.fromJson(v));
      });
    }
    if (json['daily'] != null) {
      daily = <Daily>[];
      json['daily'].forEach((v) {
        daily.add(Daily.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    data['timezone'] = timezone;
    data['timezone_offset'] = timezoneOffset;
    data['current'] = current.toJson();
    data['hourly'] = hourly.map((v) => v.toJson()).toList();
    data['daily'] = daily.map((v) => v.toJson()).toList();
    return data;
  }
}

class Current {
  late var dt;
  late var sunrise;
  late var sunset;
  late var temp;
  late var feelsLike;
  late var pressure;
  late var humidity;
  late var dewPoint;
  late var uvi;
  late var clouds;
  late var visibility;
  late var windSpeed;
  late var windDeg;

  late List<Weather> weather;

  Current(
      {required this.dt,
      required this.sunrise,
      required this.sunset,
      required this.temp,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.dewPoint,
      required this.uvi,
      required this.clouds,
      required this.visibility,
      required this.windSpeed,
      required this.windDeg,
      required this.weather});

  Current.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    temp = json['temp'];
    feelsLike = json['feels_like'];
    pressure = json['pressure'];
    humidity = json['humidity'];
    dewPoint = json['dew_point'];
    uvi = json['uvi'];
    clouds = json['clouds'];
    visibility = json['visibility'];
    windSpeed = json['wind_speed'];
    windDeg = json['wind_deg'];
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather.add(Weather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['dew_point'] = dewPoint;
    data['uvi'] = uvi;
    data['clouds'] = clouds;
    data['visibility'] = visibility;
    data['wind_speed'] = windSpeed;
    data['wind_deg'] = windDeg;
    data['weather'] = weather.map((v) => v.toJson()).toList();
    return data;
  }
}

class Weather {
  late var id;
  late String main;
  late String description;
  late String icon;

  Weather({required this.id, required this.main, required this.description, required this.icon});

  Weather.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['main'] = main;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }
}

class Hourly {
  late var dt;
  late var temp;
  late var feelsLike;
  late var pressure;
  late var humidity;
  late var dewPoint;
  late var uvi;
  late var clouds;
  late var visibility;
  late var windSpeed;
  late var windDeg;
  late var windGust;
  late var pop;

  late List<Weather> weather;

  Hourly(
      {required this.dt,
      required this.temp,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.dewPoint,
      required this.uvi,
      required this.clouds,
      required this.visibility,
      required this.windSpeed,
      required this.windDeg,
      required this.windGust,
      required this.weather,
      required this.pop});

  Hourly.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    temp = json['temp'];
    feelsLike = json['feels_like'];
    pressure = json['pressure'];
    humidity = json['humidity'];
    dewPoint = json['dew_point'];
    uvi = json['uvi'];
    clouds = json['clouds'];
    visibility = json['visibility'];
    windSpeed = json['wind_speed'];
    windDeg = json['wind_deg'];
    windGust = json['wind_gust'];
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather.add(Weather.fromJson(v));
      });
    }
    pop = json['pop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['dew_point'] = dewPoint;
    data['uvi'] = uvi;
    data['clouds'] = clouds;
    data['visibility'] = visibility;
    data['wind_speed'] = windSpeed;
    data['wind_deg'] = windDeg;
    data['wind_gust'] = windGust;
    data['weather'] = weather.map((v) => v.toJson()).toList();
    data['pop'] = pop;
    return data;
  }
}

class Daily {
  late var dt;
  late var sunrise;
  late var sunset;
  late var moonrise;
  late var moonset;
  late var moonPhase;
  late Temp temp;
  late FeelsLike feelsLike;
  late var pressure;
  late var humidity;
  late var dewPoint;
  late var windSpeed;
  late var windDeg;
  late var windGust;
  late List<Weather> weather;
  late var clouds;
  late var pop;
  late var uvi;
  late var rain;

  Daily(
      {required this.dt,
      required this.sunrise,
      required this.sunset,
      required this.moonrise,
      required this.moonset,
      required this.moonPhase,
      required this.temp,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.dewPoint,
      required this.windSpeed,
      required this.windDeg,
      required this.windGust,
      required this.weather,
      required this.clouds,
      required this.pop,
      required this.uvi,
      required this.rain});

  Daily.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    moonrise = json['moonrise'];
    moonset = json['moonset'];
    moonPhase = json['moon_phase'];
    temp = (json['temp'] != null ? Temp.fromJson(json['temp']) : null)!;
    if (json['feels_like'] != null) {
      feelsLike = FeelsLike.fromJson(json['feels_like']);
    }
    pressure = json['pressure'];
    humidity = json['humidity'];
    dewPoint = json['dew_point'];
    windSpeed = json['wind_speed'];
    windDeg = json['wind_deg'];
    windGust = json['wind_gust'];
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather.add(Weather.fromJson(v));
      });
    }
    clouds = json['clouds'];
    pop = json['pop'];
    uvi = json['uvi'];
    rain = json['rain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['moonrise'] = moonrise;
    data['moonset'] = moonset;
    data['moon_phase'] = moonPhase;
    data['temp'] = temp.toJson();
    data['feels_like'] = feelsLike.toJson();
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['dew_point'] = dewPoint;
    data['wind_speed'] = windSpeed;
    data['wind_deg'] = windDeg;
    data['wind_gust'] = windGust;
    data['weather'] = weather.map((v) => v.toJson()).toList();
    data['clouds'] = clouds;
    data['pop'] = pop;
    data['uvi'] = uvi;
    data['rain'] = rain;
    return data;
  }
}

class Temp {
  late var day;
  late var min;
  late var max;
  late var night;
  late var eve;
  late var morn;

  Temp({required this.day, required this.min, required this.max, required this.night, required this.eve, required this.morn});

  Temp.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    min = json['min'];
    max = json['max'];
    night = json['night'];
    eve = json['eve'];
    morn = json['morn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['min'] = min;
    data['max'] = max;
    data['night'] = night;
    data['eve'] = eve;
    data['morn'] = morn;
    return data;
  }
}

class FeelsLike {
  late var day;
  late var night;
  late var eve;
  late var morn;

  FeelsLike({required this.day, required this.night, required this.eve, required this.morn});

  FeelsLike.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    night = json['night'];
    eve = json['eve'];
    morn = json['morn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['night'] = night;
    data['eve'] = eve;
    data['morn'] = morn;
    return data;
  }
}
