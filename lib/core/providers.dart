import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/constants/app_constants.dart';
import 'package:weatherly/core/network/dio_client.dart';
import 'package:weatherly/core/storage/hive_service.dart';
import 'package:weatherly/core/storage/shared_prefs_service.dart';

final sharedPrefsServiceProvider = Provider<SharedPrefsService>((ref) {
  throw UnimplementedError('Initialize SharedPrefsService in main() and override this provider.');
});

final hiveServiceProvider = Provider<HiveService>((ref) {
  throw UnimplementedError('Initialize HiveService in main() and override this provider.');
});

final forecastDioProvider = Provider<DioClient>((ref) {
  return DioClient(baseUrl: AppConstants.openMeteoForecastBaseUrl);
});

final geocodingDioProvider = Provider<DioClient>((ref) {
  return DioClient(baseUrl: AppConstants.openMeteoGeocodingBaseUrl);
});
