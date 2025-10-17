import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveMenuButton extends StatefulWidget {
  final String riveAsset;
  final String artboardName;
  final String stateMachineName;
  final VoidCallback onTap;
  final String label;

  const RiveMenuButton({
    super.key,
    required this.riveAsset,
    required this.artboardName,
    required this.stateMachineName,
    required this.onTap,
    required this.label,
  });

  @override
  State<RiveMenuButton> createState() => _RiveMenuButtonState();
}

class _RiveMenuButtonState extends State<RiveMenuButton> {
  SMIInput<bool>? _hoverInput;
  SMIInput<bool>? _tapInput;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, widget.stateMachineName);
    if (controller != null) {
      artboard.addController(controller);
      _hoverInput = controller.findInput<bool>('isHover');
      _tapInput = controller.findInput<bool>('isPressed');
    }
  }

  void _onHover(bool isHovering) {
    _hoverInput?.value = isHovering;
  }

  void _onTap() {
    _tapInput?.value = true;
    Future.delayed(const Duration(milliseconds: 200), () {
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
            Text(widget.label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
