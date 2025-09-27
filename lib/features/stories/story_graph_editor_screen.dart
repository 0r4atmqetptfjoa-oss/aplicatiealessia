import 'dart:math';
import 'dart:ui' as ui;
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_layout_service.dart';
import 'package:alesia/services/story_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StoryGraphEditorScreen extends StatefulWidget {
  const StoryGraphEditorScreen({super.key});

  @override
  State<StoryGraphEditorScreen> createState() => _StoryGraphEditorScreenState();
}

class _StoryGraphEditorScreenState extends State<StoryGraphEditorScreen> {
  final keyBoundary = GlobalKey();
  final tc = TransformationController();
  late Map<String, StoryNode> graph;
  final nodeSize = const Size(220, 120);
  String? connectFrom;
  bool connectMode = false;

  @override
  void initState() {
    super.initState();
    graph = Map.of(getIt<StoryService>().graph);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getIt<StoryLayoutService>().ensureDefaults(graph.keys);
      setState((){});
    });
  }

  @override
  Widget build(BuildContext context) {
    final layout = getIt<StoryLayoutService>();
    final positions = Map.fromEntries(graph.keys.map((id) => MapEntry(id, layout.get(id) ?? const Offset(80, 80))));
    final bounds = _boundsFor(positions.values.toList());
    final canvasSize = Size(max(bounds.right + 400, MediaQuery.of(context).size.width),
                            max(bounds.bottom + 400, MediaQuery.of(context).size.height));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor Vizual Povești'),
        actions: [
          IconButton(onPressed: _validate, icon: const Icon(Icons.rule)),
          IconButton(onPressed: _autoLayout, icon: const Icon(Icons.auto_fix_high)),
          IconButton(onPressed: _exportPng, icon: const Icon(Icons.image)),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: _fab(),
      body: RepaintBoundary(
        key: keyBoundary,
        child: InteractiveViewer(
          transformationController: tc,
          boundaryMargin: const EdgeInsets.all(2000),
          minScale: 0.25,
          maxScale: 4.0,
          child: SizedBox(
            width: canvasSize.width,
            height: canvasSize.height,
            child: Stack(
              children: [
                CustomPaint(
                  painter: _EdgesPainter(graph: graph, size: nodeSize, positions: positions),
                  size: canvasSize,
                ),
                ...graph.entries.map((e) {
                  final id = e.key;
                  final node = e.value;
                  final pos = positions[id]!;
                  final selected = connectFrom == id;
                  return Positioned(
                    left: pos.dx, top: pos.dy,
                    child: _NodeCard(
                      id: id,
                      node: node,
                      size: nodeSize,
                      selected: selected,
                      onDrag: (delta) async {
                        final scale = tc.value.getMaxScaleOnAxis();
                        final newPos = (layout.get(id) ?? const Offset(80,80)) + delta/scale;
                        await layout.set(id, newPos);
                        setState((){});
                      },
                      onEdit: () => _editNode(id),
                      onAddChoice: () => _addChoiceFrom(id),
                      onDelete: () => _deleteNode(id),
                      onTap: () {
                        if (connectMode) {
                          if (connectFrom == null) {
                            setState(() => connectFrom = id);
                          } else if (connectFrom != id) {
                            _completeConnection(connectFrom!, id);
                          }
                        }
                      },
                    ).animate().scale(delay: 50.ms, duration: 250.ms),
                  );
                }),
                Positioned(
                  right: 16, bottom: 16,
                  child: FilterChip(
                    label: Text(connectMode ? (connectFrom==null ? 'Selectează sursa' : 'Alege destinația') : 'Conectează noduri'),
                    selected: connectMode,
                    onSelected: (v) { setState(() { connectMode = v; connectFrom = null; }); },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Rect _boundsFor(List<Offset> pts) {
    if (pts.isEmpty) return const Rect.fromLTWH(0, 0, 0, 0);
    double minX = pts.first.dx, maxX = pts.first.dx, minY = pts.first.dy, maxY = pts.first.dy;
    for (final p in pts) {
      minX = min(minX, p.dx); maxX = max(maxX, p.dx);
      minY = min(minY, p.dy); maxY = max(maxY, p.dy);
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  Future<void> _addNode() async {
    final idController = TextEditingController();
    final subtitleController = TextEditingController();
    final audioController = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Nod nou'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: idController, decoration: const InputDecoration(labelText: 'ID (unic)')),
        TextField(controller: subtitleController, decoration: const InputDecoration(labelText: 'Subtitlu')),
        TextField(controller: audioController, decoration: const InputDecoration(labelText: 'Audio ID (opțional)')),
      ]),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(ctx,false), child: const Text('Anulează')),
        ElevatedButton(onPressed: ()=>Navigator.pop(ctx,true), child: const Text('Adaugă')),
      ],
    )) ?? false;
    if (!ok) return;
    final id = idController.text.trim();
    if (id.isEmpty || graph.containsKey(id)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID invalid sau deja existent.')));
      return;
    }
    final node = StoryNode(id: id, subtitle: subtitleController.text.trim(), audioId: audioController.text.trim().isEmpty ? null : audioController.text.trim());
    graph[id] = node;
    await getIt<StoryService>().putNode(node);
    await getIt<StoryLayoutService>().set(id, const Offset(80,80));
    setState((){});
  }

  Future<void> _editNode(String id) async {
    final node = graph[id]!;
    final subtitleController = TextEditingController(text: node.subtitle);
    final audioController = TextEditingController(text: node.audioId ?? '');
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: Text('Editează "$id"'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: subtitleController, decoration: const InputDecoration(labelText: 'Subtitlu')),
        TextField(controller: audioController, decoration: const InputDecoration(labelText: 'Audio ID')),
      ]),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(ctx,false), child: const Text('Renunță')),
        ElevatedButton(onPressed: ()=>Navigator.pop(ctx,true), child: const Text('Salvează')),
      ],
    )) ?? false;
    if (!ok) return;
    await getIt<StoryService>().updateNode(id, subtitle: subtitleController.text.trim(), audioId: audioController.text.trim().isEmpty ? null : audioController.text.trim());
    setState(()=> graph = Map.of(getIt<StoryService>().graph));
  }

  Future<void> _addChoiceFrom(String fromId) async {
    String? target = fromId;
    String text = '';
    final ids = graph.keys.toList();
    final textCtl = TextEditingController();
    target = await showDialog<String>(context: context, builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSt) => AlertDialog(
        title: Text('Adaugă alegere din "$fromId"'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButton<String>(
            value: target,
            items: ids.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setSt(()=> target = v),
          ),
          TextField(controller: textCtl, decoration: const InputDecoration(labelText: 'Text pe buton')),
        ]),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('Anulează')),
          ElevatedButton(onPressed: ()=>Navigator.pop(ctx, target), child: const Text('OK')),
        ],
      ),
    ));
    if (target == null) return;
    text = textCtl.text.trim().isEmpty ? 'Continuă' : textCtl.text.trim();
    await getIt<StoryService>().addChoice(fromId, StoryChoice(text, target));
    setState(()=> graph = Map.of(getIt<StoryService>().graph));
  }

  Future<void> _deleteNode(String id) async {
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: Text('Ștergi nodul "$id"?'),
      content: const Text('Toate legăturile către acest nod vor fi eliminate.'),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(ctx,false), child: const Text('Nu')),
        ElevatedButton(onPressed: ()=>Navigator.pop(ctx,true), child: const Text('Da')),
      ],
    )) ?? false;
    if (!ok) return;
    await getIt<StoryService>().removeNode(id);
    await getIt<StoryLayoutService>().remove(id);
    setState(()=> graph = Map.of(getIt<StoryService>().graph));
  }

  Future<void> _completeConnection(String from, String to) async {
    final ctl = TextEditingController(text: 'Continuă');
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: Text('Conectează "$from" → "$to"'),
      content: TextField(controller: ctl, decoration: const InputDecoration(labelText: 'Text pe buton')),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(ctx,false), child: const Text('Anulează')),
        ElevatedButton(onPressed: ()=>Navigator.pop(ctx,true), child: const Text('Creează')),
      ],
    )) ?? false;
    if (!ok) return;
    await getIt<StoryService>().addChoice(from, StoryChoice(ctl.text.trim().isEmpty ? 'Continuă' : ctl.text.trim(), to));
    setState(() { connectFrom = null; graph = Map.of(getIt<StoryService>().graph); });
  }

  void _validate() {
    final issues = <String>[];
    final g = graph;
    if (!g.containsKey('start')) issues.add('Lipsește nodul "start".');
    // 1) targete inexistente
    for (final e in g.entries) {
      for (final c in e.value.choices) {
        if (!g.containsKey(c.nextId)) {
          issues.add('Alegere din "${e.key}" pointează spre inexistent: "${c.nextId}"');
        }
      }
    }
    // 2) noduri neaccesibile
    final visited = <String>{};
    void dfs(String u) {
      if (visited.contains(u) || !g.containsKey(u)) return;
      visited.add(u);
      for (final c in g[u]!.choices) { dfs(c.nextId); }
    }
    if (g.containsKey('start')) { dfs('start'); }
    for (final id in g.keys) {
      if (!visited.contains(id)) issues.add('Nod inaccesibil din "start": "$id"');
    }
    // 3) terminale
    final terminals = g.values.where((n) => n.choices.isEmpty).map((n) => n.id).toList();
    if (terminals.isEmpty) issues.add('Nu există nod terminal (fără alegeri).');

    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Validator Poveste'),
      content: SizedBox(
        width: 420,
        child: issues.isEmpty ? const Text('Totul arată bine! ✅') : Column(
          mainAxisSize: MainAxisSize.min,
          children: issues.map((e)=>ListTile(leading: const Icon(Icons.error, color: Colors.red), title: Text(e))).toList(),
        ),
      ),
      actions: [TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('OK'))],
    ));
  }

  Future<void> _autoLayout() async {
    final edges = <String, List<String>>{};
    for (final e in graph.entries) {
      edges[e.key] = e.value.choices.map((c) => c.nextId).toList();
    }
    await getIt<StoryLayoutService>().autoLayout(edges);
    setState((){});
  }

  Future<void> _exportPng() async {
    try {
      final boundary = keyBoundary.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final img = await boundary.toImage(pixelRatio: 2.5);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      final dir = await getApplicationDocumentsDirectory();
      final file = await File('${dir.path}/StoryGraph_${DateTime.now().millisecondsSinceEpoch}.png').writeAsBytes(bytes);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export PNG: ${file.path}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Eroare la export: $e')));
    }
  }

  Widget _fab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(onPressed: _addNode, icon: const Icon(Icons.add_box), label: const Text('Nod nou')),
        const SizedBox(height: 8),
        FloatingActionButton.extended(onPressed: () => setState(()=> connectMode = !connectMode), icon: const Icon(Icons.alt_route), label: Text(connectMode? 'Conectare (ON)' : 'Conectare')),
      ],
    );
  }
}

class _NodeCard extends StatelessWidget {
  final String id;
  final StoryNode node;
  final Size size;
  final bool selected;
  final ValueChanged<Offset> onDrag;
  final VoidCallback onEdit;
  final VoidCallback onAddChoice;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _NodeCard({
    required this.id,
    required this.node,
    required this.size,
    required this.selected,
    required this.onDrag,
    required this.onEdit,
    required this.onAddChoice,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onPanUpdate: (d) => onDrag(d.delta),
      child: SizedBox(
        width: size.width, height: size.height,
        child: Card(
          color: selected ? Colors.amber.shade100 : Colors.white,
          elevation: selected ? 10 : 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(id, style: const TextStyle(fontWeight: FontWeight.bold))),
                  IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, size: 20)),
                  IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, size: 20)),
                ]),
                Expanded(child: Text(node.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis)),
                const SizedBox(height: 4),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  ...node.choices.asMap().entries.map((e) => Chip(label: Text('${e.value.text} → ${e.value.nextId}'))),
                  ActionChip(label: const Text('+ Alegere'), onPressed: onAddChoice),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EdgesPainter extends CustomPainter {
  final Map<String, StoryNode> graph;
  final Size size;
  final Map<String, Offset> positions;

  _EdgesPainter({required this.graph, required this.size, required this.positions});

  @override
  void paint(Canvas canvas, ui.Size canvasSize) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    for (final e in graph.entries) {
      final fromPos = (positions[e.key] ?? const Offset(0,0)) + Offset(size.width/2, size.height/2);
      for (final c in e.value.choices) {
        final toPos = (positions[c.nextId] ?? const Offset(0,0)) + Offset(size.width/2, size.height/2);
        final path = Path()..moveTo(fromPos.dx, fromPos.dy)..lineTo(toPos.dx, toPos.dy);
        canvas.drawPath(path, paint);
        _drawArrow(canvas, fromPos, toPos, color: Colors.deepPurple);
      }
    }
  }

  void _drawArrow(Canvas canvas, Offset a, Offset b, {Color color = Colors.black}) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final v = (b - a);
    final len = v.distance;
    if (len < 1) return;
    final dir = v / len;
    final p = b - dir*16.0;
    final ortho = Offset(-dir.dy, dir.dx);
    final path = Path()
      ..moveTo(p.dx, p.dy)
      ..lineTo(p.dx - dir.dx*10 + ortho.dx*6, p.dy - dir.dy*10 + ortho.dy*6)
      ..lineTo(p.dx - dir.dx*10 - ortho.dx*6, p.dy - dir.dy*10 - ortho.dy*6)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EdgesPainter oldDelegate) => true;
}