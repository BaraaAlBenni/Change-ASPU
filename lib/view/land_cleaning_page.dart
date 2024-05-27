import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projecthalf/view/CurrentProjectsDisplayScreen.dart';

class LandCleaningDetailsScreen extends StatelessWidget {
  final String title;
  final String city;
  final String imageUrl;
  final String description;

  LandCleaningDetailsScreen({
    required this.title,
    required this.city,
    required this.imageUrl,
    required this.description,
  });

  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      IconData iconData = i <= rating ? Icons.star : Icons.star_border;
      var star = Icon(
        iconData,
        color: Colors.yellow,
        size: 24,
      );
      stars.add(star);
    }
    return Row(children: stars);
  }

  double generateRandomRating() {
    Random random = Random();
    return (random.nextDouble() * 1.0) + 4.5; // Generates a random double between 4.5 and 5
  }

  Future<void> _applyNow(BuildContext context) async {
    final projectData = {
      'title': title,
      'city': city,
      'imageUrl': imageUrl,
      'description': description,
    };

    try {
      final response = await http.post(
        Uri.parse('https://0f38-185-183-34-154.ngrok-free.app/api/Volunteer_display'),
        body: json.encode(projectData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Store the data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('appliedProject', json.encode(projectData));

        // Navigate to CurrentProjectsDisplayScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CurrentProjectsDisplayScreen(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Applied successfully!'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to apply. Please try again later.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print('Error applying: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double rating = generateRandomRating();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              imageUrl,
              height: screenHeight * 0.5,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStarRating(rating),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Text(
                      city,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.blue[200]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _applyNow(context),
                        child: Text('Apply Now', style: TextStyle(color: Colors.blue)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: Size(200, 50),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.white),
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          Map<String, dynamic> favoriteData = {
                            'title': title,
                            'city': city,
                            'imageUrl': imageUrl,
                            'description': description,
                            'rating': generateRandomRating(),
                          };
                          await prefs.setString('favoriteData', json.encode(favoriteData));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added to favorites'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(130, 50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
