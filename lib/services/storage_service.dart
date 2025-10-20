import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'access_token';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  StorageService({
    FlutterSecureStorage? secureStorage,
    required SharedPreferences prefs,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _prefs = prefs;

  // Token methods (secure storage)
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // User info methods (shared preferences)
  Future<void> saveUserInfo(String name, String email) async {
    await _prefs.setString(_userNameKey, name);
    await _prefs.setString(_userEmailKey, email);
  }

  String? getUserName() {
    return _prefs.getString(_userNameKey);
  }

  String? getUserEmail() {
    return _prefs.getString(_userEmailKey);
  }

  Future<void> deleteUserInfo() async {
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_userEmailKey);
  }

  Future<void> clearAll() async {
    await deleteToken();
    await deleteUserInfo();
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}