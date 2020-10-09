import 'package:shared_preferences/shared_preferences.dart';

class PreferencesAccess {
  SharedPreferences _sharedPreferences;

  Future<void> initializeSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> set<T>(String key, T value) async {
    switch (T) {
      case bool:
        await _sharedPreferences.setBool(key, value as bool);
        return;
      case String:
        await _sharedPreferences.setString(key, value as String);
        return;
      case double:
        await _sharedPreferences.setDouble(key, value as double);
        return;
      case int:
        await _sharedPreferences.setInt(key, value as int);
        return;
    }

    throw InvalidValueTypeException(T);
  }

  T getSynchronous<T>(String key) {
    T value;

    switch (T) {
      case bool:
        value = _sharedPreferences.getBool(key) as T;
        break;
      case String:
        value = _sharedPreferences.getString(key) as T;
        break;
      case double:
        value = _sharedPreferences.getDouble(key) as T;
        break;
      case int:
        value = _sharedPreferences.getInt(key) as T;
        break;
    }

    return value;
  }

  Future<T> get<T>(String key) async {
    await _sharedPreferences.reload();

    return getSynchronous<T>(key);
  }
}

class InvalidValueTypeException implements Exception {
  final Type type;

  InvalidValueTypeException(this.type);
}
