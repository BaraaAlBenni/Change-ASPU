import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FoodDetailsPage extends StatefulWidget {
  @override
  _FoodDetailsPageState createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  final List<String> foodItems = [
    "Bread (1 Pack)",
    "Milk (500 ML)",
    "Meat (500 g)",
    "Olive Oil (500 ML)",
  ];

  final List<String> imagePaths = [
    "lib/assets/images/bread.jpg",
    "lib/assets/images/milk.jpg",
    "lib/assets/images/meat.jpg",
    "lib/assets/images/olive oil.jpg",
  ];

  final List<int> points = [100, 150, 200, 300];  // Points for each item
  int userPoints = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserPoints();
  }

  Future<void> _fetchUserPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userPoints = prefs.getInt('userPoints') ?? 0;
    });
  }

  Future<void> _updatePoints(int pointsSpent) async {
    final userId = 1;  // Example user ID
    final remainingPoints = userPoints - pointsSpent;

    final url = Uri.parse('https://0f38-185-183-34-154.ngrok-free.app/api/admin/Add_Point__User?user_id=$userId&points=$remainingPoints');
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          userPoints = remainingPoints;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('userPoints', userPoints);
      } else {
        print('Failed to update points. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showConfirmationDialog(BuildContext context, String item, int points) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Selection'),
          content: Text('Are you sure you want to choose $item? This will deduct $points points from your account.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _updatePoints(points);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('You have selected $item.'),
                  duration: Duration(seconds: 2),
                ));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,  // Set the background color to black
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Food",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),  // Space between text and grid
            Expanded(
              child: GridView.builder(
                itemCount: foodItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,  // Two columns
                  crossAxisSpacing: 10.0,  // Horizontal space between cards
                  mainAxisSpacing: 10.0,  // Vertical space between cards
                  childAspectRatio: 0.8,  // Adjust based on your content, made taller for images
                ),
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,  // Card color
                    child: InkWell(
                      onTap: () => _showConfirmationDialog(context, foodItems[index], points[index]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            imagePaths[index],
                            fit: BoxFit.cover,  // This covers the area of the card without stretching the image
                            height: 120,  // Fixed height for each image
                          ),
                          SizedBox(height: 10),
                          Text(
                            foodItems[index],
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${points[index]} Points',  // Display points for each item
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
