import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class StoryLayoutService {
  static const _k = 'story_layout_positions_v1';
  SharedPreferences? _prefs;
  final Map<String, Offset> _pos = {};

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_k);
    if (raw != null) {
      final m = Map<String, dynamic>.from(json.decode(raw));
      m.forEach((id, v) {
        final list = (v as List).cast<num>();
        _pos[id] = Offset(list[0].toDouble(), list[1].toDouble());
      });
    }
  }

  Offset? get(String id) => _pos[id];

  Future<void> set(String id, Offset o) async {
    _pos[id] = o;
    await _save();
  }

  Future<void> remove(String id) async {
    _pos.remove(id);
    await _save();
  }

  Future<void> ensureDefaults(Iterable<String> ids) async {
    if (ids.isEmpty) return;
    double x = 80, y = 80;
    for (final id in ids) {
      _pos.putIfAbsent(id, () {
        final v = Offset(x, y);
        x += 240;
        if (x > 1600) { x = 80; y += 200; }
        return v;
      });
    }
    await _save();
  }

  Future<void> autoLayout(Map<String, List<String>> edges) async {
    // BFS from 'start' to build layers
    final levels = <String, int>{};
    final q = <String>[];
    if (edges.containsKey('start')) {
      q.add('start'); levels['start'] = 0;
    } else if (edges.isNotEmpty) {
      final first = edges.keys.first;
      q.add(first); levels[first] = 0;
    }
    while (q.isNotEmpty) {
      final u = q.removeAt(0);
      final nexts = edges[u] ?? [];
      for (final v in nexts) {
        if (!levels.containsKey(v)) {
          levels[v] = (levels[u] ?? 0) + 1;
          q.add(v);
        }
      }
    }
    // Remaining nodes get last layer
    final maxL = (levels.values.isEmpty ? 0 : (levels.values.reduce((a,b)=>a>b?a:b)));
    for (final id in edges.keys) {
      levels.putIfAbsent(id, () => maxL + 1);
    }
    // Place nodes per layer
    final layerMap = <int, List<String>>{};
    levels.forEach((k, v) => layerMap.putIfAbsent(v, () => []).add(k));
    const dx = 260.0, dy = 200.0, mx = 80.0, my = 80.0;
    layerMap.forEach((layer, nodes) {
      for (int i=0;i<nodes.length;i++) {
        _pos[nodes[i]] = Offset(mx + layer*dx, my + i*dy);
      }
    });
    await _save();
  }

  Future<void> _save() async {
    await _prefs?.setString(_k, json.encode(_pos.map((k, v) => MapEntry(k, [v.dx, v.dy]))));
  }
}
