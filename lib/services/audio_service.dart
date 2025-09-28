import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioService {
  final _soloud = SoLoud.instance;
  bool _inited = false;
  int? _click;
  int? _tick;

  Future<void> init() async {
    if (_inited) return;
    try { await _soloud.init(); _inited = true; } catch (e) { if (kDebugMode) print('Audio init failed: $e'); }
  }

  Future<void> preload() async {
    if (!_inited) await init();
    await _ensureClick();
    await _ensureTick();
  }

  Future<void> _ensureClick() async {
    if (_click != null) return;
    try {
      // TODO (Răzvan): Înlocuiește cu fișierul final 'click.mp3'
      _click = await _soloud.loadAsset('assets/audio/final/click.mp3');
    } catch (_) {}
  }

  Future<void> _ensureTick() async {
    if (_tick != null) return;
    try {
      // TODO (Răzvan): Înlocuiește cu fișierul final 'metronome_tick.mp3'
      _tick = await _soloud.loadAsset('assets/audio/final/metronome_tick.mp3');
    } catch (_) {}
  }

  Future<void> playClick() async {
    if (!_inited) await init();
    await _ensureClick();
    if (_click != null) { await _soloud.play(_click!); }
  }

  Future<void> playMetronomeTick() async {
    if (!_inited) await init();
    await _ensureTick();
    if (_tick != null) {
      await _soloud.play(_tick!);
    } else {
      await _ensureClick();
      if (_click != null) await _soloud.play(_click!);
    }
  }

  Future<void> dispose() async { try { await _soloud.deinit(); } catch (_) {} }
}
