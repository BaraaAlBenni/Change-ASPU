import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthalf/controller/login_controller.dart'; // Import the LoginController
import 'package:projecthalf/view/registration_screen.dart';

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
      backgroundColor: Colors.white, // Set background color to white
      body: Stack(
        children: [
          Positioned(
            top: 40,
            right: 20,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.updateLocale(Locale('En', 'US'));
                  },
                  child: Image.asset(
                    'lib/assets/icons/UnitedKingdom.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Get.updateLocale(Locale('ar', 'SY'));
                  },
                  child: Image.asset(
                    'lib/assets/icons/Syria.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue, // Border color
                        width: 4.0, // Border width
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/assets/images/logo.jpg',
                        fit: BoxFit.cover,
                        width: 250,
                        height: 250,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'email'.tr),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'password'.tr),
                  ),
                  Obx(() => CheckboxListTile(
                    title: Text('remember_me'.tr, style: TextStyle(color: Colors.black)),
                    value: loginController.rememberMe.value,
                    onChanged: loginController.toggleRememberMe,
                    controlAffinity: ListTileControlAffinity.leading,
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("no_account".tr, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => Get.to(() => RegistrationScreen()),
                        child: Text('sign_up'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      loginController.login(emailController.text, passwordController.text);
                    },
                    child: Obx(() => loginController.isLoading.value ? CircularProgressIndicator() : Text('log_in'.tr)), // Observe isLoading from the controller
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
