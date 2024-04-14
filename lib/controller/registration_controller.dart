// lib/controllers/registration_controller.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistrationController {
  final ApiService _apiService = ApiService();

  Future<Future<bool>> registerUser(String name, String email, String password, bool offers, bool termsAccepted) async {
    final userData = {
      'name': name,
      'email': email,
      'password': password,
      'offers': offers,
      'termsAccepted': termsAccepted,
    };
    return _apiService.registerUser(userData);
  }
}
