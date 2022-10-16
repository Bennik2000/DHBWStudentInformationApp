import 'package:shared_preferences/shared_preferences.dart';

class PreferencesAccess {
  const PreferencesAccess();

  Future<void> set<T>(String key, T value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (T) {
      case bool:
        await prefs.setBool(key, value as bool);
        return;
      case String:
        await prefs.setString(key, value as String);
        return;
      case double:
        await prefs.setDouble(key, value as double);
        return;
      case int:
        await prefs.setInt(key, value as int);
        return;
      default:
        throw InvalidValueTypeException(T);
    }
  }

  Future<T?> get<T>(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (T) {
      case bool:
        return prefs.getBool(key) as T?;
      case String:
        return prefs.getString(key) as T?;
      case double:
        return prefs.getDouble(key) as T?;
      case int:
        return prefs.getInt(key) as T?;
      default:
        return null;
    }
  }
}

class InvalidValueTypeException implements Exception {
  final Type type;

  const InvalidValueTypeException(this.type);
}
