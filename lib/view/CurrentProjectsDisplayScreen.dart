import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrentProjectsDisplayScreen extends StatefulWidget {
  @override
  _CurrentProjectsDisplayScreenState createState() => _CurrentProjectsDisplayScreenState();
}

class _CurrentProjectsDisplayScreenState extends State<CurrentProjectsDisplayScreen> {
  List<dynamic> projects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  // Function to fetch projects from the API
  Future<void> fetchProjects() async {
    try {
      var url = Uri.parse('https://197b-89-39-107-199.ngrok-free.app/api/category_store');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          projects = json.decode(response.body); // Assuming the response is a JSON array
          isLoading = false;
        });
      } else {
        // Handle the error; you might want to show a snackbar or a dialog
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle the exception; you might want to show a snackbar or a dialog
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Current Projects'),
        backgroundColor: Colors.grey[850],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : projects.isNotEmpty
          ? ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              projects[index]['title'], // Assuming 'title' is a field in the response
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              projects[index]['description'], // Assuming 'description' is a field in the response
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
      )
          : Center(
        child: Text(
          'No projects found',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
