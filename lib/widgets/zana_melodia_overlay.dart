import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class ZanaMelodiaOverlay extends StatefulWidget {
  final ValueListenable<String> animationListenable;
  const ZanaMelodiaOverlay({super.key, required this.animationListenable});

  @override
  State<ZanaMelodiaOverlay> createState() => _ZanaMelodiaOverlayState();
}

class _ZanaMelodiaOverlayState extends State<ZanaMelodiaOverlay> {
  Artboard? _artboard;
  RiveAnimationController? _controller;
  bool _riveOk = false;

  @override
  void initState() {
    super.initState();
    _loadRive();
    widget.animationListenable.addListener(_onAnimChange);
  }

  @override
  void dispose() {
    widget.animationListenable.removeListener(_onAnimChange);
    super.dispose();
  }

  void _onAnimChange() {
    if (_artboard == null) return;
    final name = widget.animationListenable.value;
    _artboard!.removeController(_controller);
    _controller = SimpleAnimation(name);
    _artboard!.addController(_controller!);
    setState(() {});
  }

  Future<void> _loadRive() async {
    try {
      // TODO (Răzvan): Înlocuiește cu fișierul Rive final valid 'zana_melodia.riv' (cu animațiile: idle, dance_slow, dance_fast, ending_pose)
      final data = await rootBundle.load('assets/rive/zana_melodia.riv');
      final bytes = Uint8List.view(data.buffer);
      final file = RiveFile.import(bytes);
      final art = file.mainArtboard;
      _controller = SimpleAnimation(widget.animationListenable.value);
      art.addController(_controller!);
      setState(() {
        _artboard = art;
        _riveOk = true;
      });
    } catch (_) {
      setState(() {
        _riveOk = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 120, height: 120,
            child: IgnorePointer(
              ignoring: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _riveOk && _artboard != null
                    ? Rive(artboard: _artboard!, fit: BoxFit.contain)
                    : Image.asset(
                        // TODO (Răzvan): Înlocuiește cu un thumbnail final pentru Zâna, dacă dorești
                        'assets/images/placeholders/placeholder_square.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
