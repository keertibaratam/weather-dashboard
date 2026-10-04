import 'package:dio/dio.dart';
import 'package:weatherly/core/constants/app_constants.dart';
import 'package:weatherly/core/error/exceptions.dart';
import 'package:weatherly/core/network/dio_client.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';
import '../mappers/location_mapper.dart';

class GeocodingRemoteDatasource {
  final DioClient _client;
  GeocodingRemoteDatasource(this._client);

  Future<List<LocationEntity>> search(String query) async {
    try {
      final resp = await _client.get<Map<String, dynamic>>(
        '/search',
        queryParameters: <String, dynamic>{
          'name': query,
          'count': AppConstants.maxSearchResults,
          'language': 'en',
          'format': 'json',
        },
      );
      final data = resp.data;
      if (data == null) throw const ApiServerException('Empty response');
      return LocationMapper.fromGeocodingJson(data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const TimeoutServerException();
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        throw NetworkServerException(e.message ?? 'Network error');
      }
      rethrow;
    }
  }
}
