import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppData {
  final Map<String, dynamic> sounds;
  final Map<String, dynamic> songs;
  final Map<String, dynamic> stories;

  AppData({
    required this.sounds,
    required this.songs,
    required this.stories,
  });
}

final appDataProvider = FutureProvider<AppData>((ref) async {
  final soundsJson = await rootBundle.loadString('assets/data/sounds.json');
  final songsJson = await rootBundle.loadString('assets/data/songs.json');
  final storiesJson = await rootBundle.loadString('assets/data/stories.json');

  return AppData(
    sounds: json.decode(soundsJson),
    songs: json.decode(songsJson),
    stories: json.decode(storiesJson),
  );
});
