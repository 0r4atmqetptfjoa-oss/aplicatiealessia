import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final soundsFile = File('assets/data/sounds.json');
  final songsFile = File('assets/data/songs.json');
  final storiesFile = File('assets/data/stories.json');

  try {
    print('Validating sounds.json...');
    await validateSounds(json.decode(await soundsFile.readAsString()));

    print('Validating songs.json...');
    await validateSongs(json.decode(await songsFile.readAsString()));

    print('Validating stories.json...');
    await validateStories(json.decode(await storiesFile.readAsString()));

    print('\x1B[32mAll data files are valid!\x1B[0m');
  } catch (e) {
    print('\x1B[31mError: $e\x1B[0m');
    exit(1);
  }
}

Future<void> validateSounds(Map<String, dynamic> data) async {
  final categories = data['categories'] as List;
  for (final category in categories) {
    final categoryId = category['id'] as String;
    final items = category['items'] as List;
    for (final item in items) {
      final itemId = item['id'] as String;
      final audioPath = 'assets/audio/sounds/$categoryId/$itemId.wav';
      if (!await File(audioPath).exists()) {
        throw Exception('Asset not found: $audioPath');
      }
      final imagePath = 'assets/images/sounds_module/$categoryId/$itemId.png';
      if (!await File(imagePath).exists()) {
        // This is a warning, not an error, as we might not have images for all sounds
        print('\x1B[33mWarning: Image asset not found: $imagePath\x1B[0m');
      }
    }
  }
}

Future<void> validateSongs(Map<String, dynamic> data) async {
  final songs = data['songs'] as List;
  for (final song in songs) {
    final songId = song['id'] as String;
    final audioPath = 'assets/audio/songs/$songId.mp3';
    if (!await File(audioPath).exists()) {
      throw Exception('Asset not found: $audioPath');
    }
    final videoPath = 'assets/video/songs/${songId}_dance.mp4';
    if (!await File(videoPath).exists()) {
      throw Exception('Asset not found: $videoPath');
    }
  }
}

Future<void> validateStories(Map<String, dynamic> data) async {
  final stories = data['stories'] as List;
  for (final story in stories) {
    final storyId = story['id'] as String;
    final videoPath = 'assets/video/stories/$storyId.mp4';
    if (!await File(videoPath).exists()) {
      throw Exception('Asset not found: $videoPath');
    }
  }
}
