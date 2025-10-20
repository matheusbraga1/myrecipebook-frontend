import '../models/user.dart';
import '../services/api_client.dart';
import '../services/storage_service.dart';

class UserRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  UserRepository({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  Future<User> getProfile() async {
    final response = await _apiClient.get('/user');
    final user = User.fromJson(response);
    
    await _storageService.saveUserInfo(user.name, user.email);
    
    return user;
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    await _apiClient.put('/user', {
      'name': name,
      'email': email,
    });

    await _storageService.saveUserInfo(name, email);
  }
}