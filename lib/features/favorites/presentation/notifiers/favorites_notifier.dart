import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/features/favorites/data/providers.dart';
import 'package:weatherly/features/favorites/domain/entities/favorite_location.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';

class FavoritesNotifier extends Notifier<List<FavoriteLocation>> {
  @override
  List<FavoriteLocation> build() {
    Future.microtask(_reload);
    return const <FavoriteLocation>[];
  }

  Future<void> _reload() async {
    state = await ref.read(favoritesRepositoryProvider).getFavorites();
  }

  Future<void> toggle(LocationEntity loc) async {
    final repo = ref.read(favoritesRepositoryProvider);
    if (state.any((f) => f.id == loc.id)) {
      await repo.removeFavorite(loc.id);
    } else {
      await repo.addFavorite(loc);
    }
    await _reload();
  }

  Future<void> remove(String id) async {
    await ref.read(favoritesRepositoryProvider).removeFavorite(id);
    await _reload();
  }

  Future<void> add(LocationEntity loc) async {
    await ref.read(favoritesRepositoryProvider).addFavorite(loc);
    await _reload();
  }

  bool isFavorite(String id) => state.any((f) => f.id == id);
}

final favoritesNotifierProvider =
    NotifierProvider<FavoritesNotifier, List<FavoriteLocation>>(FavoritesNotifier.new);
