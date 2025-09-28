import 'package:flutter/foundation.dart';
import 'package:alesia/games/shared/base_instrument_game.dart';
class DrumsGame extends BaseInstrumentGame {
  DrumsGame():super(instrumentId: 'drums');
  final zana = ValueNotifier<String>('idle');
  @override Future<void> onLoad() async{ await super.onLoad(); }
}
