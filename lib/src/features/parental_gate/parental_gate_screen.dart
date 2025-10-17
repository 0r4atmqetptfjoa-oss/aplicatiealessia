import 'package:flutter/material.dart';

/// A placeholder parental gate screen.
///
/// In a later phase this screen will ask a simple math question and
/// validate the answer before granting access to the settings.  For now
/// it simply displays a label.
import 'package:go_router/go_router.dart';

/// A simple parental gate screen that challenges the user with a
/// fixed math question.  Only an adult can type the correct answer
/// and proceed.  Wrong answers will show an error and return the
/// child to the main menu.
class ParentalGateScreen extends StatefulWidget {
  const ParentalGateScreen({super.key});

  @override
  State<ParentalGateScreen> createState() => _ParentalGateScreenState();
}

class _ParentalGateScreenState extends State<ParentalGateScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  void _validateAnswer(BuildContext context) {
    final answer = _controller.text.trim();
    if (answer == '8') {
      // Correct answer – proceed to settings (or home for now)
      context.go('/home');
    } else {
      // Show an error message and reset
      setState(() {
        _errorText = 'Răspuns greșit. Încercați din nou!';
      });
      Future.delayed(const Duration(seconds: 2), () {
        context.go('/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control Parental')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accesul la setări este protejat.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              'Cât fac 3 + 5?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Răspuns',
                errorText: _errorText,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _validateAnswer(context),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _validateAnswer(context),
              child: const Text('Verifică'),
            ),
          ],
        ),
      ),
    );
  }
}