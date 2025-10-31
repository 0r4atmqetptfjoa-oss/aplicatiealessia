import 'dart:math';
import 'package:flutter/material.dart';

class CookingGameScreen extends StatefulWidget {
  const CookingGameScreen({super.key});

  @override
  State<CookingGameScreen> createState() => _CookingGameScreenState();
}

class _CookingGameScreenState extends State<CookingGameScreen> {
  final Random _random = Random();
  late Recipe _currentRecipe;
  late List<Ingredient> _ingredientOptions;
  final List<Ingredient> _potContents = [];
  String _message = '';
  int _score = 0;

  final List<Recipe> _recipes = [
    Recipe(name: 'Salad', ingredients: [
      Ingredient(name: 'lettuce'),
      Ingredient(name: 'tomato'),
      Ingredient(name: 'cucumber'),
    ]),
    Recipe(name: 'Pizza', ingredients: [
      Ingredient(name: 'dough'),
      Ingredient(name: 'cheese'),
      Ingredient(name: 'pepperoni'),
    ]),
  ];

  final List<Ingredient> _allIngredients = [
    Ingredient(name: 'lettuce'),
    Ingredient(name: 'tomato'),
    Ingredient(name: 'cucumber'),
    Ingredient(name: 'dough'),
    Ingredient(name: 'cheese'),
    Ingredient(name: 'pepperoni'),
    Ingredient(name: 'apple'),
    Ingredient(name: 'banana'),
  ];

  @override
  void initState() {
    super.initState();
    _generateNewRound();
  }

  void _generateNewRound() {
    _currentRecipe = _recipes[_random.nextInt(_recipes.length)];
    _potContents.clear();

    _ingredientOptions = List.from(_currentRecipe.ingredients);
    while (_ingredientOptions.length < 5) {
      Ingredient randomIngredient = _allIngredients[_random.nextInt(_allIngredients.length)];
      if (!_ingredientOptions.any((ing) => ing.name == randomIngredient.name)) {
        _ingredientOptions.add(randomIngredient);
      }
    }
    _ingredientOptions.shuffle();

    setState(() {
      _message = 'Cook a ${_currentRecipe.name}!';
    });
  }

  void _onIngredientDropped(Ingredient ingredient) {
    if (_currentRecipe.ingredients.any((ing) => ing.name == ingredient.name) &&
        !_potContents.any((ing) => ing.name == ingredient.name)) {
      setState(() {
        _potContents.add(ingredient);
      });

      if (_potContents.length == _currentRecipe.ingredients.length) {
        setState(() {
          _score++;
          _message = 'Yummy! You made a ${_currentRecipe.name}!';
        });
        Future.delayed(const Duration(seconds: 2), () {
          _generateNewRound();
        });
      }
    } else {
      setState(() {
        _message = 'That doesn\'t go in the recipe!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cooking Game'),
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
          DragTarget<Ingredient>(
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.brown.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _potContents.map((ingredient) {
                      return _buildIngredientImage(ingredient.name, 40);
                    }).toList(),
                  ),
                ),
              );
            },
            onAccept: _onIngredientDropped,
          ),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _ingredientOptions.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final ingredient = _ingredientOptions[index];
                return Draggable<Ingredient>(
                  data: ingredient,
                  feedback: _buildIngredientImage(ingredient.name, 80),
                  childWhenDragging: Container(), // Empty container while dragging
                  child: _buildIngredientImage(ingredient.name, 70),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientImage(String ingredientName, double size) {
    return Image.asset(
      'assets/images/games_module/cooking_game/$ingredientName.png',
      height: size,
      width: size,
      errorBuilder: (context, error, stackTrace) => Icon(Icons.fastfood, size: size),
    );
  }
}

class Recipe {
  final String name;
  final List<Ingredient> ingredients;

  Recipe({required this.name, required this.ingredients});
}

class Ingredient {
  final String name;

  Ingredient({required this.name});
}
