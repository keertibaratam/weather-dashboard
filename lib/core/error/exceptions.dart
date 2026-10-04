sealed class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, [this.statusCode]);

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class TimeoutServerException extends ServerException {
  const TimeoutServerException() : super('Request timed out');
}

class NetworkServerException extends ServerException {
  const NetworkServerException(super.message);
}

class ApiServerException extends ServerException {
  const ApiServerException(super.message, [super.statusCode]);
}

class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache failure']);

  @override
  String toString() => 'CacheException: $message';
}

class NoCacheException extends CacheException {
  const NoCacheException() : super('No cached data available');
}

class LocationNotFoundException implements Exception {
  final String query;

  const LocationNotFoundException(this.query);

  @override
  String toString() => 'LocationNotFoundException: "$query" not found';
}
