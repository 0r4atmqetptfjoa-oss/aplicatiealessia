import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:alesia/games/shared/base_instrument_game.dart';

class PianoGame extends BaseInstrumentGame {
  PianoGame() : super(instrumentId: 'piano');

  final zana = ValueNotifier<String>('idle');

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // TODO: Adaugă elementele specifice jocului de pian
  }
}