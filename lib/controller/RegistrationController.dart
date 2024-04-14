import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projecthalf/view/dashboard_screen.dart';  // Make sure the import path is correct

class RegistrationController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var offers = false.obs;  // Observable for the offers toggle
  var termsAccepted = false.obs;  // Observable for terms acceptance toggle

  String _username = '';  // Private field for username
  String _email = '';  // Private field for email
  String _password = '';  // Private field for password

  // Setters
  void setUsername(String username) {
    _username = username;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  // Toggle methods
  void toggleOffers(bool value) {
    offers(value);
  }

  void toggleTermsAccepted(bool value) {
    termsAccepted(value);
  }

  Future<void> registerUser() async {
    if (!termsAccepted.value) {
      errorMessage("You must accept the terms and conditions.");
      return;
    }

    isLoading(true);

    const String apiUrl = 'https://your-api-url.com/register';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _username,
          'email': _email,
          'password': _password,
          'offers': offers.value.toString(),
        }),
      );

      isLoading(false);

      if (response.statusCode == 200) {
        Get.offAll(() => DashboardScreen(username: '',));  // Navigate to the Dashboard
      } else {
        errorMessage('Failed to register. Status code: ${response.statusCode}');
      }
    } catch (e) {
      isLoading(false);
      errorMessage('Failed to register. Error: $e');
    }
  }
}
