import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _kStickersKey = 'stickers';
  static const _kBestStreakKeyPrefix = 'best_streak_'; // ex: best_streak_piano
  final ValueNotifier<int> totalStickers = ValueNotifier(0);
  Map<String, int> _stickers = {};
  SharedPreferences? _prefs;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final jsonStr = _prefs!.getString(_kStickersKey);
      if (jsonStr != null) {
        final map = Map<String, dynamic>.from(json.decode(jsonStr));
        _stickers = map.map((k, v) => MapEntry(k, v as int));
      }
      _recomputeTotal();
    } catch (e) {
      if (kDebugMode) print('ProgressService init error: $e');
    }
  }

  Map<String, int> get stickers => Map.unmodifiable(_stickers);

  int getBestStreak(String instrument) {
    return _prefs?.getInt('$_kBestStreakKeyPrefix$instrument') ?? 0;
  }

  Future<void> saveBestStreak(String instrument, int value) async {
    try {
      await _prefs?.setInt('$_kBestStreakKeyPrefix$instrument', value);
    } catch (_) {}
  }

  Future<void> awardSticker(String id) async {
    _stickers[id] = (_stickers[id] ?? 0) + 1;
    await _persist();
    _recomputeTotal();
  }

  Future<void> awardRandomStickerForInstrument(String instrument) async {
    // set minimal generic sticker ids
    final candidates = <String>[
      'star', 'note', 'heart', 'shell', 'sparkle', 'flower', 'smile', 'crown'
    ].map((e) => '$instrument-$e').toList();
    candidates.shuffle();
    await awardSticker(candidates.first);
  }

  Future<void> _persist() async {
    try {
      await _prefs?.setString(_kStickersKey, json.encode(_stickers));
    } catch (_) {}
  }

  void _recomputeTotal() {
    totalStickers.value = _stickers.values.fold(0, (a, b) => a + b);
  }
}
