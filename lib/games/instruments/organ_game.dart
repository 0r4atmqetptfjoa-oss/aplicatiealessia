import 'package:flutter/foundation.dart';
import 'package:alesia/games/shared/base_instrument_game.dart';
class OrganGame extends BaseInstrumentGame {
  OrganGame():super(instrumentId: 'organ');
  final zana = ValueNotifier<String>('idle');
  @override Future<void> onLoad() async{ await super.onLoad(); }
}
