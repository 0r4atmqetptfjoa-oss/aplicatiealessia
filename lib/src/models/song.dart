class Song {
  final String id;
  final String title;

  Song({required this.id, required this.title});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
    );
  }
}
