import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Favorites', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back when the back button is pressed
          },
        ),
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final prefs = snapshot.data!;
          final String? favoriteData = prefs.getString('favoriteData');
          if (favoriteData == null) {
            return Center(child: Text('No Favorites Added', style: TextStyle(color: Colors.white)));
          }
          final Map<String, dynamic> data = json.decode(favoriteData);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(data['imageUrl']),
                  SizedBox(height: 30),
                  _buildTitleWithRating(data['title'], data['rating']),
                  SizedBox(height: 10),
                  _buildCity(data['city']),
                  SizedBox(height: 10),
                  _buildDescription(data['description']),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        height: 400,
      ),
    );
  }

  Widget _buildTitleWithRating(String title, double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 20), // Adjust the spacing between the title and rating
        _buildRating(rating),
      ],
    );
  }

  Widget _buildCity(String city) {
    return Text(
      city,
      style: TextStyle(color: Colors.blue[200], fontSize: 20),
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      description,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
            (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.yellow,
        ),
      ),
    );
  }
}
