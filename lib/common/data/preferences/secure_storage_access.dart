import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageAccess {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> set(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> get(String key) async {
    return await _secureStorage.read(key: key);
  }
}
