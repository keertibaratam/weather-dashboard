import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _require {
    if (_prefs == null) {
      throw StateError(
        'SharedPrefsService has not been initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  String? getString(String key) => _require.getString(key);

  Future<bool> setString(String key, String value) =>
      _require.setString(key, value);

  List<String>? getStringList(String key) => _require.getStringList(key);

  Future<bool> setStringList(String key, List<String> value) =>
      _require.setStringList(key, value);

  int? getInt(String key) => _require.getInt(key);

  Future<bool> setInt(String key, int value) => _require.setInt(key, value);

  bool? getBool(String key) => _require.getBool(key);

  Future<bool> setBool(String key, bool value) =>
      _require.setBool(key, value);

  Future<bool> remove(String key) => _require.remove(key);

  bool containsKey(String key) => _require.containsKey(key);
}
