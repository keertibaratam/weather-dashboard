import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/constants/app_constants.dart';
import 'package:weatherly/core/error/failures.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';
import 'package:weatherly/features/weather/data/providers.dart';
import 'package:weatherly/features/weather/domain/entities/weather.dart';

class WeatherFetchResult {
  final Weather weather;
  final Failure? staleReason;
  const WeatherFetchResult(this.weather, [this.staleReason]);
}

class WeatherNotifier extends AsyncNotifier<WeatherFetchResult?> {
  @override
  FutureOr<WeatherFetchResult?> build() async {
    final loc = ref.watch(selectedLocationProvider);
    if (loc == null) return null;
    return _fetch(loc);
  }

  Future<WeatherFetchResult> _fetch(LocationEntity loc) async {
    final repo = ref.read(weatherRepositoryProvider);
    try {
      final (w, f) = await repo.getWeather(loc);
      return WeatherFetchResult(w, f);
    } on Failure catch (f) {
      state = AsyncValue.error(f, StackTrace.current);
      rethrow;
    }
  }

  Future<void> refresh() async {
    final loc = ref.read(selectedLocationProvider);
    if (loc == null) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => _fetch(loc));
  }
}

final weatherNotifierProvider =
    AsyncNotifierProvider<WeatherNotifier, WeatherFetchResult?>(WeatherNotifier.new);

class SelectedLocationNotifier extends Notifier<LocationEntity?> {
  @override
  LocationEntity? build() => const LocationEntity(
        id: 'default_nyc',
        name: AppConstants.defaultCityName,
        region: AppConstants.defaultRegion,
        country: AppConstants.defaultCountry,
        latitude: AppConstants.defaultLatitude,
        longitude: AppConstants.defaultLongitude,
      );

  void set(LocationEntity l) => state = l;
}

final selectedLocationProvider =
    NotifierProvider<SelectedLocationNotifier, LocationEntity?>(SelectedLocationNotifier.new);
