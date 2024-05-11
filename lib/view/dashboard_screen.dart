import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthalf/view/CurrentProjectsDisplayScreen.dart';
import 'package:projecthalf/view/profile_screen.dart';
import 'package:projecthalf/view/FavoriteScreen.dart';
import 'package:projecthalf/view/SearchScreen/SearchScreen.dart';

class DashboardScreen extends StatefulWidget {
  final String username;

  DashboardScreen({Key? key, required this.username}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // To track the active tab

  final List<Color> boxColors = [
    Colors.blueAccent,
    Colors.black,
    Colors.black,
    Colors.white,
  ];

  final List<String> dashboardTexts = [
    'Project finished',
    'Hours spent',
    'Current Projects',
    'Projects',
  ];

  final TextStyle lastDashboardTextStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    decoration: TextDecoration.underline,
    decorationColor: Colors.blue,
    decorationThickness: 4,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text('Hello @${widget.username}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text('My Effect', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 3 / 2,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (index == 2) {
                            Get.to(() => CurrentProjectsDisplayScreen());
                          } else if (index == 3) {
                            Get.to(() => SearchScreen());
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: boxColors[index % boxColors.length],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  dashboardTexts[index],
                                  style: index == 3 ? lastDashboardTextStyle : TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        backgroundColor: Colors.black12,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 1: // Navigate to Favorite Screen
              Get.to(() => FavoriteScreen());
              break;
            case 2: // Navigate to Search Screen
              Get.to(() => SearchScreen());
              break;
            case 3: // Navigate to Profile Screen
              Get.to(() => ProfileScreen());
              break;
          }
        },
      ),
    );
  }
}
