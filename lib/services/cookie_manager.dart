import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CookieManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveCookie(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getCookie(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteCookie(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAllCookies() async {
    await _storage.deleteAll();
  }
}
