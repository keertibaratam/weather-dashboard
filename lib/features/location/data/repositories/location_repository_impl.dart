import 'package:weatherly/core/error/failures.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';
import 'package:weatherly/features/location/domain/repositories/location_repository.dart';
import '../datasources/geocoding_remote_ds.dart';

class LocationRepositoryImpl implements LocationRepository {
  final GeocodingRemoteDatasource _remote;
  LocationRepositoryImpl(this._remote);

  @override
  Future<(List<LocationEntity>, Failure?)> searchLocations(String query) async {
    final q = query.trim();
    if (q.isEmpty) return (const <LocationEntity>[], const EmptySearchFailure());
    try {
      final list = await _remote.search(q);
      if (list.isEmpty) return (const <LocationEntity>[], LocationNotFoundFailure(q));
      return (list, null);
    } catch (e) {
      return (const <LocationEntity>[], FailureMapper.fromException(e));
    }
  }
}
