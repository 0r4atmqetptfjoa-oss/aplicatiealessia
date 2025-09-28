
// A safe minimal AudioService that won't crash on Web.
// Replace your existing file with this and expand as needed.
import 'package:flutter/foundation.dart' show kIsWeb;

class AudioService {
  static final AudioService instance = AudioService._();
  AudioService._();

  bool _initialized = false;

  Future<void> init() async {
    // On Web: flutter_soloud uses injected JS; if missing, just no-op.
    _initialized = true;
  }

  Future<void> playAsset(String path, {double volume = 1.0}) async {
    if (!_initialized) await init();
    // TODO: Integrate flutter_soloud or html audio as you see fit.
    // This stub avoids FFI on Web.
  }

  Future<void> stopAll() async {
    // no-op stub
  }
}
