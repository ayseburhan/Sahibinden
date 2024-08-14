import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Add this method to read user information
  Future<String?> readUserInfo(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> saveUserInfo(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> deleteUserInfo(String key) async {
    await _storage.delete(key: key);
  }
}
