import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/current_project.dart';
import '../model/volunteer_work.dart';

class ApiService {
  final String _baseUrl = 'https://0f38-185-183-34-154.ngrok-free.app/api/';

  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      var response = await http.post(
        Uri.parse(_baseUrl + 'register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<List<VolunteerWork>> fetchVolunteerWorks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl + 'volunteer-works/search?status=pending'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => VolunteerWork.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load volunteer works');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<CurrentProject>> fetchCurrentProjects() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl + 'Volunteer_display'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => CurrentProject.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load current projects');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
