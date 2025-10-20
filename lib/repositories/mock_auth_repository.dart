import '../models/user.dart';
import '../services/storage_service.dart';

class MockAuthRepository {
  final StorageService _storageService;

  MockAuthRepository({
    required StorageService storageService,
  }) : _storageService = storageService;

  Future<RegisteredUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'teste@existe.com') {
      throw Exception('E-mail já registrado');
    }

    const mockToken = 'mock_jwt_token_12345';
    
    await _storageService.saveToken(mockToken);
    await _storageService.saveUserInfo(name, email);

    return RegisteredUser(
      name: name,
      tokens: const AuthTokens(accessToken: mockToken),
    );
  }

  Future<RegisteredUser> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email != 'teste@email.com' || password != '123456') {
      throw Exception('E-mail e/ou senha inválidos');
    }

    const mockToken = 'mock_jwt_token_12345';
    const mockName = 'Usuário Teste';
    
    await _storageService.saveToken(mockToken);
    await _storageService.saveUserInfo(mockName, email);

    return const RegisteredUser(
      name: mockName,
      tokens: AuthTokens(accessToken: mockToken),
    );
  }

  Future<void> logout() async {
    await _storageService.clearAll();
  }

  Future<bool> isAuthenticated() async {
    return await _storageService.hasToken();
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