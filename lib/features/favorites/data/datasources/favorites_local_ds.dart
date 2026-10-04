import 'dart:convert';
import 'package:weatherly/core/constants/app_constants.dart';
import 'package:weatherly/core/storage/shared_prefs_service.dart';
import 'package:weatherly/features/favorites/domain/entities/favorite_location.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';

class FavoritesLocalDatasource {
  final SharedPrefsService _sp;
  FavoritesLocalDatasource(this._sp);

  Future<List<FavoriteLocation>> getAll() async {
    final raw = _sp.getStringList(AppConstants.spFavoritesKey);
    if (raw == null || raw.isEmpty) return <FavoriteLocation>[];
    final out = <FavoriteLocation>[];
    for (final s in raw) {
      try {
        out.add(FavoriteLocation.fromJson(jsonDecode(s) as Map<String, dynamic>));
      } catch (_) {}
    }
    return out;
  }

  Future<void> setAll(List<FavoriteLocation> list) async {
    final raw = list.map((f) => jsonEncode(f.toJson())).toList(growable: false);
    await _sp.setStringList(AppConstants.spFavoritesKey, raw);
  }

  Future<void> add(LocationEntity loc) async {
    final list = await getAll();
    if (list.any((f) => f.id == loc.id)) return;
    list.insert(0, FavoriteLocation(location: loc, favoritedAt: DateTime.now()));
    await setAll(list);
  }

  Future<void> remove(String id) async {
    final list = await getAll();
    list.removeWhere((f) => f.id == id);
    await setAll(list);
  }

  Future<bool> exists(String id) async {
    final list = await getAll();
    return list.any((f) => f.id == id);
  }
}
