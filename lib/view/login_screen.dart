import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projecthalf/view/registration_screen.dart';
import 'dart:convert';
import 'dashboard_screen.dart';
import 'package:projecthalf/controller/login_controller.dart'; // Import the LoginController

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController()); // Create an instance of LoginController

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              Obx(() => CheckboxListTile(
                title: Text('Remember me', style: TextStyle(color: Colors.white)),
                value: loginController.rememberMe.value,
                onChanged: loginController.toggleRememberMe,
                controlAffinity: ListTileControlAffinity.leading,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an Account? ", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Get.to(() => RegistrationScreen()),
                    child: Text('Sign up now!!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  loginController.login(emailController.text, passwordController.text);
                },
                child: Obx(() => loginController.isLoading.value ? CircularProgressIndicator() : Text('Log In')), // Observe isLoading from the controller
              ),
            ],
          ),
        ),
      ),
    );
  }
}
