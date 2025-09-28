import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StoryHistoryService {
  static const _fileName = 'story_history.json';
  List<String> _undo = [];
  List<String> _redo = [];

  List<String> get undo => List.unmodifiable(_undo);
  List<String> get redo => List.unmodifiable(_redo);

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
    }

  Future<void> load() async {
    try {
      final f = await _file();
      if (await f.exists()) {
        final raw = await f.readAsString();
        final m = json.decode(raw) as Map<String, dynamic>;
        _undo = (m['undo'] as List?)?.cast<String>() ?? [];
        _redo = (m['redo'] as List?)?.cast<String>() ?? [];
      }
    } catch (_) {
      _undo = []; _redo = [];
    }
  }

  Future<void> saveStacks(List<String> undo, List<String> redo) async {
    _undo = List.of(undo);
    _redo = List.of(redo);
    try {
      final f = await _file();
      final raw = json.encode({'undo': _undo, 'redo': _redo});
      await f.writeAsString(raw);
    } catch (_) {}
  }

  Future<void> clear() async {
    _undo.clear(); _redo.clear();
    try { final f = await _file(); if (await f.exists()) await f.delete(); } catch (_) {}
  }
}
