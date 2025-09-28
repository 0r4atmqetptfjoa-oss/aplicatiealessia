import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rive/rive.dart';

class ZanaMelodiaOverlay extends StatefulWidget {
  final ValueListenable<String> animationListenable;
  final ValueListenable<bool>? metronomeOnListenable;
  final VoidCallback? onToggleMetronome;
  const ZanaMelodiaOverlay({super.key, required this.animationListenable, this.metronomeOnListenable, this.onToggleMetronome});

  @override
  State<ZanaMelodiaOverlay> createState() => _ZanaMelodiaOverlayState();
}

class _ZanaMelodiaOverlayState extends State<ZanaMelodiaOverlay> {
  bool _hasRive = false;
  Artboard? _artboard;
  String _current = 'idle';

  @override
  void initState() {
    super.initState();
    _detectRive();
    widget.animationListenable.addListener(_onAnimChange);
  }

  @override
  void dispose() {
    widget.animationListenable.removeListener(_onAnimChange);
    super.dispose();
  }

  void _onAnimChange() {
    final name = widget.animationListenable.value;
    _setAnimation(name);
  }

  Future<void> _detectRive() async {
    try {
      final data = await rootBundle.load('assets/rive/zana_melodia.riv');
      final file = RiveFile.import(data);
      final art = file.mainArtboard;
      setState(() {
        _artboard = art;
        _hasRive = true;
      });
      _setAnimation(_current);
    } catch (_) {
      setState(() { _hasRive = false; });
    }
  }

  void _setAnimation(String name) {
    _current = name;
    if (!_hasRive || _artboard == null) return;
    _artboard!.removeAllControllers();
    final ctrl = SimpleAnimation(name, autoplay: true);
    _artboard!.addController(ctrl);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar;
    if (_hasRive && _artboard != null) {
      avatar = SizedBox(width: 56, height: 56, child: Rive(artboard: _artboard!));
    } else {
      // TODO (Răzvan): Înlocuiește cu resursa finală statică
      avatar = Image.asset('assets/images/placeholders/placeholder_square.png', width: 56, height: 56);
    }

    final metronome = widget.metronomeOnListenable;
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
                avatar,
                const SizedBox(width: 8),
                ValueListenableBuilder<String>(
                  valueListenable: widget.animationListenable,
                  builder: (_, v, __) => Text('Zâna: $v', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                if (metronome != null && widget.onToggleMetronome != null) ...[
                  const SizedBox(width: 12),
                  ValueListenableBuilder<bool>(
                    valueListenable: metronome,
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
    );
  }
}
