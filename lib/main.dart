import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthalf/view/translations.dart';
import 'controller/boarding_controller.dart';
import 'view/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BoardingController controller = Get.put(BoardingController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MyTranslations(),  // Add the translations
      locale: Locale('en', 'US'),  // Default locale
      fallbackLocale: Locale('en', 'US'),  // Fallback locale
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Obx(() => Stack(
          children: [
            IndexedStack(
              index: controller.currentPage.value,
              children: [
                buildPage('lib/assets/images/first.jpg', 'Join Us in Making a Difference', 'Connect With NGOs and Volunteers who are passionate about making a difference'),
                buildPage('lib/assets/images/friends.jpg', 'Be The Change You Want To See', 'Your actions can inspire others'),
                buildPage('lib/assets/images/hands.jpg', 'Empower Volunteers to Make a Difference', 'Together, we can achieve more'),
                buildPage('lib/assets/images/phone.jpg', 'Get Updates on Your Project', 'Stay informed about our progress'),
              ],
            ),
            Positioned(
              top: 40,
              right: 100,
              child: Row(
                children: List.generate(4, (index) => buildIcon(index)),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 100,
              child: GestureDetector(
                onTap: () {
                  if (controller.currentPage.value == 3) {  // Assuming there are 4 pages (0, 1, 2, 3)
                    Get.to(() => LoginScreen());  // Navigate to LoginScreen when on the last page
                  } else {
                    int nextPage = controller.currentPage.value + 1;
                    controller.changePage(nextPage);
                  }
                },
                child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget buildIcon(int index) {
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(() => Icon(
          Icons.circle,
          size: 24,
          color: controller.currentPage.value == index ? Colors.white : Colors.white.withOpacity(0.5),
        )),
      ),
    );
  }

  Widget buildPage(String imagePath, String boldText, String normalText) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                boldText,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 8),
              Text(
                normalText,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
