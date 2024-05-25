import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Import http package
import 'package:projecthalf/view/land_cleaning_page.dart';
import 'package:projecthalf/view/FilterScreen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../new_opportunity_details.dart';

class SearchScreen extends StatefulWidget {
  final String? city;
  final String? imagePath;
  final String? title;
  final String? description;

  SearchScreen({this.city, this.imagePath, this.title, this.description});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Titles for each dashboard box
  final List<String> dashboardTitles = [
    'Land Cleaning', 'Home Paint', 'English Teaching', 'Helping the Elderly',
    'Community Service', 'Public Awareness', 'Environmental Care', 'Cultural Events',
  ];

  // City names for each dashboard box
  final List<String> cityNames = [
    'Damascus', 'Aleppo', 'Hama', 'Daraa', 'Sweida', 'Latakia', 'Tartus', 'Homs',
  ];

  // Background images for each dashboard box
  final List<String> backgroundImages = [
    'lib/assets/images/landClean.jpg',
    'lib/assets/images/homepaint.jpg',
    'lib/assets/images/teaching.jpg',
    'lib/assets/images/helping.jpg',
    'lib/assets/images/community.jpg',
    'lib/assets/images/awarness.jpg',
    'lib/assets/images/landcleaning.jpg',
    'lib/assets/images/events.jpg',
  ];

  // Descriptions for each dashboard box
  final List<String> descriptions = [
    "Join us for a day of land cleaning and environmental stewardship! Help restore and preserve our local natural spaces.",
    "Let's paint the town together! Join our community painting event and add color to your neighborhood.",
    "Become an English tutor and make a difference in someone's life. Help others learn a new language and expand their opportunities.",
    "Join us in assisting the elderly members of our community. From running errands to providing companionship, your support makes a difference.",
    "Serve your community by participating in various service projects. From food drives to park clean-ups, there's something for everyone.",
    "Raise awareness about important issues facing our society. Join our campaigns and advocate for positive change.",
    "Protect the environment through our environmental care initiatives. Plant trees, clean up waterways, and more!",
    "Experience the rich culture of our community through events and celebrations. Join us in preserving and sharing our traditions.",
  ];

  // This will hold the filtered data
  List<int> filteredIndexes = [];
  List<Map<String, String>> customOpportunities = [];

  @override
  void initState() {
    super.initState();
    _loadSavedOpportunities();
    if (widget.city != null && widget.imagePath != null && widget.title != null && widget.description != null) {
      customOpportunities.add({
        'city': widget.city!,
        'imagePath': widget.imagePath!,
        'title': widget.title!,
        'description': widget.description!,
      });
    }
  }

  Future<void> _loadSavedOpportunities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedOpportunities = prefs.getStringList('customOpportunities') ?? [];

    setState(() {
      customOpportunities = savedOpportunities.map((opportunity) => json.decode(opportunity)).cast<Map<String, String>>().toList();
    });
  }

  void applyFilters(Map<String, dynamic> filters) {
    List<String> cityFilters = filters['cityFilters'];
    String nameFilter = filters['nameFilter'].toString().toLowerCase();

    setState(() {
      filteredIndexes.clear();
      for (int i = 0; i < cityNames.length; i++) {
        if (cityFilters.contains(cityNames[i]) && dashboardTitles[i].toLowerCase().contains(nameFilter)) {
          filteredIndexes.add(i);
        }
      }
    });
  }

  Future<void> _searchVolunteerWorks(String query) async {
    final url = Uri.parse('https://a043-190-2-153-209.ngrok-free.app/api/volunteer-works/search?status=pending');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer WvlEmUni96D49SdEWHzwuLEmSOumdMXIglrT5wZpcaaaf1c5',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Handle the data as needed
        print(data); // Debug print
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onSubmitted: (query) {
            _searchVolunteerWorks(query);
          },
          decoration: InputDecoration(
            hintText: 'Search...',
            fillColor: Colors.white70,
            filled: true,
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            isDense: true,
          ),
        ),
        backgroundColor: Colors.grey[850],
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () async {
              var filters = await Get.to(() => FilterScreen());
              if (filters != null) {
                applyFilters(filters);
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.black38,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: filteredIndexes.isNotEmpty
              ? filteredIndexes.length
              : dashboardTitles.length + customOpportunities.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 30,
            childAspectRatio: 2 / 2,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index < customOpportunities.length) {
              final opportunity = customOpportunities[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to NewOpportunityDetailsScreen using GetX
                  Get.to(NewOpportunityDetailsScreen(
                    title: opportunity['title']!,
                    city: opportunity['city']!,
                    imagePath: opportunity['imagePath']!,
                    description: opportunity['description']!,
                  ));
                },
                child: Card(
                  color: Colors.grey[100],
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(File(opportunity['imagePath']!)), // Use the selected image
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            opportunity['title']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            opportunity['city']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            opportunity['description']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              final idx = filteredIndexes.isNotEmpty ? filteredIndexes[index - customOpportunities.length] : index - customOpportunities.length;
              final isLandCleaning = dashboardTitles[idx] == "Land Cleaning";

              return GestureDetector(
                onTap: () {
                  // Navigate to LandCleaningDetailsScreen on tap
                  Get.to(LandCleaningDetailsScreen(
                    title: dashboardTitles[idx],
                    city: cityNames[idx],
                    imageUrl: backgroundImages[idx],
                    description: descriptions[idx],
                  ));
                },
                child: Card(
                  color: Colors.grey[100],
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(backgroundImages[idx]), // Use AssetImage
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dashboardTitles[idx],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            cityNames[idx],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isLandCleaning ? Colors.black : Colors.grey[800],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
