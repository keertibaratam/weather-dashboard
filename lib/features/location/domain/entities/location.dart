class LocationEntity {
  final String id;
  final String name;
  final String? region;
  final String? country;
  final double latitude;
  final double longitude;
  final String? timezone;

  const LocationEntity({
    required this.id,
    required this.name,
    this.region,
    this.country,
    required this.latitude,
    required this.longitude,
    this.timezone,
  });

  String get displayName {
    final parts = <String>[
      name,
      if (region?.isNotEmpty == true) region!,
      if (country?.isNotEmpty == true) country!,
    ];
    return parts.join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (region != null) 'region': region,
      if (country != null) 'country': country,
      'latitude': latitude,
      'longitude': longitude,
      if (timezone != null) 'timezone': timezone,
    };
  }

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      id: json['id'] as String? ??
          '${json['latitude']}_${json['longitude']}',
      name: json['name'] as String? ?? 'Unknown',
      region: json['region'] as String?,
      country: json['country'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] as String?,
    );
  }

  LocationEntity copyWith({
    String? id,
    String? name,
    String? region,
    String? country,
    double? latitude,
    double? longitude,
    String? timezone,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => Object.hash(id, latitude, longitude);
}
