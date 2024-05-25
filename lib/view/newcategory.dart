import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import the dart:io package
import 'package:permission_handler/permission_handler.dart'; // Import permission handler
import 'package:projecthalf/view/SearchScreen/SearchScreen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class NewCategoryScreen extends StatefulWidget {
  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  XFile? _imageFile;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController(); // Add title controller
  final ImagePicker _picker = ImagePicker();
  String? _selectedCity;
  final List<String> _cities = ['Damascus', 'Sweida', 'Aleppo', 'Homs', 'Hama', 'Lattakia', 'Tartus', 'Daraa'];

  Future<void> _pickImage() async {
    // Request permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission Request"),
          content: Text("Do you accept to enter to the gallery?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createOpportunity() async {
    // Validate input
    if (_selectedCity == null || _imageFile == null || _titleController.text.isEmpty) {
      print("Please select a city, an image, and enter a title");
      return;
    }

    // Save the new opportunity to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedOpportunities = prefs.getStringList('customOpportunities') ?? [];

    Map<String, String> newOpportunity = {
      'city': _selectedCity!,
      'imagePath': _imageFile!.path,
      'title': _titleController.text,
      'description': _descriptionController.text,
    };

    savedOpportunities.add(json.encode(newOpportunity));
    await prefs.setStringList('customOpportunities', savedOpportunities);

    // Navigate to the SearchScreen with the new opportunity data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          city: _selectedCity!,
          imagePath: _imageFile!.path,
          title: _titleController.text,
          description: _descriptionController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Category'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white), // Set the back button color to white
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Set the app bar title color to white
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _showConfirmationDialog,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.lightBlue,
                  backgroundImage: _imageFile != null ? FileImage(File(_imageFile!.path)) : null,
                  child: _imageFile == null
                      ? Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  )
                      : null,
                ),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                hint: Text("Select a city"),
                value: _selectedCity,
                items: _cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add Title Here',
                ),
                maxLength: 100, // Set maximum length for the title
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createOpportunity,
                child: Text("Create Opportunity"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.lightBlue, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
