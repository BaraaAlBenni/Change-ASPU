import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController nameController = TextEditingController();
  // Manually define the city names and initial checkbox states
  Map<String, bool> cityFilters = {
    'Damascus': false,
    'Sweida': false,
    'Daraa': false,
    'Homs': false,
    'Aleppo': false,
    'Latakia': false,
    'Tartus': false,
    'Hama': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Filter Options")),
      backgroundColor: Colors.black, // Set background color to black
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: nameController,
              style: TextStyle(color: Colors.white), // Set text color to white
              decoration: InputDecoration(
                labelText: 'Filter by Name',
                labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                suffixIcon: Icon(Icons.search, color: Colors.white), // Set icon color to white
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Optionally add real-time name filtering logic here
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cityFilters.keys.map((city) {
                  return CheckboxListTile(
                    title: Text(
                      city,
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                    value: cityFilters[city],
                    onChanged: (bool? value) {
                      setState(() {
                        cityFilters[city] = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing, // Places checkbox after the text
                    activeColor: Colors.transparent, // Set checkbox color to transparent
                    checkColor: Colors.white, // Set check mark color to white
                    tileColor: Colors.black, // Set tile color to black
                    selectedTileColor: Colors.black, // Set selected tile color to black
                    contentPadding: EdgeInsets.zero, // Remove default padding
                  );
                }).toList(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Create a list of only the selected cities
              var selectedCities = cityFilters.entries
                  .where((entry) => entry.value)
                  .map((entry) => entry.key)
                  .toList();
              // Pass back the selected cities and any name filter applied
              Get.back(result: {
                'nameFilter': nameController.text,
                'cityFilters': selectedCities
              });
            },
            child: Text("Apply Filters", style: TextStyle(color: Colors.white)), // Set text color to white
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Set button background color
            ),
          ),
        ],
      ),
    );
  }
}
