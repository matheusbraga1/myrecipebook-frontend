import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/app_config.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'repositories/auth_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/mock_auth_repository.dart';
import 'repositories/mock_user_repository.dart';
import 'services/api_client.dart';
import 'services/storage_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  
  if (kDebugMode) {
    print(AppConfig.useMockData 
      ? DevMessages.mockModeEnabled 
      : DevMessages.apiModeEnabled);
  }
  
  runApp(MyRecipeBookApp(prefs: prefs));
}

class MyRecipeBookApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyRecipeBookApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    final storageService = StorageService(prefs: prefs);
    
    late final dynamic authRepository;
    late final dynamic userRepository;
    
    if (AppConfig.useMockData) {
      authRepository = MockAuthRepository(storageService: storageService);
      userRepository = MockUserRepository(storageService: storageService);
    } else {
      final apiClient = ApiClient();
      authRepository = AuthRepository(
        apiClient: apiClient,
        storageService: storageService,
      );
      userRepository = UserRepository(
        apiClient: apiClient,
        storageService: storageService,
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository: authRepository)
            ..checkAuthStatus(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(userRepository: userRepository),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Meu Livro de Receitas',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFFF6B35),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              textTheme: GoogleFonts.poppinsTextTheme(),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                titleTextStyle: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            home: authProvider.status == AuthStatus.initial
                ? const SplashScreen()
                : authProvider.isAuthenticated
                    ? const HomeScreen()
                    : const LoginScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/profile': (context) => const ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Meu Livro de Receitas',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}