// lib/view/CurrentProjectsDisplayScreen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CurrentProjectsDisplayScreen extends StatefulWidget {
  @override
  _CurrentProjectsDisplayScreenState createState() => _CurrentProjectsDisplayScreenState();
}

class _CurrentProjectsDisplayScreenState extends State<CurrentProjectsDisplayScreen> {
  Map<String, dynamic>? appliedProject;

  @override
  void initState() {
    super.initState();
    _loadAppliedProject();
  }

  Future<void> _loadAppliedProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? projectData = prefs.getString('appliedProject');
    if (projectData != null) {
      setState(() {
        appliedProject = json.decode(projectData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Projects'),
      ),
      body: appliedProject == null
          ? Center(child: Text('No current projects found.'))
          : ListView(
        padding: EdgeInsets.all(10),
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: Image.asset(
                appliedProject!['imageUrl'],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              title: Text(
                appliedProject!['title'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(appliedProject!['description']),
            ),
          ),
        ],
      ),
    );
  }
}
