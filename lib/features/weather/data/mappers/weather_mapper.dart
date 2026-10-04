import 'package:weatherly/features/weather/domain/entities/weather.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';
import '../../domain/entities/weather_condition.dart';

abstract final class WeatherMapper {
  static CurrentWeather currentFromJson(Map<String, dynamic> c, List<String> times, DateTime now) {
    final temp = (c['temperature_2m'] as num?)?.toDouble() ?? 0.0;
    final feels = (c['apparent_temperature'] as num?)?.toDouble() ?? temp;
    final humid = (c['relative_humidity_2m'] as num?)?.toInt() ?? 0;
    final code = (c['weather_code'] as num?)?.toInt() ?? 0;
    final wind = (c['wind_speed_10m'] as num?)?.toDouble() ?? 0.0;
    final windDir = (c['wind_direction_10m'] as num?)?.toInt() ?? 0;
    final precip = (c['precipitation'] as num?)?.toDouble() ?? 0.0;
    final cond = WeatherCondition.fromWmoCode(code);
    final iso = c['time'] is String ? DateTime.parse(c['time'] as String).toLocal() : now;
    final isDay = (c['is_day'] as num?)?.toInt() == 1;
    return CurrentWeather(temperatureCelsius: temp, feelsLikeCelsius: feels, humidityPercent: humid, condition: cond, weatherCode: code, windSpeedKmh: wind, windDirectionDegrees: windDir, precipitationMm: precip, time: iso, isDay: isDay);
  }

  static List<HourlyWeather> hourlyFromJson(Map<String, dynamic> h) {
    final times = (h['time'] as List<dynamic>? ?? <dynamic>[]).cast<String>();
    final temps = (h['temperature_2m'] as List? ?? []).cast<num>();
    final feels = (h['apparent_temperature'] as List? ?? []).cast<num>();
    final codes = (h['weather_code'] as List? ?? []).cast<num>();
    final pops = (h['precipitation_probability'] as List? ?? []).cast<num>();
    final n = times.length;
    final out = <HourlyWeather>[];
    for (var i = 0; i < n; i++) {
      out.add(HourlyWeather(time: DateTime.parse(times[i]).toLocal(), temperatureCelsius: temps[i].toDouble(), feelsLikeCelsius: i < feels.length ? feels[i].toDouble() : temps[i].toDouble(), condition: WeatherCondition.fromWmoCode(codes[i].toInt()), weatherCode: codes[i].toInt(), precipitationProbabilityPercent: i < pops.length ? pops[i].toInt() : 0));
    }
    return out;
  }

  static List<DailyWeather> dailyFromJson(Map<String, dynamic> d) {
    final dates = (d['time'] as List<dynamic>? ?? <dynamic>[]).cast<String>();
    final codes = (d['weather_code'] as List? ?? []).cast<num>();
    final maxs = (d['temperature_2m_max'] as List? ?? []).cast<num>();
    final mins = (d['temperature_2m_min'] as List? ?? []).cast<num>();
    final srs = (d['sunrise'] as List<dynamic>? ?? <dynamic>[]).cast<String>();
    final sss = (d['sunset'] as List<dynamic>? ?? <dynamic>[]).cast<String>();
    final pops = (d['precipitation_probability_max'] as List? ?? []).cast<num>();
    final n = dates.length;
    final out = <DailyWeather>[];
    for (var i = 0; i < n; i++) {
      out.add(DailyWeather(date: DateTime.parse(dates[i]), condition: WeatherCondition.fromWmoCode(codes[i].toInt()), weatherCode: codes[i].toInt(), maxTempCelsius: maxs[i].toDouble(), minTempCelsius: mins[i].toDouble(), sunrise: DateTime.parse(srs[i]).toLocal(), sunset: DateTime.parse(sss[i]).toLocal(), precipitationProbabilityMaxPercent: i < pops.length ? pops[i].toInt() : 0));
    }
    return out;
  }

  static Weather weatherFromApi(Map<String, dynamic> json, LocationEntity loc, DateTime fetchedAt) {
    return Weather(location: loc, current: currentFromJson(json['current'] as Map<String, dynamic>? ?? {}, const <String>[], fetchedAt), hourly: hourlyFromJson(json['hourly'] as Map<String, dynamic>? ?? {}), daily: dailyFromJson(json['daily'] as Map<String, dynamic>? ?? {}), timezone: json['timezone'] as String?, fetchedAt: fetchedAt);
  }

  static Weather fromCacheJson(Map<String, dynamic> j, LocationEntity loc) => Weather(location: loc, current: currentFromJson(Map<String, dynamic>.from(j['current'] as Map? ?? {}), const <String>[], DateTime.fromMillisecondsSinceEpoch(j['current_time'] as int? ?? 0)), hourly: hourlyFromJson(Map<String, dynamic>.from(j['hourly'] as Map? ?? {})), daily: dailyFromJson(Map<String, dynamic>.from(j['daily'] as Map? ?? {})), timezone: j['timezone'] as String?, fetchedAt: DateTime.fromMillisecondsSinceEpoch(j['fetchedAt'] as int? ?? 0), isFromCache: true);

  static Map<String, dynamic> toCacheJson(Weather w) {
    return {'current': {'temperature_2m': w.current.temperatureCelsius, 'apparent_temperature': w.current.feelsLikeCelsius, 'relative_humidity_2m': w.current.humidityPercent, 'weather_code': w.current.weatherCode, 'wind_speed_10m': w.current.windSpeedKmh, 'wind_direction_10m': w.current.windDirectionDegrees, 'precipitation': w.current.precipitationMm, 'time': w.current.time.toIso8601String(), 'is_day': w.current.isDay ? 1 : 0}, 'hourly': _hourlyToCache(w.hourly), 'daily': _dailyToCache(w.daily), 'timezone': w.timezone, 'fetchedAt': w.fetchedAt.millisecondsSinceEpoch, 'location': w.location.toJson()};
  }

  static Map<String, dynamic> _hourlyToCache(List<HourlyWeather> l) {
    return {'time': l.map((e) => e.time.toIso8601String()).toList(growable: false), 'temperature_2m': l.map((e) => e.temperatureCelsius).toList(growable: false), 'apparent_temperature': l.map((e) => e.feelsLikeCelsius).toList(growable: false), 'weather_code': l.map((e) => e.weatherCode).toList(growable: false), 'precipitation_probability': l.map((e) => e.precipitationProbabilityPercent).toList(growable: false)};
  }

  static Map<String, dynamic> _dailyToCache(List<DailyWeather> l) {
    return {'time': l.map((e) => e.date.toIso8601String()).toList(growable: false), 'weather_code': l.map((e) => e.weatherCode).toList(growable: false), 'temperature_2m_max': l.map((e) => e.maxTempCelsius).toList(growable: false), 'temperature_2m_min': l.map((e) => e.minTempCelsius).toList(growable: false), 'sunrise': l.map((e) => e.sunrise.toIso8601String()).toList(growable: false), 'sunset': l.map((e) => e.sunset.toIso8601String()).toList(growable: false), 'precipitation_probability_max': l.map((e) => e.precipitationProbabilityMaxPercent).toList(growable: false)};
  }
}
