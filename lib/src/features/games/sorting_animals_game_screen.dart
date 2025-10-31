import 'dart:math';
import 'package:flutter/material.dart';

class SortingAnimalsGameScreen extends StatefulWidget {
  const SortingAnimalsGameScreen({super.key});

  @override
  State<SortingAnimalsGameScreen> createState() => _SortingAnimalsGameScreenState();
}

class _SortingAnimalsGameScreenState extends State<SortingAnimalsGameScreen> {
  final Random _random = Random();
  late Animal _targetAnimal;
  String _message = '';
  int _score = 0;

  final List<Animal> _animals = [
    Animal(name: 'cow', habitat: Habitat.farm),
    Animal(name: 'pig', habitat: Habitat.farm),
    Animal(name: 'lion', habitat: Habitat.jungle),
    Animal(name: 'monkey', habitat: Habitat.jungle),
    Animal(name: 'fish', habitat: Habitat.ocean),
    Animal(name: 'dolphin', habitat: Habitat.ocean),
  ];

  @override
  void initState() {
    super.initState();
    _generateNewRound();
  }

  void _generateNewRound() {
    _targetAnimal = _animals[_random.nextInt(_animals.length)];
    setState(() {
      _message = 'Where does the ${_targetAnimal.name} live?';
    });
  }

  void _onAnimalDropped(Habitat habitat) {
    if (habitat == _targetAnimal.habitat) {
      setState(() {
        _score++;
        _message = 'Correct!';
      });
      Future.delayed(const Duration(seconds: 1), () {
        _generateNewRound();
      });
    } else {
      setState(() {
        _message = 'Try again!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorting Animals Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Score: $_score',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            _message,
            style: const TextStyle(fontSize: 20),
          ),
          Draggable<Animal>(
            data: _targetAnimal,
            feedback: _buildAnimalImage(_targetAnimal.name, 120),
            childWhenDragging: Container(height: 100), // Placeholder when dragging
            child: _buildAnimalImage(_targetAnimal.name, 100),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: Habitat.values.map((habitat) {
              return DragTarget<Animal>(
                builder: (context, candidateData, rejectedData) {
                  return _buildHabitatContainer(habitat);
                },
                onAccept: (animal) => _onAnimalDropped(habitat),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalImage(String animalName, double size) {
    return Image.asset(
      'assets/images/games_module/sorting_animals_game/$animalName.png',
      height: size,
      width: size,
      errorBuilder: (context, error, stackTrace) => Icon(Icons.pets, size: size),
    );
  }

  Widget _buildHabitatContainer(Habitat habitat) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          habitat.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

enum Habitat { farm, jungle, ocean }

class Animal {
  final String name;
  final Habitat habitat;

  Animal({required this.name, required this.habitat});
}
