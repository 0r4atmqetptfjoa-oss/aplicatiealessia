
import 'dart:math';
import 'dart:convert';
import 'package:alesia/services/story_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StoryLinkMiniGame extends StatefulWidget {
  final Map<String, StoryNode> graph;
  const StoryLinkMiniGame({super.key, required this.graph});

  @override
  State<StoryLinkMiniGame> createState() => _StoryLinkMiniGameState();
}

class _StoryLinkMiniGameState extends State<StoryLinkMiniGame> {
  final rnd = Random();
  int score = 0;
  int q = 0;
  late List<_Q> questions;

  @override
  void initState() {
    super.initState();
    questions = _buildQuestions(widget.graph, 5);
  }

  List<_Q> _buildQuestions(Map<String, StoryNode> g, int n) {
    final ids = g.keys.toList();
    final list = <_Q>[];
    for (int i=0;i<n;i++) {
      final id = ids[rnd.nextInt(ids.length)];
      final node = g[id]!;
      // pick one real next and 2 decoys
      String correct = node.choices.isNotEmpty ? node.choices.first.nextId : id;
      final decoys = ids.where((x) => x != correct).toList()..shuffle(rnd);
      final options = [correct, if (decoys.isNotEmpty) decoys[0], if (decoys.length>1) decoys[1]];
      options.shuffle(rnd);
      list.add(_Q(prompt: "Din nodul '$id', care nod este un 'nextId' valid?", correct: correct, options: options));
    }
    return list;
  }

  void _answer(String pick) {
    final cur = questions[q];
    final ok = pick == cur.correct;
    if (ok) score++;
    if (q < questions.length - 1) {
      setState(() => q++);
    } else {
      showDialog(context: context, builder: (_) => AlertDialog(
        title: const Text('Gata!'),
        content: Text('Scor: $score / ${questions.length}'),
        actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('OK'))],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cur = questions[q];
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(cur.prompt, style: const TextStyle(fontWeight: FontWeight.bold)).animate().fadeIn(),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: cur.options.map((o) => ElevatedButton(
                onPressed: () => _answer(o),
                child: Text(o),
              )).toList(),
            ),
            const SizedBox(height: 8),
            Text('Întrebare ${q+1}/${questions.length}  •  Scor: $score'),
          ],
        ),
      ),
    );
  }
}

class _Q {
  final String prompt;
  final String correct;
  final List<String> options;
  _Q({required this.prompt, required this.correct, required this.options});
}
