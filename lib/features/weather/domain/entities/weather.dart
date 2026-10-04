import '../../../location/domain/entities/location.dart';
import 'weather_condition.dart';

class CurrentWeather {
  final double temperatureCelsius;
  final double feelsLikeCelsius;
  final int humidityPercent;
  final WeatherCondition condition;
  final int weatherCode;
  final double windSpeedKmh;
  final int windDirectionDegrees;
  final double precipitationMm;
  final DateTime time;
  final bool isDay;

  const CurrentWeather({
    required this.temperatureCelsius,
    required this.feelsLikeCelsius,
    required this.humidityPercent,
    required this.condition,
    required this.weatherCode,
    required this.windSpeedKmh,
    required this.windDirectionDegrees,
    required this.precipitationMm,
    required this.time,
    required this.isDay,
  });

  String get windDirectionLabel {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((windDirectionDegrees % 360) / 45).round() % 8;
    return directions[index];
  }
}

class HourlyWeather {
  final DateTime time;
  final double temperatureCelsius;
  final double feelsLikeCelsius;
  final WeatherCondition condition;
  final int weatherCode;
  final int precipitationProbabilityPercent;

  const HourlyWeather({
    required this.time,
    required this.temperatureCelsius,
    required this.feelsLikeCelsius,
    required this.condition,
    required this.weatherCode,
    required this.precipitationProbabilityPercent,
  });

  bool get isSameHourAsNow {
    final now = DateTime.now();
    return time.year == now.year &&
        time.month == now.month &&
        time.day == now.day &&
        time.hour == now.hour;
  }
}

class DailyWeather {
  final DateTime date;
  final WeatherCondition condition;
  final int weatherCode;
  final double maxTempCelsius;
  final double minTempCelsius;
  final DateTime sunrise;
  final DateTime sunset;
  final int precipitationProbabilityMaxPercent;

  const DailyWeather({
    required this.date,
    required this.condition,
    required this.weatherCode,
    required this.maxTempCelsius,
    required this.minTempCelsius,
    required this.sunrise,
    required this.sunset,
    required this.precipitationProbabilityMaxPercent,
  });
}

class Weather {
  final LocationEntity location;
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;
  final String? timezone;

  final DateTime fetchedAt;
  final bool isFromCache;

  const Weather({
    required this.location,
    required this.current,
    required this.hourly,
    required this.daily,
    this.timezone,
    required this.fetchedAt,
    this.isFromCache = false,
  });

  Weather get withCacheFlagSet => Weather(
        location: location,
        current: current,
        hourly: hourly,
        daily: daily,
        timezone: timezone,
        fetchedAt: fetchedAt,
        isFromCache: true,
      );

  String get cacheKey => '${location.latitude.toStringAsFixed(2)}_'
      '${location.longitude.toStringAsFixed(2)}';

  List<HourlyWeather> get next24Hours {
    final now = DateTime.now();
    // Keep entries from the start of the current hour so the in-progress hour
    // is still shown (and gets the "Now" label).
    final currentHour = DateTime(now.year, now.month, now.day, now.hour);
    return hourly.where((h) => !h.time.isBefore(currentHour)).take(24).toList();
  }

  DateTime get sunrise => daily.firstOrNull?.sunrise ?? current.time;
  DateTime get sunset => daily.firstOrNull?.sunset ?? current.time;
}
