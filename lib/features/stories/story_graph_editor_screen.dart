import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_layout_service.dart';
import 'package:alesia/services/story_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StoryGraphEditorScreen extends StatefulWidget {
  const StoryGraphEditorScreen({super.key});
  @override
  State<StoryGraphEditorScreen> createState() => _StoryGraphEditorScreenState();
}

class _StoryGraphEditorScreenState extends State<StoryGraphEditorScreen> {
  final story = getIt<StoryService>();
  final layout = getIt<StoryLayoutService>();

  final Map<String, Rect> _nodeRects = {};
  final Set<String> _selected = {};
  Offset? _dragStart;
  Offset? _lastDrag;
  bool _draggingNodes = false;
  Rect? _selectionRect;

  // Undo/redo stacks (serialized snapshots)
  final List<String> _undo = [];
  final List<String> _redo = [];

  static const Size nodeSize = Size(170, 64);

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await layout.init();
      await layout.ensureDefaults(story.graph.keys);
      _cacheRects();
      _pushSnapshot(); // initial state
      setState(() {});
    });
  }

  void _cacheRects() {
    _nodeRects
      ..clear();
    for (final id in story.graph.keys) {
      final p = layout.get(id) ?? const Offset(80, 80);
      _nodeRects[id] = p & nodeSize;
    }
  }

  // Snapshot contains: graph+layout
  void _pushSnapshot() {
    final snap = json.encode({
      'graph': story.graphJson,
      'layout': json.decode(layout.exportJson()),
    });
    _undo.add(snap);
    _redo.clear();
  }

  Future<void> _restoreFrom(String snap) async {
    final data = json.decode(snap) as Map<String, dynamic>;
    // graph
    final g = <String, StoryNode>{{}};
    final mg = Map<String, dynamic>.from(data['graph'] as Map);
    final newGraph = <String, StoryNode>{};
    mg.forEach((id, raw) {
      final m = Map<String, dynamic>.from(raw);
      final choices = (m['choices'] as List).map((c) {
        final cc = Map<String, dynamic>.from(c);
        return StoryChoice(cc['t'] as String, cc['n'] as String);
      }).toList();
      newGraph[id] = StoryNode(id: id, subtitle: (m['subtitle'] ?? '') as String, audioId: m['audioId'] as String?, choices: choices);
    });
    await story.replaceGraph(newGraph);
    // layout
    await layout.importJson(json.encode(data['layout']), merge: false);
    _cacheRects();
    setState(() {});
  }

  void _undoAction() async {
    if (_undo.length <= 1) return;
    final current = _undo.removeLast();
    _redo.add(current);
    final prev = _undo.last;
    await _restoreFrom(prev);
  }

  void _redoAction() async {
    if (_redo.isEmpty) return;
    final next = _redo.removeLast();
    _undo.add(next);
    await _restoreFrom(next);
  }

  Map<String, List<String>> _edges() {
    final m = <String, List<String>>{};
    story.graph.forEach((id, node) {
      m[id] = node.choices.map((c) => c.nextId).toList();
    });
    return m;
  }

  Future<void> _autoLayout() async {
    await layout.autoLayout(_edges());
    _cacheRects();
    _pushSnapshot();
    setState(() {});
  }

  Future<void> _exportLayoutJson() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/story_layout_${DateTime.now().millisecondsSinceEpoch}.json';
    final raw = layout.exportJson();
    await File(path).writeAsString(raw);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Layout salvat în: $path')));
    }
  }

  Future<void> _exportSnapshot() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/story_snapshot_${DateTime.now().millisecondsSinceEpoch}.json';
    final snap = _undo.isNotEmpty ? _undo.last : json.encode({'graph': story.graphJson, 'layout': json.decode(layout.exportJson())});
    await File(path).writeAsString(snap);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Snapshot salvat în: $path')));
    }
  }

  Future<void> _importLayoutJson() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result == null || result.files.isEmpty) return;
    final bytes = result.files.first.bytes;
    if (bytes == null) return;
    final raw = utf8.decode(bytes);
    await layout.importJson(raw, merge: true);
    _cacheRects();
    _pushSnapshot();
    setState(() {});
  }

  List<String> _validate() {
    final issues = <String>[];
    final g = story.graph;
    // 1) ținte inexistente
    for (final n in g.values) {
      for (final c in n.choices) {
        if (!g.containsKey(c.nextId)) {
          issues.add('Link din "${n.id}" către inexistent "${c.nextId}"');
        }
      }
    }
    // 2) accesibilitate din start
    final visited = <String>{};
    void dfs(String u) {
      if (visited.contains(u)) return;
      visited.add(u);
      for (final v in g[u]?.choices.map((e) => e.nextId) ?? const <String>[]) { dfs(v); }
    }
    if (g.containsKey('start')) { dfs('start'); }
    for (final id in g.keys) {
      if (!visited.contains(id)) { issues.add('Nod inaccesibil: "$id" (nu se ajunge din start)'); }
    }
    // 3) cicluri
    final temp = <String>{};
    final perm = <String>{};
    bool cycle = false;
    bool visit(String u) {
      if (perm.contains(u)) return false;
      if (temp.contains(u)) return true;
      temp.add(u);
      for (final v in g[u]?.choices.map((e) => e.nextId) ?? const <String>[]) {
        if (visit(v)) return true;
      }
      temp.remove(u); perm.add(u);
      return false;
    }
    for (final id in g.keys) { if (visit(id)) { cycle = true; break; } }
    if (cycle) issues.add('Graful conține cel puțin un CICLU');
    // 4) lipsă terminale
    final terminale = g.values.where((n) => n.choices.isEmpty).toList();
    if (terminale.isEmpty) issues.add('Graful nu are noduri terminale (fără alegeri).');
    return issues;
  }

  void _deleteSelected() async {
    for (final id in _selected.toList()) {
      await story.removeNode(id);
      await layout.remove(id);
    }
    _selected.clear();
    _cacheRects();
    _pushSnapshot();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor Vizual Povești'),
        actions: [
          IconButton(onPressed: _undoAction, icon: const Icon(Icons.undo)),
          IconButton(onPressed: _redoAction, icon: const Icon(Icons.redo)),
          const SizedBox(width: 8),
          TextButton.icon(onPressed: _autoLayout, icon: const Icon(Icons.auto_graph), label: const Text('Auto‑layout')),
          TextButton.icon(onPressed: (){ final issues=_validate(); showDialog(context: context, builder: (_)=>AlertDialog(title: const Text('Validator'), content: SizedBox(width: 420, child: SingleChildScrollView(child: Text(issues.isEmpty? 'OK ✅' : issues.join('\n')))), actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('OK'))],)); }, icon: const Icon(Icons.rule), label: const Text('Validate')),
          TextButton.icon(onPressed: _exportLayoutJson, icon: const Icon(Icons.download), label: const Text('Export Layout')),
          TextButton.icon(onPressed: _importLayoutJson, icon: const Icon(Icons.upload), label: const Text('Import Layout')),
          TextButton.icon(onPressed: _exportSnapshot, icon: const Icon(Icons.save), label: const Text('Snapshot')),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: _selected.isNotEmpty
          ? FloatingActionButton.extended(onPressed: _deleteSelected, icon: const Icon(Icons.delete), label: Text('Șterge (${_selected.length})'))
          : null,
      body: GestureDetector(
        onTapDown: (d) {
          // hit test nodes
          final local = d.localPosition;
          final hit = _nodeRects.entries.firstWhere(
            (e) => e.value.contains(local),
            orElse: () => const MapEntry('', Rect.zero),
          ).key;
          if (hit.isNotEmpty) {
            if (!_selected.contains(hit)) {
              _selected
                ..clear()
                ..add(hit);
            }
            _draggingNodes = true;
            _dragStart = local;
            _lastDrag = local;
          } else {
            _selected.clear();
            _draggingNodes = false;
            _selectionRect = Rect.fromLTWH(local.dx, local.dy, 0, 0);
          }
          setState(() {});
        },
        onPanUpdate: (d) {
          final local = d.localPosition;
          if (_draggingNodes && _dragStart != null) {
            final delta = local - _lastDrag!;
            for (final id in _selected) {
              final r = _nodeRects[id]!;
              final nr = r.shift(delta);
              _nodeRects[id] = nr;
            }
            _lastDrag = local;
          } else if (_selectionRect != null) {
            final origin = _selectionRect!.topLeft;
            _selectionRect = Rect.fromPoints(origin, local);
            _selected
              ..clear();
            _nodeRects.forEach((id, r) {
              if (_selectionRect!.overlaps(r)) _selected.add(id);
            });
          }
          setState(() {});
        },
        onPanEnd: (_) async {
          if (_draggingNodes) {
            // persist positions
            for (final id in _selected) {
              await layout.set(id, _nodeRects[id]!.topLeft);
            }
            _pushSnapshot();
          }
          _draggingNodes = false;
          _dragStart = null;
          _lastDrag = null;
          _selectionRect = null;
          setState(() {});
        },
        child: CustomPaint(
          painter: _GraphPainter(story.graph, _nodeRects, _selected, selection: _selectionRect),
          child: Container(),
        ),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  final Map<String, StoryNode> graph;
  final Map<String, Rect> rects;
  final Set<String> selected;
  final Rect? selection;

  _GraphPainter(this.graph, this.rects, this.selected, {this.selection});

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFF7F7FB);
    canvas.drawRect(Offset.zero & size, bg);

    // Draw edges (Bézier with arrows)
    for (final e in graph.entries) {
      final fromId = e.key;
      final fromRect = rects[fromId];
      if (fromRect == null) continue;
      final from = fromRect.center;
      for (final c in e.value.choices) {
        final toRect = rects[c.nextId];
        if (toRect == null) continue;
        final to = toRect.center;
        final path = _bezierPath(from, to);
        final edgePaint = Paint()
          ..color = Colors.blueGrey.shade400
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawPath(path, edgePaint);
        _drawArrow(canvas, path, Colors.blueGrey.shade400);
      }
    }

    // Draw nodes
    for (final e in graph.entries) {
      final r = rects[e.key];
      if (r == null) continue;
      final isSel = selected.contains(e.key);
      final nodePaint = Paint()
        ..color = isSel ? const Color(0xFFEEE8FD) : Colors.white
        ..style = PaintingStyle.fill;
      final border = Paint()
        ..color = isSel ? const Color(0xFF6C46E8) : const Color(0xFFCBD2E1)
        ..strokeWidth = isSel ? 2.5 : 1.5
        ..style = PaintingStyle.stroke;
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(12));
      canvas.drawRRect(rr, nodePaint);
      canvas.drawRRect(rr, border);

      // Title
      final tp = TextPainter(text: TextSpan(text: e.key, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout(maxWidth: r.width-12);
      tp.paint(canvas, Offset(r.left + 6, r.top + 6));
      // Subtitle
      final sp = TextPainter(text: TextSpan(text: e.value.subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)), textDirection: TextDirection.ltr)..layout(maxWidth: r.width-12);
      sp.paint(canvas, Offset(r.left + 6, r.top + 30));
    }

    // Selection rectangle
    if (selection != null) {
      final selPaint = Paint()
        ..color = const Color(0x663C82F6)
        ..style = PaintingStyle.fill;
      canvas.drawRect(selection!, selPaint);
      final selBorder = Paint()
        ..color = const Color(0xFF3C82F6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRect(selection!, selBorder);
    }
  }

  Path _bezierPath(Offset from, Offset to) {
    final dx = (to.dx - from.dx).abs();
    final mx = math.max(80.0, dx * 0.5);
    final p1 = from;
    final p2 = Offset(from.dx + mx, from.dy);
    final p3 = Offset(to.dx - mx, to.dy);
    final p4 = to;
    final path = Path()..moveTo(p1.dx, p1.dy)..cubicTo(p2.dx, p2.dy, p3.dx, p3.dy, p4.dx, p4.dy);
    return path;
  }

  void _drawArrow(Canvas canvas, Path path, Color color) {
    final pm = PathMetrics();
    final metrics = path.computeMetrics();
    for (final m in metrics) {
      final end = m.length;
      final pos = m.getTangentForOffset(end * 0.999);
      if (pos == null) continue;
      final p = pos.position; final angle = pos.angle;
      const size = 8.0;
      final a = p + Offset(math.cos(angle), math.sin(angle)) * 0;
      final b = p - Offset(math.cos(angle + 0.3), math.sin(angle + 0.3)) * size;
      final c = p - Offset(math.cos(angle - 0.3), math.sin(angle - 0.3)) * size;
      final tri = Path()..moveTo(a.dx, a.dy)..lineTo(b.dx, b.dy)..lineTo(c.dx, c.dy)..close();
      canvas.drawPath(tri, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) => true;
}
