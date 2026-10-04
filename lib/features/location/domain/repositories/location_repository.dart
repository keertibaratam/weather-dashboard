import '../../../../core/error/failures.dart';
import '../entities/location.dart';

abstract class LocationRepository {
  Future<(List<LocationEntity>, Failure?)> searchLocations(String query);
}
