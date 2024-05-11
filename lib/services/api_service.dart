import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = 'https://baa0-190-2-153-226.ngrok-free.app/api/';

  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      var response = await http.post(
        Uri.parse(_baseUrl + 'register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server returns 200 or 201 on successful registration
        return true;
      }
    } catch (e) {
      // Handle any errors here
      print(e.toString());
    }
    return false;
  }
}
