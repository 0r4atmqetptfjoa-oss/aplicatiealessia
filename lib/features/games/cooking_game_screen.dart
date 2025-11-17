import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A simple cooking game.
///
/// Players must drag ingredients into a pot to cook a dish. Once all
/// ingredients have been added, a completion message appears. A 3D title
/// model is displayed at the top and an animated subtitle guides the user.
class CookingGameScreen extends StatefulWidget {
  const CookingGameScreen({super.key});

  @override
  State<CookingGameScreen> createState() => _CookingGameScreenState();
}

class _CookingGameScreenState extends State<CookingGameScreen> {
  final Map<String, bool> _added = {
    'Carrot': false,
    'Potato': false,
    'Tomato': false,
  };

  void _reset() {
    setState(() {
      for (final key in _added.keys) {
        _added[key] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cooking Game'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: ModelViewer(
                src: 'assets/models/cooking/title.glb',
                alt: 'Cooking Title',
                autoPlay: true,
                autoRotate: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              height: 40,
              child: DefaultTextStyle(
                // headline6 deprecated; use titleLarge【259856227738898†L509-L519】.
                style: Theme.of(context).textTheme.titleLarge!,
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FlickerAnimatedText('Drag ingredients into the pot!'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Pot target
            DragTarget<String>(
              onWillAccept: (data) => !_added[data]!,
              onAccept: (data) {
                setState(() {
                  _added[data] = true;
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.brown.shade200,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Center(
                    child: Text('Pot'),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            // Ingredients row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _added.keys.map((ingredient) {
                final added = _added[ingredient]!;
                return added
                    ? Opacity(
                        opacity: 0.3,
                        child: _buildIngredientChip(ingredient),
                      )
                    : Draggable<String>(
                        data: ingredient,
                        feedback: _buildIngredientChip(ingredient),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: _buildIngredientChip(ingredient),
                        ),
                        child: _buildIngredientChip(ingredient),
                      );
              }).toList(),
            ),
            const Spacer(),
            if (_added.values.every((v) => v))
              Column(
                children: [
                  Text(
                    'Delicious! You cooked the dish!',
                    // headline6 -> titleLarge【259856227738898†L509-L519】.
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reset,
                    child: const Text('Cook Again'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Builds a chip representing an ingredient.
  Widget _buildIngredientChip(String ingredient) {
    IconData icon;
    switch (ingredient) {
      case 'Carrot':
        icon = Icons.local_florist;
        break;
      case 'Potato':
        icon = Icons.spa;
        break;
      case 'Tomato':
      default:
        icon = Icons.set_meal;
        break;
    }
    return Chip(
      label: Text(ingredient),
      avatar: Icon(icon),
      backgroundColor: Colors.orange.shade100,
    );
  }
}