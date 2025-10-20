class ApiException implements Exception {
  final List<String> errors;
  final bool tokenExpired;
  final int? statusCode;

  ApiException({
    required this.errors,
    this.tokenExpired = false,
    this.statusCode,
  });

  factory ApiException.fromJson(Map<String, dynamic> json) {
    final errorsData = json['errors'];
    List<String> errorsList = [];

    if (errorsData is List) {
      errorsList = errorsData.map((e) => e.toString()).toList();
    } else if (errorsData is String) {
      errorsList = [errorsData];
    }

    return ApiException(
      errors: errorsList,
      tokenExpired: json['tokenExpired'] ?? false,
    );
  }

  String get message => errors.isNotEmpty ? errors.first : 'Erro desconhecido';

  @override
  String toString() => errors.join(', ');
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;
}