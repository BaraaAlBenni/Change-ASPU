import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import the dart:io package
import 'package:permission_handler/permission_handler.dart'; // Import permission handler
import 'package:projecthalf/view/SearchScreen/SearchScreen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:intl/intl.dart'; // Import intl for date formatting

class NewCategoryScreen extends StatefulWidget {
  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  XFile? _imageFile;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController(); // Add title controller
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startHourController = TextEditingController();
  final TextEditingController _endHourController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController(); // Add points controller
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
    if (_selectedCity == null || _imageFile == null || _titleController.text.isEmpty || _pointsController.text.isEmpty) {
      print("Please select a city, an image, enter a title, and points");
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
      'startDate': _startDateController.text,
      'endDate': _endDateController.text,
      'startHour': _startHourController.text,
      'endHour': _endHourController.text,
      'points': _pointsController.text,
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

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null)
      setState(() {
        controller.text = picked.format(context);
      });
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
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButton<String>(
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
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _pointsController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Points',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
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
              TextField(
                controller: _startDateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Start Date',
                ),
                readOnly: true,
                onTap: () => _selectDate(context, _startDateController),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _endDateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'End Date',
                ),
                readOnly: true,
                onTap: () => _selectDate(context, _endDateController),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _startHourController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Start Hour',
                ),
                readOnly: true,
                onTap: () => _selectTime(context, _startHourController),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _endHourController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'End Hour',
                ),
                readOnly: true,
                onTap: () => _selectTime(context, _endHourController),
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
