import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// --- Data Models ---
enum Shape { circle, square, triangle }

class ShapeOption {
  final Shape shape;
  final Color color;
  const ShapeOption(this.shape, this.color);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeOption && runtimeType == other.runtimeType && shape == other.shape && color == other.color;

  @override
  int get hashCode => shape.hashCode ^ color.hashCode;
}

// --- Main Screen ---
class ParentalGateScreen extends StatefulWidget {
  const ParentalGateScreen({super.key});

  @override
  State<ParentalGateScreen> createState() => _ParentalGateScreenState();
}

class _ParentalGateScreenState extends State<ParentalGateScreen> {
  bool _isShapeMatching = false;
  late ShapeOption _correctShape;
  late List<ShapeOption> _options;

  @override
  void initState() {
    super.initState();
    _generateChallenge();
  }

  void _generateChallenge() {
    final random = Random();
    final shapes = Shape.values.toList()..shuffle();
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple]..shuffle();

    _options = List.generate(3, (index) {
      return ShapeOption(shapes[index], colors[index]);
    });

    _correctShape = _options[random.nextInt(_options.length)];
    setState(() {}); // Refresh the UI with the new challenge
  }

  void _onHoldSuccess() {
    setState(() {
      _isShapeMatching = true;
    });
  }

  void _onShapeSelected(ShapeOption selectedShape) {
    if (selectedShape == _correctShape) {
      context.go('/home'); // Or to a dedicated settings screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect! Please try again.')),
      );
      setState(() {
        _isShapeMatching = false;
        _generateChallenge();
      });
    }
  }

  void _showPrivacyPolicy() async {
    try {
      final privacyPolicy = await rootBundle.loadString('assets/privacy/privacy_policy.txt');
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Privacy Policy'),
          content: SingleChildScrollView(child: Text(privacyPolicy)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Using print in a development tool is acceptable.
      // ignore: avoid_print
      print("Could not load privacy policy: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parental Gate'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.privacy_tip_outlined),
            onPressed: _showPrivacyPolicy,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isShapeMatching
            ? ShapeMatchingView(
                key: ValueKey(_correctShape), // Ensure the view rebuilds on new challenge
                correctShape: _correctShape,
                options: _options,
                onShapeSelected: _onShapeSelected,
              )
            : HoldButtonView(onHoldSuccess: _onHoldSuccess),
      ),
    );
  }
}

// --- Hold Button View ---
class HoldButtonView extends StatefulWidget {
  final VoidCallback onHoldSuccess;
  const HoldButtonView({super.key, required this.onHoldSuccess});

  @override
  State<HoldButtonView> createState() => _HoldButtonViewState();
}

class _HoldButtonViewState extends State<HoldButtonView> {
  Timer? _timer;
  double _progress = 0.0;
  final int _requiredHoldTime = 3; // seconds

  void _onPointerDown(PointerDownEvent details) {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.05 / _requiredHoldTime;
      });
      if (_progress >= 1.0) {
        _timer?.cancel();
        widget.onHoldSuccess();
      }
    });
  }

  void _onPointerUp(PointerUpEvent details) {
    _timer?.cancel();
    _timer = null;
    if (mounted) {
      setState(() {
        _progress = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Press and hold the button to continue', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          const SizedBox(height: 40),
          Listener(
            onPointerDown: _onPointerDown,
            onPointerUp: _onPointerUp,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(value: _progress, strokeWidth: 10),
                  const Icon(Icons.touch_app, size: 80, color: Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Shape Matching View (no changes) ---
class ShapeMatchingView extends StatelessWidget {
  final ShapeOption correctShape;
  final List<ShapeOption> options;
  final ValueChanged<ShapeOption> onShapeSelected;

  const ShapeMatchingView({
    super.key,
    required this.correctShape,
    required this.options,
    required this.onShapeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Select the shape that matches:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          ShapeWidget(shape: correctShape.shape, color: correctShape.color, size: 100),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: options.map((option) {
              return GestureDetector(
                onTap: () => onShapeSelected(option),
                child: ShapeWidget(shape: option.shape, color: option.color, size: 80),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// --- Shape Widget (no changes) ---
class ShapeWidget extends StatelessWidget {
  final Shape shape;
  final Color color;
  final double size;

  const ShapeWidget({super.key, required this.shape, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ShapePainter(shape, color),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final Shape shape;
  final Color color;

  _ShapePainter(this.shape, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    switch (shape) {
      case Shape.circle:
        canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
        break;
      case Shape.square:
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
        break;
      case Shape.triangle:
        final path = Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
