import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// A reusable, animated button powered by a Rive state machine.
///
/// This button is designed to be self-contained, managing its own hover
/// and tap states to trigger animations within the Rive file. It expects
/// a Rive state machine with boolean inputs named 'isHover' and 'isPressed'.
class RiveButton extends StatefulWidget {
  final String riveAsset;
  final String artboardName;
  final String stateMachineName;
  final VoidCallback onTap;
  final String label;

  const RiveButton({
    super.key,
    required this.riveAsset,
    required this.artboardName,
    required this.stateMachineName,
    required this.onTap,
    required this.label,
  });

  @override
  State<RiveButton> createState() => _RiveButtonState();
}

class _RiveButtonState extends State<RiveButton> {
  SMIInput<bool>? _hoverInput;
  SMIInput<bool>? _tapInput;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, widget.stateMachineName);
    if (controller != null) {
      artboard.addController(controller);
      // Find the inputs for hover and tap states in the Rive state machine.
      _hoverInput = controller.findInput<bool>('isHover');
      _tapInput = controller.findInput<bool>('isPressed');
    }
  }

  void _onHover(bool isHovering) {
    _hoverInput?.value = isHovering;
  }

  void _onTap() {
    // Trigger the tap animation.
    _tapInput?.value = true;
    // After a short delay, reset the tap animation and fire the callback.
    Future.delayed(const Duration(milliseconds: 250), () {
      _tapInput?.value = false;
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: _onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: RiveAnimation.asset(
                widget.riveAsset,
                artboard: widget.artboardName,
                onInit: _onRiveInit,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
