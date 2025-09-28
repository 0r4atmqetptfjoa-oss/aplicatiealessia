import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioService {
  final _soloud = SoLoud.instance;
  bool _inited = false;

  Future<void> init() async {
    if (_inited) return;
    try { await _soloud.init(); _inited = true; } catch (e) { if (kDebugMode) print('Audio init failed: $e'); }
  }

  Future<void> playClick() async {
    if (!_inited) await init();
    try {
      // TODO (Răzvan): Înlocuiește cu sunet final 'click.mp3' în assets/audio/final/
      final h = await _soloud.loadAsset('assets/audio/final/click.mp3');
      await _soloud.play(h);
    } catch (_) {}
  }

  Future<void> dispose() async { try { await _soloud.deinit(); } catch (_) {} }
}
