import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SongMarker {
  final String label;
  final double timeSec;
  SongMarker(this.label, this.timeSec);
  factory SongMarker.fromJson(Map<String, dynamic> m) => SongMarker(m['label'], (m['timeSec'] as num).toDouble());
}

class SongTrack {
  final String id;
  final String title;
  final double durationSec;
  final int bpm;
  final List<SongMarker> markers;
  const SongTrack({required this.id, required this.title, required this.durationSec, required this.bpm, required this.markers});
  factory SongTrack.fromJson(Map<String, dynamic> m) => SongTrack(
    id: m['id'], title: m['title'], durationSec: (m['durationSec'] as num).toDouble(), bpm: (m['bpm'] as num).toInt(),
    markers: (m['markers'] as List? ?? []).map((e) => SongMarker.fromJson(Map<String, dynamic>.from(e))).toList(),
  );
}

class SongPlaylistService {
  List<SongTrack> _tracks = const [];
  List<SongTrack> get tracks => _tracks;

  Future<void> loadFromAssets([String path = 'assets/songs/playlist.json']) async {
    final raw = await rootBundle.loadString(path);
    final data = json.decode(raw) as Map<String, dynamic>;
    final list = (data['tracks'] as List).cast<Map<String, dynamic>>();
    _tracks = list.map(SongTrack.fromJson).toList(growable: false);
  }
}
