import 'package:equatable/equatable.dart';

// Classe principal do usuário
class User extends Equatable {
  final String name;
  final String email;

  const User({
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }

  User copyWith({
    String? name,
    String? email,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [name, email];
}

// Classe para tokens de autenticação
class AuthTokens extends Equatable {
  final String accessToken;

  const AuthTokens({
    required this.accessToken,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
    };
  }

  @override
  List<Object?> get props => [accessToken];
}

// Classe para usuário registrado (com tokens)
class RegisteredUser extends Equatable {
  final String name;
  final AuthTokens tokens;

  const RegisteredUser({
    required this.name,
    required this.tokens,
  });

  factory RegisteredUser.fromJson(Map<String, dynamic> json) {
    return RegisteredUser(
      name: json['name'] ?? '',
      tokens: AuthTokens.fromJson(json['tokens'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [name, tokens];
}