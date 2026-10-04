import '../../../location/domain/entities/location.dart';
import '../entities/favorite_location.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteLocation>> getFavorites();

  Future<void> addFavorite(LocationEntity location);

  Future<void> removeFavorite(String locationId);

  Future<bool> isFavorite(String locationId);
}
