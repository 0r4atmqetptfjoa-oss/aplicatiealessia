import 'dart:collection';
import 'dart:ui';

import 'package:alesia/services/story_service.dart';

class StoryLayoutService {
  /// Simple layered BFS layout.
  /// Returns map of nodeId -> Offset(x,y).
  Map<String, Offset> calculateLayout(Story story) {
    const double dx = 260; // horizontal spacing between levels
    const double dy = 140; // vertical spacing between siblings
    const double marginX = 80;
    const double marginY = 80;

    final result = <String, Offset>{};

    // Identify start node (fallback: first key).
    final startId = story.startNodeId ?? (story.nodes.keys.isNotEmpty ? story.nodes.keys.first : null);
    if (startId == null) return result;

    // BFS to group by levels.
    final levelMap = <int, List<String>>{};
    final visited = <String>{};
    final q = Queue<MapEntry<String, int>>();
    q.add(MapEntry(startId, 0));
    visited.add(startId);

    while (q.isNotEmpty) {
      final e = q.removeFirst();
      final id = e.key;
      final lvl = e.value;
      levelMap.putIfAbsent(lvl, () => []).add(id);
      final node = story.nodes[id];
      if (node == null) continue;
      for (final c in node.choices) {
        if (!visited.contains(c.nextId) && story.nodes.containsKey(c.nextId)) {
          visited.add(c.nextId);
          q.add(MapEntry(c.nextId, lvl + 1));
        }
      }
    }

    // Add any unvisited nodes to the last level to ensure all nodes are placed.
    final unvisited = story.nodes.keys.where((k) => !visited.contains(k)).toList(growable: false);
    if (unvisited.isNotEmpty) {
      final lastLevel = levelMap.keys.isEmpty ? 0 : levelMap.keys.reduce((a, b) => a > b ? a : b) + 1;
      levelMap[lastLevel] = [...(levelMap[lastLevel] ?? const []), ...unvisited];
    }

    // Place nodes per level
    levelMap.forEach((lvl, nodes) {
      final y = marginY + lvl * dy;
      final totalWidth = (nodes.length - 1) * dx;
      var x = marginX - totalWidth / 2;
      for (final id in nodes) {
        result[id] = Offset(x, y);
        x += dx;
      }
    });

    return result;
  }
}
