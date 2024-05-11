import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static Future<void> addToFavorites(BuildContext context, int volunteerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = '21|VMj9znU3QEwmw0EvJPhC39gIh5CyvHMVwOkcwpsw58f34338'; // Hardcoded token
    var url = Uri.parse('https://baa0-190-2-153-226.ngrok-free.app/api/add_to_favourite/$volunteerId');

    try {
      // Store favorite locally
      await prefs.setBool('isFavorite_$volunteerId', true);

      // API Call to add to favorites
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Response: ${response.body}');
        Navigator.pushNamed(context, '/favoriteScreen', arguments: volunteerId);
      } else {
        print('Failed to add to favorites: ${response.body}');
        await prefs.setBool('isFavorite_$volunteerId', false);
      }
    } catch (e) {
      print('Error occurred: $e');
      await prefs.setBool('isFavorite_$volunteerId', false);
    }
  }
}
