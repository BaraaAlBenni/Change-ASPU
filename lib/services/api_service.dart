// lib/services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:80'; // Adjust for your server

  Future<bool> registerUser(Map<String, dynamic> userData) async {
    Uri url = Uri.parse('$baseUrl/register.php');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return true; // Registration successful
    } else {
      throw Exception('Failed to register user.');
    }
  }
}
