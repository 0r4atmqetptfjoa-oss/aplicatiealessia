import 'dart:math';
import 'package:flutter/material.dart';

enum ShapeType { circle, square, triangle, star, heart }

class ShapesGameScreen extends StatefulWidget {
  const ShapesGameScreen({super.key});

  @override
  State<ShapesGameScreen> createState() => _ShapesGameScreenState();
}

class _ShapesGameScreenState extends State<ShapesGameScreen> with TickerProviderStateMixin {
  final Random _random = Random();
  late ShapeType _targetShape;
  late List<ShapeType> _options;
  String _message = '';
  int _score = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  ShapeType? _selectedShape;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _generateNewRound();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateNewRound() {
    _targetShape = ShapeType.values[_random.nextInt(ShapeType.values.length)];
    _options = ShapeType.values.toList()..shuffle();
    _options = _options.take(4).toList();
    if (!_options.contains(_targetShape)) {
      _options[_random.nextInt(4)] = _targetShape;
    }
    _message = 'Select the shape ${_targetShape.name}';
    _selectedShape = null;
    setState(() {});
  }

  void _onShapeSelected(ShapeType shape) {
    setState(() {
      _selectedShape = shape;
    });
    if (shape == _targetShape) {
      setState(() {
        _score++;
        _message = 'Correct!';
      });
      _animationController.forward().then((_) {
        _animationController.reverse();
        Future.delayed(const Duration(milliseconds: 500), () {
          _generateNewRound();
        });
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
        title: const Text('Shapes Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: $_score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ScaleTransition(
              scale: _animation,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _options.map((shape) {
                  bool isSelected = _selectedShape == shape;
                  return GestureDetector(
                    onTap: () => _onShapeSelected(shape),
                    child: Container(
                      decoration: isSelected
                          ? BoxDecoration(
                              border: Border.all(
                                color: shape == _targetShape ? Colors.green : Colors.red,
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            )
                          : null,
                      child: CustomPaint(
                        size: const Size(100, 100),
                        painter: ShapePainter(shape: shape, color: Colors.blue),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final ShapeType shape;
  final Color color;

  ShapePainter({required this.shape, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    switch (shape) {
      case ShapeType.circle:
        canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
        break;
      case ShapeType.square:
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
        break;
      case ShapeType.triangle:
        final path = Path();
        path.moveTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.star:
        final path = Path();
        final double radius = size.width / 2;
        final double innerRadius = radius / 2.5;
        const double angle = (pi * 2) / 10;
        final Offset center = Offset(size.width / 2, size.height / 2);

        for (int i = 0; i < 10; i++) {
          final double r = (i % 2 == 0) ? radius : innerRadius;
          final double x = center.dx + r * cos(i * angle - pi / 2);
          final double y = center.dy + r * sin(i * angle - pi / 2);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.heart:
        final path = Path();
        path.moveTo(size.width / 2, size.height * 0.4);
        path.cubicTo(size.width * 0.2, size.height * 0.1, -size.width * 0.25, size.height * 0.6, size.width / 2, size.height);
        path.moveTo(size.width / 2, size.height * 0.4);
        path.cubicTo(size.width * 0.8, size.height * 0.1, size.width * 1.25, size.height * 0.6, size.width / 2, size.height);
        path.close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
