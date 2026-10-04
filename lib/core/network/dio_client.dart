import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  final String baseUrl;
  final List<Interceptor>? interceptors;

  DioClient({
    required this.baseUrl,
    this.interceptors,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Accept': 'application/json',
        },
        queryParameters: const <String, dynamic>{},
      ),
    );

    if (interceptors != null && interceptors!.isNotEmpty) {
      _dio.interceptors.addAll(interceptors!);
    }
  }

  late final Dio _dio;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
