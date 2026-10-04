import '../../../location/domain/entities/location.dart';

class FavoriteLocation {
  final LocationEntity location;
  final DateTime favoritedAt;

  const FavoriteLocation({
    required this.location,
    required this.favoritedAt,
  });

  String get id => location.id;

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'favoritedAt': favoritedAt.toIso8601String(),
    };
  }

  factory FavoriteLocation.fromJson(Map<String, dynamic> json) {
    return FavoriteLocation(
      location: LocationEntity.fromJson(
        Map<String, dynamic>.from(json['location'] as Map),
      ),
      favoritedAt: DateTime.parse(json['favoritedAt'] as String),
    );
  }

  FavoriteLocation copyWith({
    LocationEntity? location,
    DateTime? favoritedAt,
  }) {
    return FavoriteLocation(
      location: location ?? this.location,
      favoritedAt: favoritedAt ?? this.favoritedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteLocation &&
          runtimeType == other.runtimeType &&
          location == other.location;

  @override
  int get hashCode => location.hashCode;
}
