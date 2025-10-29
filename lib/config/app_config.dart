class AppConfig {
  // ALTERE AQUI PARA MUDAR O MODO
  static const bool useMockData = true; // true = Mock | false = API Real
  
  // URL da API (usado apenas quando useMockData = false)
  static const String apiBaseUrl = 'http://localhost:5016'; // Android Emulator
  // static const String apiBaseUrl = 'http://localhost:5016'; // iOS Simulator
  // static const String apiBaseUrl = 'http://192.168.1.100:5016'; // Dispositivo físico
  
  static const int httpTimeoutSeconds = 30;
  static const String appName = 'Meu Livro de Receitas';
  static const String appVersion = '1.0.0';
}

class DevMessages {
  static const String mockModeEnabled = '''
  
  ═══════════════════════════════════════════════════════════
  🎭 MODO MOCK ATIVADO
  ═══════════════════════════════════════════════════════════
  
  Você está usando dados mockados para testar a UI.
  
  CREDENCIAIS DE TESTE:
  ├─ Email: teste@email.com
  └─ Senha: 123456
  
  Para usar a API real:
  1. Abra: lib/config/app_config.dart
  2. Altere: useMockData = false
  3. Configure a apiBaseUrl correta
  4. Reinicie o app
  
  ═══════════════════════════════════════════════════════════
  ''';
  
  static const String apiModeEnabled = '''
  
  ═══════════════════════════════════════════════════════════
  🌐 MODO API ATIVADO
  ═══════════════════════════════════════════════════════════
  
  Você está conectado à API real.
  
  URL da API: ${AppConfig.apiBaseUrl}
  
  Certifique-se de que:
  ├─ A API está rodando
  ├─ A URL está correta
  └─ Permissões de rede estão configuradas
  
  Para testar apenas a UI (sem API):
  1. Abra: lib/config/app_config.dart
  2. Altere: useMockData = true
  3. Reinicie o app
  
  ═══════════════════════════════════════════════════════════
  ''';
}