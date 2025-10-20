import '../models/user.dart';
import '../services/storage_service.dart';

class MockUserRepository {
  final StorageService _storageService;

  MockUserRepository({
    required StorageService storageService,
  }) : _storageService = storageService;

  Future<User> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final name = _storageService.getUserName() ?? 'Usuário Teste';
    final email = _storageService.getUserEmail() ?? 'teste@email.com';

    return User(name: name, email: email);
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (email == 'outro@existe.com') {
      throw Exception('E-mail já registrado');
    }

    await _storageService.saveUserInfo(name, email);
  }
}