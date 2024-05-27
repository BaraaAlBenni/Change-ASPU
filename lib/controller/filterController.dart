import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Filter Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Filter Example'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final FilterController controller = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              // Implement filtering by name
            },
            decoration: InputDecoration(
              labelText: 'Filter by Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        // Add your checkboxes for filtering by city here
        Column(
          children: [
            for (var city in controller.cities.keys)
              Row(
                children: [
                  Checkbox(
                    value: controller.cities[city],
                    onChanged: (value) {
                      controller.cities[city] = value!;
                      controller.filterContent('name', ''); // You might want to pass a query here if you're also filtering by name
                    },
                  ),
                  Text(city),
                ],
              ),
          ],
        ),
        // Additional UI elements for displaying filtered items
      ],
    );
  }
}

class FilterController extends GetxController {
  var items = <dynamic>[].obs; // Observable list of items for reactivity.
  var cities = {
    'Damascus': false,
    'Swieda': false,
    'Daraa': false,
    'Homs': false,
    'Lattika': false,
    'Tartous': false,
    'Aleppo': false,
  }.obs; // Observable map to track city checkboxes

  // Fetch data from the API and store it in 'items'
  void fetchData() async {
    try {
      var http;
      var response = await http.get(Uri.parse('https://298f-169-150-196-87.ngrok-free.app/api/categories_display'));
      if (response.statusCode == 200) {
        items.assignAll(json.decode(response.body));
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Filter items based on the provided filter type and query
  void filterContent(String filterType, String query) {
    var filtered = items.where((item) {
      return item[filterType].toString().toLowerCase().contains(query.toLowerCase()) &&
          _filterByCity(item);
    }).toList();
    items.assignAll(filtered); // Update the observable list to trigger UI updates.
  }

  // Check if the item matches any selected cities
  bool _filterByCity(item) {
    for (var city in cities.keys) {
      if (cities[city]! && item['city'].toString().toLowerCase() == city.toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}
