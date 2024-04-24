import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/authModel/auth_model.dart';

class AuthService {
  static const String baseUrl = 'https://reqres.in';

  Future<UserModel> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extract the token from the response
        final token = responseData['token'];

        // Create a UserModel with the extracted token
        final userModel = UserModel(id: '', email: email, token: token);

        return userModel;
      } else {
        throw ApiException('Login failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode != 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      throw ApiException(responseData['error'] ?? 'Failed to make API request');
    }
  }

  ApiException _handleError(dynamic error) {
    if (error is http.ClientException) {
      return ApiException('Network error: $error');
    } else {
      return ApiException('Unexpected error: $error');
    }
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
