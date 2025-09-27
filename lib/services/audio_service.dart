import 'package:flutter_soloud/flutter_soloud.dart';

class AudioService {
  final SoLoud _soLoud = SoLoud.instance;
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    await _soLoud.init();
    _ready = true;
  }

  Future<int?> playAsset(String assetPath, {bool loop = false}) async {
    if (!_ready) await init();
    try {
      final src = await _soLoud.loadAsset(assetPath);
      final handle = await _soLoud.play(src, loop: loop);
      return handle;
    } catch (_) {
      return null;
    }
  }

  Future<void> stop(int handle) async {
    if (!_ready) return;
    await _soLoud.stop(handle);
  }

  Future<void> dispose() async {
    if (!_ready) return;
    await _soLoud.deinit();
    _ready = false;
  }
}
