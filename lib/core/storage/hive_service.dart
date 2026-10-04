import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/app_constants.dart';

class HiveService {
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    if (kIsWeb) {
      // The web has no real filesystem path (path_provider has no web
      // implementation); hive_ce's web backend persists to IndexedDB and
      // ignores the path.
      Hive.init('');
    } else {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
    _initialized = true;
  }

  Future<Box<T>> openWeatherBox<T>() async {
    return Hive.openBox<T>(AppConstants.weatherHiveBoxName);
  }

  Future<Box<T>> openFavoritesBox<T>() async {
    return Hive.openBox<T>(AppConstants.favoritesHiveBoxName);
  }

  Future<void> close() async {
    await Hive.close();
    _initialized = false;
  }
}
