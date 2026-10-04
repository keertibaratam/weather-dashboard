import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/providers.dart';
import 'package:weatherly/features/location/data/datasources/geocoding_remote_ds.dart';
import 'package:weatherly/features/location/data/repositories/location_repository_impl.dart';
import 'package:weatherly/features/location/domain/repositories/location_repository.dart';

final geocodingRemoteDatasourceProvider = Provider<GeocodingRemoteDatasource>((ref) {
  return GeocodingRemoteDatasource(ref.watch(geocodingDioProvider));
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl(ref.watch(geocodingRemoteDatasourceProvider));
});
