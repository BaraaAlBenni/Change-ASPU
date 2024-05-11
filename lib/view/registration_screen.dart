import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';
import '../controller/registration_controller.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegistrationController _controller = RegistrationController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _offers = false;
  bool _termsAccepted = false;
  String _registeredUsername = ''; // Variable to store the registered username
  bool _isLoading = false; // Variable to control the visibility of the loading indicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Join Us!", style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            _buildTextField(_nameController, 'Enter your name'),
            SizedBox(height: 10),
            _buildTextField(_emailController, 'Enter your email'),
            SizedBox(height: 10),
            _buildTextField(_passwordController, 'Enter your password', obscure: true),
            SizedBox(height: 20),
            _buildSwitchListTile('Sign up for exclusive offers', _offers, (bool value) {
              setState(() { _offers = value; });
            }),
            _buildSwitchListTile('I accept the Terms and conditions', _termsAccepted, (bool value) {
              setState(() { _termsAccepted = value; });
            }),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: _isLoading ? null : () async {
                setState(() {
                  _isLoading = true; // Set loading indicator to true
                });
                // Check all fields are filled and terms are accepted
                if (!_nameController.text.trim().isEmpty &&
                    !_emailController.text.trim().isEmpty &&
                    !_passwordController.text.trim().isEmpty &&
                    _offers && _termsAccepted) {
                  bool success = await _controller.registerUser(
                    _nameController.text.trim(),
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                    _offers,
                    _termsAccepted,
                  );
                  if (success) {
                    _registeredUsername = _nameController.text; // Store the registered username
                    // Save the username to SharedPreferences
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('username', _registeredUsername);

                    Get.snackbar("Registration Success", "Registration successful!",
                        backgroundColor: Colors.green, colorText: Colors.white);
                    Get.offAll(() => DashboardScreen(username: _nameController.text));
                  } else {
                    Get.snackbar("Registration Failed", "Registration failed, please try again.",
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }

                } else {
                  // Provide feedback if the form is not properly filled or conditions are not met
                  Get.snackbar("Registration Failed", "Please fill all fields and accept the terms to register.",
                      backgroundColor: Colors.red, colorText: Colors.white);
                }
                setState(() {
                  _isLoading = false; // Set loading indicator to false after registration attempt
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: _isLoading
                    ? CircularProgressIndicator() // Show loading indicator when _isLoading is true
                    : Text('Register Now', textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField(TextEditingController controller, String labelText, {bool obscure = false}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.blue, width: 2)),
      ),
    ),
  );
}

Widget _buildSwitchListTile(String title, bool value, Function(bool) onChanged) {
  return SwitchListTile(
    title: Text(title, style: TextStyle(color: Colors.white)),
    value: value,
    onChanged: onChanged,
    activeColor: Colors.blue,
    activeTrackColor: Colors.white30,
  );
}
