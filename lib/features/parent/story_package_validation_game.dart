import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:alesia/services/story_package_models.dart';
import 'package:flutter/material.dart';

class StoryPackageValidationGame extends StatefulWidget {
  final StoryPackagePreview preview;
  const StoryPackageValidationGame({super.key, required this.preview});

  @override
  State<StoryPackageValidationGame> createState() => _StoryPackageValidationGameState();
}

class _StoryPackageValidationGameState extends State<StoryPackageValidationGame> {
  late Map<String, dynamic> graph;
  final rnd = Random();
  int score = 0;
  int round = 0;
  static const int totalRounds = 5;
  late List<String> nodesWithImages;
  String? currentNodeId;
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    graph = json.decode(widget.preview.storyJson ?? '{}') as Map<String, dynamic>;
    nodesWithImages = graph.keys.where((k) => _imageFor(k) != null).toList();
    _nextRound();
  }

  String? _imageFor(String nodeId) {
    final expected = 'story_${nodeId}.png';
    final found = widget.preview.imagesFound.firstWhere(
      (p) => p.endsWith(expected),
      orElse: () => '',
    );
    return found.isEmpty ? null : '${widget.preview.tempDirPath}/$found';
  }

  void _nextRound() {
    if (nodesWithImages.isEmpty) return;
    currentNodeId = nodesWithImages[rnd.nextInt(nodesWithImages.length)];
    final correct = _imageFor(currentNodeId!);
    final distractors = <String>[];
    final pool = widget.preview.imagesFound.map((p) => '${widget.preview.tempDirPath}/$p').toList();
    pool.shuffle();
    for (final p in pool) {
      if (p != correct) distractors.add(p);
      if (distractors.length == 2) break;
    }
    options = [if (correct != null) correct!, ...distractors]..shuffle();
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    final done = round >= totalRounds;
    return Scaffold(
      appBar: AppBar(title: const Text('Mini-joc validare poveste')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: done ? _buildDone(context) : _buildQuiz(context),
      ),
    );
  }

  Widget _buildQuiz(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Alege imaginea corectă pentru nodul:', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(currentNodeId ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: options.length,
            itemBuilder: (context, i) {
              final f = File(options[i]);
              return InkWell(
                onTap: () {
                  final isCorrect = options[i].endsWith('story_${currentNodeId}.png');
                  if (isCorrect) score++;
                  round++;
                  if (round < totalRounds) {
                    _nextRound();
                  } else {
                    setState((){});
                  }
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Image.file(f, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Text('Nu s-a putut încărca'))),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text('Runda ${round+1} / $totalRounds'),
      ],
    );
  }

  Widget _buildDone(BuildContext context) {
    final ok = score >= (totalRounds * 0.6).ceil();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ok ? Icons.verified : Icons.info, size: 64, color: ok ? Colors.green : Colors.orange),
          const SizedBox(height: 12),
          Text(ok ? 'Validare reușită!' : 'Validare parțială'),
          const SizedBox(height: 8),
          Text('Scor: $score / $totalRounds'),
          const SizedBox(height: 16),
          Text('Poți aplica povestea din ecranul de Preview.'),
        ],
      ),
    );
  }
}
