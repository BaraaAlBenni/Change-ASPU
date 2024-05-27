
class CurrentProject {
  final String title;
  final String description;
  final String imageUrl;

  CurrentProject({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory CurrentProject.fromJson(Map<String, dynamic> json) {
    return CurrentProject(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
