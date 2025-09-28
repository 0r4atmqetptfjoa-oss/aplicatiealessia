import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Overlay that hosts the 'Zâna Melodia' character (Rive).
/// Controls are exposed via SMI inputs in a state machine named 'StateMachine'.
class ZanaMelodiaOverlay extends StatefulWidget {
  const ZanaMelodiaOverlay({
    super.key,
    required this.animationListenable,
    this.metronomeOnListenable,
    this.onToggleMetronome,
  });

  final ValueListenable<String> animationListenable;
  final ValueListenable<bool>? metronomeOnListenable;
  final VoidCallback? onToggleMetronome;

  @override
  State<ZanaMelodiaOverlay> createState() => _ZanaMelodiaOverlayState();
}

class _ZanaMelodiaOverlayState extends State<ZanaMelodiaOverlay> {
  Artboard? _artboard;
  StateMachineController? _controller;
  SMIInput<bool>? _isTalking;
  SMIInput<bool>? _isPointing;
  SMIInput<double>? _progress;
  bool _visible = true;
  Offset _target = const Offset(16, 16);

  @override
  void initState() {
    super.initState();
    _loadRive();
    widget.animationListenable.addListener(_onAnimName);
  }

  @override
  void dispose() {
    widget.animationListenable.removeListener(_onAnimName);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadRive() async {
    try {
      // TODO (Răzvan): Înlocuiește cu 'assets/rive/zana_melodia.riv' final dacă diferă
      final data = await rootBundle.load('assets/rive/zana_melodia.riv');
      final file = RiveFile.import(data);
      final art = file.mainArtboard;
      final controller = StateMachineController.fromArtboard(art, 'StateMachine');
      if (controller != null) {
        art.addController(controller);
        _isTalking = controller.findInput<bool>('isTalking') as SMIInput<bool>?;
        _isPointing = controller.findInput<bool>('isPointing') as SMIInput<bool>?;
        _progress  = controller.findInput<double>('progress') as SMIInput<double>?;
      }
      setState(() {
        _artboard = art;
        _controller = controller;
      });
    } catch (_) {
      // Fallback: no Rive available -> stay invisible to avoid layout issues.
      setState(() => _visible = false);
    }
  }

  void _onAnimName() {
    // Optional mapping from emitted names to inputs.
    final name = widget.animationListenable.value;
    if (name == 'idle') {
      talk(false);
      pointAt(null);
    } else if (name == 'dance_slow') {
      talk(true);
    } else if (name == 'dance_fast') {
      talk(true);
      _progress?.value = 1.0;
    } else if (name == 'ending_pose') {
      talk(false);
      _progress?.value = 0.0;
    }
    setState(() {});
  }

  // Public control APIs (via GlobalKey if needed)
  void talk([bool v = true]) => _isTalking?.value = v;
  void pointAt(Offset? pos) {
    _isPointing?.value = pos != null;
    if (pos != null) _target = pos;
  }
  void hide() => setState(() => _visible = false);
  void show() => setState(() => _visible = true);

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final riveWidget = _artboard != null
        ? Rive(artboard: _artboard!)
        // TODO (Răzvan): Înlocuiește cu PNG final dacă vrei fallback vizual
        : Image.asset('assets/images/placeholders/placeholder_square.png', width: 56, height: 56);

    return Stack(
      children: [
        // Positioned fairy
        AnimatedPositioned(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutBack,
          right: 12,
          top: 12,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 220),
            opacity: 1.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 56, height: 56, child: riveWidget),
                    const SizedBox(width: 8),
                    ValueListenableBuilder<String>(
                      valueListenable: widget.animationListenable,
                      builder: (_, v, __) => Text('Zâna: $v', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    if (widget.metronomeOnListenable != null && widget.onToggleMetronome != null) ...[
                      const SizedBox(width: 8),
                      ValueListenableBuilder<bool>(
                        valueListenable: widget.metronomeOnListenable!,
                        builder: (_, on, __) => IconButton(
                          tooltip: 'Metronom',
                          onPressed: widget.onToggleMetronome,
                          icon: Icon(on ? Icons.music_note : Icons.music_off),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
