import 'package:hive_ce/hive.dart';
import 'package:weatherly/core/error/exceptions.dart';
import 'package:weatherly/core/storage/hive_service.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';
import 'package:weatherly/features/weather/domain/entities/weather.dart';
import '../mappers/weather_mapper.dart';

class WeatherLocalDatasource {
  final HiveService _hive;
  WeatherLocalDatasource(this._hive);

  Future<void> cacheWeather(Weather weather) async {
    try {
      final box = await _hive.openWeatherBox<Map>();
      await box.put(weather.cacheKey, WeatherMapper.toCacheJson(weather));
    } catch (_) {
      throw const CacheException('Failed to write cache');
    }
  }

  Future<Weather?> getCached(LocationEntity loc) async {
    try {
      final box = await _hive.openWeatherBox<Map>();
      final key = _deriveKey(loc, box);
      if (key == null) return null;
      final raw = box.get(key);
      if (raw == null) return null;
      final map = Map<String, dynamic>.from(raw);
      final locMap = Map<String, dynamic>.from(map['location'] as Map? ?? loc.toJson());
      final resolvedLocation = LocationEntity.fromJson(locMap);
      return WeatherMapper.fromCacheJson(map, resolvedLocation);
    } on NoCacheException {
      rethrow;
    } catch (_) {
      throw const CacheException();
    }
  }

  String? _deriveKey(LocationEntity loc, Box<Map<dynamic, dynamic>> box) {
    final key = _locationKey(loc);
    if (box.containsKey(key)) return key;
    try {
      final lat = loc.latitude.toStringAsFixed(2);
      final lon = loc.longitude.toStringAsFixed(2);
      for (final k in box.keys) {
        final s = k.toString();
        final parts = s.split('_');
        if (parts.length != 2) continue;
        if (parts[0] == lat && parts[1] == lon) return s;
      }
    } catch (_) {}
    return null;
  }

  /// Same key format used by [Weather.cacheKey].
  String _locationKey(LocationEntity loc) =>
      '${loc.latitude.toStringAsFixed(2)}_${loc.longitude.toStringAsFixed(2)}';
}
