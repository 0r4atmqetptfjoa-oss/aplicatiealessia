import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rive/rive.dart';

class ZanaMelodiaOverlay extends StatefulWidget {
  final ValueListenable<String> animationListenable;
  const ZanaMelodiaOverlay({super.key, required this.animationListenable});

  @override
  State<ZanaMelodiaOverlay> createState() => _ZanaMelodiaOverlayState();
}

class _ZanaMelodiaOverlayState extends State<ZanaMelodiaOverlay> {
  bool _hasRive = false;

  @override
  void initState() {
    super.initState();
    _detectRive();
  }

  Future<void> _detectRive() async {
    try {
      await rootBundle.load('assets/rive/zana_melodia.riv');
      setState(() { _hasRive = true; });
    } catch (_) {
      setState(() { _hasRive = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar;
    if (_hasRive) {
      // TODO (Răzvan): Leagă cu state machine/animations după ce definești în Rive
      avatar = const SizedBox(width: 40, height: 40, child: RiveAnimation.asset('assets/rive/zana_melodia.riv', fit: BoxFit.cover));
    } else {
      // TODO (Răzvan): Înlocuiește cu resursa finală statică
      avatar = Image.asset('assets/images/placeholders/placeholder_square.png', width: 40, height: 40);
    }

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                avatar,
                const SizedBox(width: 8),
                ValueListenableBuilder<String>(
                  valueListenable: widget.animationListenable,
                  builder: (_, v, __) => Text('Zâna: $v', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
