import 'package:weatherly/features/favorites/domain/entities/favorite_location.dart';
import 'package:weatherly/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';
import '../datasources/favorites_local_ds.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDatasource _ds;
  FavoritesRepositoryImpl(this._ds);

  @override
  Future<List<FavoriteLocation>> getFavorites() => _ds.getAll();

  @override
  Future<void> addFavorite(LocationEntity location) => _ds.add(location);

  @override
  Future<void> removeFavorite(String locationId) => _ds.remove(locationId);

  @override
  Future<bool> isFavorite(String locationId) => _ds.exists(locationId);
}
