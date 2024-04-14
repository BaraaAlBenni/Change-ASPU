import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the Scaffold background color to black
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Join Us!",
              style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
            ),
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
              onPressed: () async {
                await _controller.registerUser(
                  _nameController.text,
                  _emailController.text,
                  _passwordController.text,
                  _offers,
                  _termsAccepted,
                );
              },
              child: Center(child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text('Register Now', textAlign: TextAlign.center),
              )),
            ),
          ],
        ),
      ),
    );
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), // Set the border radius here
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
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
}
