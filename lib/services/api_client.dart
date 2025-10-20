import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/api_exception.dart';

class ApiClient {
  final http.Client _client;
  String? _accessToken;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  String? get accessToken => _accessToken;

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_accessToken != null && _accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _client.get(
        Uri.parse('${AppConfig.apiBaseUrl}$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('Sem conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConfig.apiBaseUrl}$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('Sem conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('${AppConfig.apiBaseUrl}$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('Sem conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String endpoint) async {
    try {
      final response = await _client.delete(
        Uri.parse('${AppConfig.apiBaseUrl}$endpoint'),
        headers: _headers,
      );
      _handleResponse(response);
    } on SocketException {
      throw NetworkException('Sem conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      if (response.body.isNotEmpty) {
        final error = ApiException.fromJson(jsonDecode(response.body));
        throw ApiException(
          errors: error.errors,
          tokenExpired: error.tokenExpired,
          statusCode: response.statusCode,
        );
      }
      throw ApiException(
        errors: ['Não autorizado'],
        statusCode: response.statusCode,
      );
    } else if (response.statusCode == 400) {
      if (response.body.isNotEmpty) {
        throw ApiException.fromJson(jsonDecode(response.body));
      }
      throw ApiException(errors: ['Requisição inválida']);
    } else {
      if (response.body.isNotEmpty) {
        try {
          throw ApiException.fromJson(jsonDecode(response.body));
        } catch (e) {
          throw ApiException(
            errors: ['Erro no servidor'],
            statusCode: response.statusCode,
          );
        }
      }
      throw ApiException(
        errors: ['Erro no servidor'],
        statusCode: response.statusCode,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}