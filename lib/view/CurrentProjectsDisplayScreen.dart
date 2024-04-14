import 'package:flutter/material.dart';

class CurrentProjectsDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Center(
        child: Text(
          'Details of Current Projects',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
