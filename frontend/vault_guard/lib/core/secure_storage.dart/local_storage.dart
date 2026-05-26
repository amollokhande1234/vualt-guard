import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String tokenKey = 'auth_token';

  static const String userIdKey = 'user_id';

  static const String emailKey = 'email';

  static const String usernameKey = 'username';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  static Future<void> saveUser({
    required String id,
    required String username,
    required String email,
  }) async {
    await _storage.write(key: userIdKey, value: id);

    await _storage.write(key: usernameKey, value: username);

    await _storage.write(key: emailKey, value: email);
  }

  static Future<void> clearStorage() async {
    await _storage.deleteAll();
  }
}
