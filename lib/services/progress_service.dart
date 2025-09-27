import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  late SharedPreferences _prefs;
  bool _ready = false;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ready = true;
  }

  bool get ready => _ready;

  // Stickere deținute
  List<String> get stickers => _prefs.getStringList('stickers') ?? <String>[];

  bool hasSticker(String id) => stickers.contains(id);

  Future<void> addSticker(String id) async {
    final list = stickers;
    if (!list.contains(id)) {
      list.add(id);
      await _prefs.setStringList('stickers', list);
    }
  }

  // Rounds per instrument (pentru deblocări)
  int _getRounds(String instrument) => _prefs.getInt('rounds_$instrument') ?? 0;

  Future<int> addRound(String instrument) async {
    final key = 'rounds_$instrument';
    final newVal = _getRounds(instrument) + 1;
    await _prefs.setInt(key, newVal);
    return newVal;
  }

  int rounds(String instrument) => _getRounds(instrument);

  /// Crește runda și returnează un ID de sticker dacă s-a deblocat unul nou
  /// Praguri: 3, 6, 9 runde => star_1,2,3
  Future<String?> addRoundAndMaybeSticker(String instrument) async {
    final r = await addRound(instrument);
    if (r == 3) {
      final id = '${instrument}_star_1';
      await addSticker(id);
      return id;
    }
    if (r == 6) {
      final id = '${instrument}_star_2';
      await addSticker(id);
      return id;
    }
    if (r == 9) {
      final id = '${instrument}_star_3';
      await addSticker(id);
      return id;
    }
    return null;
  }
}
