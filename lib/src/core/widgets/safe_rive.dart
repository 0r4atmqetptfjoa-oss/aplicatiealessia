import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Drop-in replacement for your previous SafeRive widget.
/// Fixes the breaking API change: instead of calling `RiveAnimation.file(_file)`
/// (which expects a `String` path in newer rive versions, or a `dart:io File` on older ones),
/// this uses the core `Rive` widget with a loaded `RiveFile`.
///
/// It also fails gracefully if the asset is missing to avoid crashing.
class SafeRive extends StatefulWidget {
  const SafeRive.asset(
    this.assetPath, {
    super.key,
    this.fit = BoxFit.contain,
    this.animations = const [],
    this.alignment = Alignment.center,
  });

  final String assetPath;
  final BoxFit fit;
  final List<String> animations;
  final Alignment alignment;

  @override
  State<SafeRive> createState() => _SafeRiveState();
}

class _SafeRiveState extends State<SafeRive> {
  RiveFile? _file;
  Artboard? _artboard;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final file = await RiveFile.asset(widget.assetPath);
      // Use default artboard
      final artboard = file.mainArtboard;
      // Optionally attach animations by name if provided
      if (widget.animations.isNotEmpty) {
        for (final name in widget.animations) {
          final controller = SimpleAnimation(name, autoplay: true);
          artboard.addController(controller);
        }
      }
      if (!mounted) return;
      setState(() {
        _file = file;
        _artboard = artboard;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Nu pot încărca Rive: ${e.runtimeType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _FallbackBanner(message: _error!);
    }
    if (_artboard != null) {
      // IMPORTANT: Use `Rive(artboard: ...)` rather than `RiveAnimation.file(...)`.
      return Rive(
        artboard: _artboard!,
        fit: widget.fit,
        alignment: widget.alignment,
      );
    }
    // While loading
    return const SizedBox.shrink();
  }
}

class _FallbackBanner extends StatelessWidget {
  const _FallbackBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}