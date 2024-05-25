import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences package
import 'login_screen.dart';
import 'redeem_points_page.dart';

class ProfileScreen extends StatefulWidget {
  final String city = "City Name"; // Example city name
  final int points = 500; // Example points

  ProfileScreen({Key? key}) : super(key: key); // Remove the username parameter

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkModeEnabled = false; // Initial state of the switch
  String _storedUsername = ''; // Variable to store fetched username

  @override
  void initState() {
    super.initState();
    _fetchUsername(); // Fetch username when the widget initializes
  }

  void _fetchUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedUsername = prefs.getString('username') ?? ''; // Retrieve username from shared preferences
    });
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkModeEnabled = value;
    });
  }

  // Function to log out
  // Function to log out
  // Function to log out
  void _logout() async {
    try {
      // Retrieve token from FlutterSecureStorage
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'auth_token');

      if (token != null) {
        var response = await http.post(
          Uri.parse('https://0f38-185-183-34-154.ngrok-free.app /api/logout'),
          headers: {
            'Authorization': 'Bearer $token', // Include token in the headers
          },
        );
        if (response.statusCode == 200) {
          // Clear user data from FlutterSecureStorage
          await storage.delete(key: 'auth_token');
          // Navigate back to LoginScreen and clear all routes
          Get.offAll(() => LoginScreen());
        } else {
          // Show error message if the logout request fails
          Get.snackbar("Error", "Failed to log out",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        // Show error message if token is not found
        Get.snackbar("Error", "Token not found",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      // Show error message if an exception occurs during the logout process
      Get.snackbar("Error", "An error occurred: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine text and icon color based on the background color
    Color textColor = _isDarkModeEnabled ? Colors.white : Colors.black;
    Color iconColor = _isDarkModeEnabled ? Colors.white : Colors.grey;

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      backgroundColor: _isDarkModeEnabled ? Colors.black : Colors.white,
      body: Column(
        children: [
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://img.freepik.com/premium-vector/young-man-face-avater-vector-illustration-design_968209-13.jpg'),
                  radius: 60,
                ),
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _storedUsername.isNotEmpty
                          ? _storedUsername
                          : "Default Username", // Display fetched username if available, else display a default username
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          widget.city,
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(${widget.points} points)',
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView(
              children: ListTile.divideTiles(
                color: iconColor, // Use the iconColor for the divider color
                tiles: [
                  ListTile(
                    leading: Icon(Icons.person, color: iconColor),
                    title: Text('My Account ',
                        style: TextStyle(color: textColor)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.bookmark, color: iconColor),
                    title: Text('Saved Opportunities',
                        style: TextStyle(color: textColor)),
                    onTap: () {},
                  ),
                  SwitchListTile(
                    title: Text('Light/Dark Mode',
                        style: TextStyle(color: textColor)),
                    value: _isDarkModeEnabled,
                    onChanged: _toggleDarkMode,
                    secondary: Icon(
                        _isDarkModeEnabled
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: iconColor),
                  ),
                  ListTile(
                    leading: Icon(Icons.card_giftcard, color: iconColor),
                    title: Text('Redeem Your Points',
                        style: TextStyle(color: textColor)),
                    onTap: () {
                      Get.to(() => RedeemPointsPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: iconColor),
                    title: Text('Log Out',
                        style: TextStyle(color: textColor)),
                    onTap: _logout, // Call the logout function when tapped
                  ),
                ],
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
