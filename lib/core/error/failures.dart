import 'package:dio/dio.dart';
import 'exceptions.dart';

sealed class Failure {
  final String message;

  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out. Please try again.']);
}

class ApiFailure extends Failure {
  final int? statusCode;

  const ApiFailure(super.message, [this.statusCode]);
}

class LocationNotFoundFailure extends Failure {
  final String query;

  LocationNotFoundFailure(this.query)
      : super('No results found for "$query"');
}

class EmptySearchFailure extends Failure {
  const EmptySearchFailure() : super('Start typing to search for a city');
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load cached data']);
}

class NoCacheFailure extends Failure {
  final String? fallbackHint;

  const NoCacheFailure({
    String message =
        'No cached data available. Connect to the internet to load weather.',
    this.fallbackHint,
  }) : super(message);
}

class UnknownFailure extends Failure {
  final Object? error;
  final StackTrace? stackTrace;

  const UnknownFailure(
    super.message, {
    this.error,
    this.stackTrace,
  });
}

abstract final class FailureMapper {
  static Failure fromException(Object e) {
    switch (e) {
      case DioException():
        return _mapDioException(e);
      case ServerException():
        return _mapServerException(e);
      case CacheException():
        return _mapCacheException(e);
      case LocationNotFoundException():
        return LocationNotFoundFailure(e.query);
      default:
        return UnknownFailure(
          'Something went wrong. Please try again.',
          error: e,
        );
    }
  }

  static Failure _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutFailure();
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return NetworkFailure(e.message?.isNotEmpty == true
            ? e.message!
            : 'Network error. Check your connection.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        String message = 'API error';
        if (data is Map<String, dynamic> && data['reason'] is String) {
          message = data['reason'] as String;
        } else if (data is Map && data['error'] is String) {
          message = data['error'] as String;
        } else if (statusCode != null) {
          message = _httpStatusMessage(statusCode);
        }
        return ApiFailure(message, statusCode);
      case DioExceptionType.cancel:
        return const UnknownFailure('Request was cancelled');
      case DioExceptionType.unknown:
        return NetworkFailure(
          e.message?.isNotEmpty == true
              ? e.message!
              : 'Unexpected network error',
        );
    }
  }

  static Failure _mapServerException(ServerException e) {
    if (e is TimeoutServerException) return const TimeoutFailure();
    if (e is NetworkServerException) return NetworkFailure(e.message);
    return ApiFailure(e.message, e.statusCode);
  }

  static Failure _mapCacheException(CacheException e) {
    if (e is NoCacheException) return const NoCacheFailure();
    return const CacheFailure();
  }

  static String _httpStatusMessage(int statusCode) {
    return switch (statusCode) {
      400 => 'Bad request. Please try again.',
      401 => 'Unauthorized request.',
      403 => 'Access forbidden.',
      404 => 'Resource not found.',
      429 => 'Too many requests. Please slow down.',
      >= 500 => 'Server error. Please try again later.',
      _ => 'Received an invalid response ($statusCode).',
    };
  }
}
