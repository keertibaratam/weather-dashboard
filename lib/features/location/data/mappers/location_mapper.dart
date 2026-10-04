import 'package:weatherly/features/location/domain/entities/location.dart';

abstract final class LocationMapper {
  static List<LocationEntity> fromGeocodingJson(Map<String, dynamic> json) {
    final results = (json['results'] as List<dynamic>?) ?? const <dynamic>[];
    final out = <LocationEntity>[];
    for (final r in results) {
      final m = r as Map<String, dynamic>;
      final id = (m['id']?.toString()) ?? '${m['latitude']}_${m['longitude']}';
      out.add(LocationEntity(id: id, name: (m['name'] as String?) ?? 'Unknown', region: m['admin1'] as String?, country: m['country'] as String?, latitude: (m['latitude'] as num).toDouble(), longitude: (m['longitude'] as num).toDouble(), timezone: m['timezone'] as String?));
    }
    return out;
  }
}
