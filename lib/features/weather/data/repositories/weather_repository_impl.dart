import 'package:weatherly/core/error/failures.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';
import 'package:weatherly/features/weather/domain/entities/weather.dart';
import 'package:weatherly/features/weather/domain/repositories/weather_repository.dart';
import '../datasources/weather_local_ds.dart';
import '../datasources/weather_remote_ds.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDatasource _remote;
  final WeatherLocalDatasource _local;
  WeatherRepositoryImpl(this._remote, this._local);

  @override
  Future<(Weather, Failure?)> getWeather(LocationEntity location) async {
    try {
      final weather = await _remote.fetchForecast(location);
      try {
        await _local.cacheWeather(weather);
      } catch (_) {
        // Swallow cache write errors: live data is returned regardless.
      }
      return (weather, null);
    } catch (e) {
      final failure = FailureMapper.fromException(e);
      try {
        final cached = await _local.getCached(location);
        if (cached != null) return (cached.withCacheFlagSet, failure);
      } catch (_) {
        // Cache fallback failed too; surface the primary failure below.
      }
      throw failure;
    }
  }
}
