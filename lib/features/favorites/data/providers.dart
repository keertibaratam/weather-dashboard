import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/providers.dart';
import 'package:weatherly/features/favorites/data/datasources/favorites_local_ds.dart';
import 'package:weatherly/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:weatherly/features/favorites/domain/repositories/favorites_repository.dart';

final favoritesLocalDatasourceProvider = Provider<FavoritesLocalDatasource>((ref) {
  return FavoritesLocalDatasource(ref.watch(sharedPrefsServiceProvider));
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(ref.watch(favoritesLocalDatasourceProvider));
});
