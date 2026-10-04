import '../../../../core/error/failures.dart';
import '../../../location/domain/entities/location.dart';
import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<(Weather, Failure?)> getWeather(LocationEntity location);
}
