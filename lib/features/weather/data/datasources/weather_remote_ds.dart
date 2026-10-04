import 'package:dio/dio.dart';
import 'package:weatherly/core/constants/app_constants.dart';
import 'package:weatherly/core/error/exceptions.dart';
import 'package:weatherly/core/network/dio_client.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';
import 'package:weatherly/features/weather/domain/entities/weather.dart';
import '../mappers/weather_mapper.dart';

class WeatherRemoteDatasource {
  final DioClient _client;
  WeatherRemoteDatasource(this._client);

  Future<Weather> fetchForecast(LocationEntity loc) async {
    try {
      final resp = await _client.get<Map<String, dynamic>>(
        '/forecast',
        queryParameters: <String, dynamic>{
          'latitude': loc.latitude,
          'longitude': loc.longitude,
          'current': AppConstants.forecastCurrentParams.join(','),
          'hourly': AppConstants.forecastHourlyParams.join(','),
          'daily': AppConstants.forecastDailyParams.join(','),
          'timezone': 'auto',
          'wind_speed_unit': 'kmh',
          'forecast_days': 7,
        },
      );
      final data = resp.data;
      if (data == null) throw const ApiServerException('Empty forecast response');
      return WeatherMapper.weatherFromApi(data, loc, DateTime.now());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.transformTimeout) {
        throw const TimeoutServerException();
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        throw NetworkServerException(e.message ?? 'Network error');
      }
      if (e.type == DioExceptionType.badResponse) {
        throw ApiServerException(
          e.response?.statusMessage ?? 'Bad response',
          e.response?.statusCode,
        );
      }
      rethrow;
    }
  }
}
