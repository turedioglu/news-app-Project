import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_secure_storage/get_secure_storage.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._init();

  GetSecureStorage? _preferences;
  static CacheManager get instance => _instance;

  CacheManager._init() {
    GetSecureStorage.init();
    GetSecureStorage box = GetSecureStorage(
      password: dotenv.get('STORAGE_PASS'),
    );
    _preferences = box;
  }

  Future<void> setValue(String key, dynamic value) async {
    await _preferences?.write(key, value);
  }

  dynamic getValue(String key) => _preferences?.read(key);

  Future<void> clearKey(String key) async {
    await _preferences?.remove(key.toString());
  }

  Future<void> clearAll() async {
    await _preferences?.erase();
  }
}
