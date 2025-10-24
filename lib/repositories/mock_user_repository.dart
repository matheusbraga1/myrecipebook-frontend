import '../models/user.dart';
import '../services/storage_service.dart';

class MockUserRepository {
  final StorageService _storageService;
  String _currentPassword = '123456';

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

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Verifica se a senha atual está correta
    if (currentPassword != _currentPassword) {
      throw Exception('A senha que você digitou não coincide com a senha atual');
    }

    // Verifica se a nova senha é diferente da atual
    if (newPassword == _currentPassword) {
      throw Exception('A nova senha deve ser diferente da senha atual');
    }

    // Valida tamanho da nova senha
    if (newPassword.length < 6) {
      throw Exception('A senha deve ter mais de 6 caracteres');
    }

    // Atualiza a senha
    _currentPassword = newPassword;
  }
}