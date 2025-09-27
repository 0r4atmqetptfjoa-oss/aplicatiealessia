import 'package:alesia/games/shared/base_instrument_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart' show rootBundle;

class HudOverlay extends StatelessWidget {
  const HudOverlay({super.key, required this.game});
  final BaseInstrumentGame game;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: _ScoreBoard(game: game),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: _FairyAvatar(animListenable: game.fairyAnim, size: 140),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: _BeatIndicator(phase: game.beatPhase),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreBoard extends StatelessWidget {
  const _ScoreBoard({required this.game});
  final BaseInstrumentGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: game.score,
            builder: (_, v, __) => Text('Scor: $v',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 16),
          ValueListenableBuilder<int>(
            valueListenable: game.combo,
            builder: (_, v, __) => Text('Combo: x$v',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: v >= 10 ? Colors.deepPurple : Colors.black87)),
          ),
        ],
      ),
    ).animate().fade(duration: 300.ms);
  }
}

class _BeatIndicator extends StatelessWidget {
  const _BeatIndicator({required this.phase});
  final ValueListenable<double> phase;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: phase,
      builder: (_, p, __) {
        final scale = 0.9 + (p * 0.3);
        final opacity = 0.6 + (1 - (p - 0.5).abs() * 1.2) * 0.4;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Container(
              width: 26, height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.deepPurple, width: 3),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget care încearcă să încarce Rive; dacă eșuează (placeholder invalid), afișează o imagine placeholder.
class _FairyAvatar extends StatefulWidget {
  const _FairyAvatar({required this.animListenable, required this.size});
  final ValueListenable<String> animListenable;
  final double size;

  @override
  State<_FairyAvatar> createState() => _FairyAvatarState();
}

class _FairyAvatarState extends State<_FairyAvatar> {
  Artboard? _artboard;
  RiveFile? _file;
  SimpleAnimation? _controller;
  String _current = 'idle';

  @override
  void initState() {
    super.initState();
    _load();
    widget.animListenable.addListener(_onAnimChange);
  }

  @override
  void didUpdateWidget(covariant _FairyAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animListenable != widget.animListenable) {
      oldWidget.animListenable.removeListener(_onAnimChange);
      widget.animListenable.addListener(_onAnimChange);
      _onAnimChange();
    }
  }

  @override
  void dispose() {
    widget.animListenable.removeListener(_onAnimChange);
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final data = await rootBundle.load('assets/rive/zana_melodia.riv');
      final file = RiveFile.import(data);
      final art = file.mainArtboard;
      _file = file;
      _artboard = art;
      _applyAnimation(_current);
      setState(() {});
    } catch (_) {
      // Ignorăm, vom arăta placeholder.
      setState(() {});
    }
  }

  void _applyAnimation(String name) {
    if (_artboard == null) return;
    _artboard!.removeController(_controller);
    _controller = SimpleAnimation(name);
    _artboard!.addController(_controller!);
  }

  void _onAnimChange() {
    final name = widget.animListenable.value;
    _current = name;
    if (_artboard != null) {
      setState(() => _applyAnimation(name));
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = SizedBox(
      width: widget.size,
      height: widget.size,
      child: _artboard != null
          ? Rive(artboard: _artboard!, fit: BoxFit.contain)
          : Image.asset(
              // TODO (Răzvan): Înlocuiește cu o mini-ilustrație a Zânei dacă dorești fallback custom.
              'assets/images/placeholders/placeholder_square.png',
              fit: BoxFit.contain,
            ),
    );
    return box.animate().fade(duration: 350.ms).scale(curve: Curves.easeOutBack);
  }
}
