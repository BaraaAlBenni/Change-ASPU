class VolunteerWork {
  final String title;
  final String city;
  final String description;
  final String imageUrl;

  VolunteerWork({
    required this.title,
    required this.city,
    required this.description,
    required this.imageUrl,
  });

  factory VolunteerWork.fromJson(Map<String, dynamic> json) {
    return VolunteerWork(
      title: json['title'],
      city: json['city'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

