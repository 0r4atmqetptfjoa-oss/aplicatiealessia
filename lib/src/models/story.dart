class Story {
  final String id;
  final String title;

  Story({required this.id, required this.title});

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
    );
  }
}
