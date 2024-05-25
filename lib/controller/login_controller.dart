import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projecthalf/view/dashboard_screen.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final storage = FlutterSecureStorage(); // Create an instance of FlutterSecureStorage

  var rememberMe = false.obs;  // Define rememberMe as an observable

  final String baseUrl = 'https://0f38-185-183-34-154.ngrok-free.app/api/login';

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print(email);
      print(password);
      if (response.statusCode == 200) {
        print("Inside");
        var data = jsonDecode(response.body);
        String token = data['access_token']; // Get the token from the response
        await storage.write(key: 'auth_token', value: token); // Securely store the token
        // Extract username from response data or use a default one if not available
        String username = data['username'] ?? 'User';
        Get.offAll(() => DashboardScreen(username: username)); // Navigate to Dashboard
      } else {
        Get.snackbar('Error', 'Invalid email or password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Define the toggleRememberMe method
  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
    }
  }
}
