import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const _kStars = 'stars';
  static const _kStickers = 'stickers'; // list<bool> serializat ca string "0,1,0,1,..."
  static const _kRecording = 'last_recording'; // secvență indexuri "0,3,2,1"

  late SharedPreferences _prefs;
  final _rnd = Random();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt(_kStars, _prefs.getInt(_kStars) ?? 0);
    _prefs.setString(_kStickers, _ensureStickers(_prefs.getString(_kStickers)));
    _prefs.setString(_kRecording, _prefs.getString(_kRecording) ?? '');
  }

  String _ensureStickers(String? s) {
    if (s == null || s.isEmpty) {
      return List.filled(12, '0').join(',');
    }
    final parts = s.split(',');
    if (parts.length < 12) {
      return (parts + List.filled(12 - parts.length, '0')).join(',');
    }
    return s;
  }

  int get stars => _prefs.getInt(_kStars) ?? 0;
  List<bool> get stickers {
    final s = _prefs.getString(_kStickers) ?? List.filled(12, '0').join(',');
    return s.split(',').map((e) => e == '1').toList();
  }

  Future<void> addStars(int n) async {
    final val = stars + n;
    await _prefs.setInt(_kStars, val);
  }

  /// Deschide la întâmplare un sticker blocat. Returnează indexul sau -1 dacă nu există.
  Future<int> unlockRandomSticker() async {
    final list = stickers;
    final locked = <int>[];
    for (var i = 0; i < list.length; i++) {
      if (!list[i]) locked.add(i);
    }
    if (locked.isEmpty) return -1;
    final idx = locked[_rnd.nextInt(locked.length)];
    final newList = List<bool>.from(list);
    newList[idx] = true;
    await _prefs.setString(_kStickers, newList.map((b) => b ? '1' : '0').join(','));
    return idx;
  }

  Future<void> setRecording(List<int> seq) async {
    await _prefs.setString(_kRecording, seq.join(','));
  }

  List<int> get recording {
    final s = _prefs.getString(_kRecording) ?? '';
    if (s.isEmpty) return [];
    return s.split(',').map((e) => int.tryParse(e) ?? 0).toList();
  }

  Future<void> clearRecording() async => _prefs.setString(_kRecording, '');
}
