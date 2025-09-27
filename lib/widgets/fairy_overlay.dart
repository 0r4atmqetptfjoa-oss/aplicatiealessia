import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

/// Un overlay care afișează 'Zâna Melodia' (Rive), schimbând animația în
/// funcție de combo. Dacă fișierul Rive nu e valid (placeholder), cade
/// pe o imagine placeholder.
class FairyOverlay extends StatefulWidget {
  final ValueListenable<int> comboListenable;
  const FairyOverlay({super.key, required this.comboListenable});

  @override
  State<FairyOverlay> createState() => _FairyOverlayState();
}

class _FairyOverlayState extends State<FairyOverlay> {
  Artboard? _artboard;
  String _currentAnim = 'idle';
  bool _riveOk = false;

  @override
  void initState() {
    super.initState();
    _loadRive();
    widget.comboListenable.addListener(_handleCombo);
  }

  @override
  void dispose() {
    widget.comboListenable.removeListener(_handleCombo);
    super.dispose();
  }

  void _handleCombo() {
    final c = widget.comboListenable.value;
    String next = 'idle';
    if (c >= 10) next = 'dance_fast';
    else if (c >= 5) next = 'dance_slow';
    // când streak mare se întrerupe, ar fi ideal 'ending_pose'; aici simplificăm
    setState(() => _currentAnim = next);
    if (_artboard != null) {
      _artboard!.removeController(whereType: SimpleAnimation);
      _artboard!.addController(SimpleAnimation(_currentAnim));
    }
  }

  Future<void> _loadRive() async {
    try {
      final bytes = await rootBundle.load('assets/rive/zana_melodia.riv');
      final file = RiveFile.import(bytes.buffer.asUint8List());
      final art = file.mainArtboard;
      art.addController(SimpleAnimation(_currentAnim));
      setState(() {
        _artboard = art;
        _riveOk = true;
      });
    } catch (_) {
      setState(() => _riveOk = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Container(
      margin: const EdgeInsets.only(top: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 160,
        width: 160,
        child: _riveOk && _artboard != null
            ? Rive(artboard: _artboard!)
            : Image.asset('assets/images/placeholders/placeholder_square.png', fit: BoxFit.contain),
      ),
    );
    return Align(alignment: Alignment.topRight, child: box);
  }
}
