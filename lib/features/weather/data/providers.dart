import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/providers.dart';
import 'package:weatherly/features/weather/data/datasources/weather_local_ds.dart';
import 'package:weatherly/features/weather/data/datasources/weather_remote_ds.dart';
import 'package:weatherly/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weatherly/features/weather/domain/repositories/weather_repository.dart';

final weatherRemoteDatasourceProvider = Provider<WeatherRemoteDatasource>((ref) {
  return WeatherRemoteDatasource(ref.watch(forecastDioProvider));
});

final weatherLocalDatasourceProvider = Provider<WeatherLocalDatasource>((ref) {
  return WeatherLocalDatasource(ref.watch(hiveServiceProvider));
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(
    ref.watch(weatherRemoteDatasourceProvider),
    ref.watch(weatherLocalDatasourceProvider),
  );
});
