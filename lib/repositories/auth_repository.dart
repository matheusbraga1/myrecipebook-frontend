import '../models/user.dart';
import '../services/api_client.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthRepository({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  Future<RegisteredUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post('/user', {
      'name': name,
      'email': email,
      'password': password,
    });

    final user = RegisteredUser.fromJson(response);
    
    await _storageService.saveToken(user.tokens.accessToken);
    await _storageService.saveUserInfo(user.name, email);
    _apiClient.setAccessToken(user.tokens.accessToken);

    return user;
  }

  Future<RegisteredUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post('/login', {
      'email': email,
      'password': password,
    });

    final user = RegisteredUser.fromJson(response);
    
    await _storageService.saveToken(user.tokens.accessToken);
    await _storageService.saveUserInfo(user.name, email);
    _apiClient.setAccessToken(user.tokens.accessToken);

    return user;
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    _apiClient.setAccessToken(null);
  }

  Future<bool> isAuthenticated() async {
    final hasToken = await _storageService.hasToken();
    if (hasToken) {
      final token = await _storageService.getToken();
      _apiClient.setAccessToken(token);
    }
    return hasToken;
  }

  Future<User?> getCachedUser() async {
    final name = _storageService.getUserName();
    final email = _storageService.getUserEmail();

    if (name != null && email != null) {
      return User(name: name, email: email);
    }
    return null;
  }
}