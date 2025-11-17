import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A simple sorting animals game using drag and drop.
///
/// Animals must be dragged into the correct habitat category: land,
/// sea or air. When all animals are sorted correctly a congratulatory
/// message appears. This demonstrates drag targets and draggable
/// widgets in Flutter.
class SortingAnimalsGameScreen extends StatefulWidget {
  const SortingAnimalsGameScreen({super.key});

  @override
  State<SortingAnimalsGameScreen> createState() => _SortingAnimalsGameScreenState();
}

class _SortingAnimalsGameScreenState extends State<SortingAnimalsGameScreen> {
  final Map<String, String> _animals = {
    'Lion': 'land',
    'Elephant': 'land',
    'Fish': 'sea',
    'Shark': 'sea',
    'Eagle': 'air',
    'Parrot': 'air',
  };
  final Map<String, String?> _assignment = {};

  @override
  void initState() {
    super.initState();
    _animals.keys.forEach((animal) => _assignment[animal] = null);
  }

  bool get _allSorted => _assignment.values.every((value) => value != null && _animals[value] == null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sorting Animals'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: ModelViewer(
                src: 'assets/models/sorting_animals/title.glb',
                alt: 'Sorting Animals Title',
                autoRotate: true,
                autoPlay: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 8),
            DefaultTextStyle(
              // headline6 -> titleLarge【259856227738898†L509-L519】.
              style: Theme.of(context).textTheme.titleLarge!,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TyperAnimatedText('Drag each animal to its habitat'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Categories row
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategory('land', Colors.brown.shade200),
                  _buildCategory('sea', Colors.blue.shade200),
                  _buildCategory('air', Colors.green.shade200),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Draggable animals row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _animals.keys.map((animal) {
                final assigned = _assignment[animal] != null;
                return Draggable<String>(
                  data: animal,
                  feedback: _buildAnimalChip(animal, opacity: 1.0),
                  childWhenDragging: _buildAnimalChip(animal, opacity: 0.3),
                  child: _buildAnimalChip(animal, opacity: assigned ? 0.3 : 1.0),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (_assignment.values.every((value) => value != null))
              Column(
                children: [
                  Text(
                    _assignment.entries.every((e) => _animals[e.key] == e.value)
                        ? 'All animals sorted correctly!'
                        : 'Some animals are in the wrong habitat.',
                    // headline6 -> titleLarge【259856227738898†L509-L519】.
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _animals.keys.forEach((animal) => _assignment[animal] = null);
                      });
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Builds a category target for a given habitat. Accepts animals whose
  /// correct habitat matches the category key.
  Widget _buildCategory(String key, Color color) {
    return Expanded(
      child: DragTarget<String>(
        onWillAccept: (animal) => _animals[animal] == key && _assignment[animal] == null,
        onAccept: (animal) {
          setState(() {
            _assignment[animal] = key;
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            height: 150,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                key.toUpperCase(),
                // headline6 -> titleLarge【259856227738898†L509-L519】.
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds a chip representing an animal name.
  Widget _buildAnimalChip(String animal, {double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Chip(
        label: Text(animal),
        backgroundColor: Colors.orange.shade100,
      ),
    );
  }
}