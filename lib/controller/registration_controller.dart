import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class RegistrationController {
  final ApiService _apiService = ApiService();

  Future<bool> registerUser(String name, String email, String password, bool offers, bool termsAccepted) async {
    if (!termsAccepted || name.isEmpty || email.isEmpty || password.isEmpty) {
      // Early return if any conditions are not met
      return false;
    }

    Map<String, dynamic> userData = {
      'name': name,
      'email': email,
      'password': password,
      'offers': offers,
      'termsAccepted': termsAccepted,
    };

    // Save user data to local storage
    await _saveUserDataToLocal(userData);

    // Call the API to register user
    return _apiService.register(userData);
  }

  Future<void> _saveUserDataToLocal(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', userData['name']);
    await prefs.setString('email', userData['email']);
    await prefs.setString('password', userData['password']);
    await prefs.setBool('offers', userData['offers']);
    await prefs.setBool('termsAccepted', userData['termsAccepted']);
  }
}
