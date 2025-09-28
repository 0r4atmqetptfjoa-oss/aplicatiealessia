import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Conductor {
  final ValueNotifier<int> bpm = ValueNotifier<int>(90);
  final ValueNotifier<int> beat = ValueNotifier<int>(0);
  Timer? _t;
  void setBpm(int v){ bpm.value=v.clamp(40,220); _restart(); }
  void _restart(){ _t?.cancel(); final interval=Duration(milliseconds:(60000/bpm.value).round()); _t=Timer.periodic(interval,(_){ beat.value=(beat.value+1)%4;}); }
  void start()=>_restart(); void stop(){ _t?.cancel(); _t=null; }
}
class Metronome{ final ValueNotifier<bool> isOn=ValueNotifier<bool>(false); void toggle()=>isOn.value=!isOn.value; }
class Recorder{ final ValueNotifier<bool> isRecording=ValueNotifier<bool>(false); final ValueNotifier<bool> hasRecording=ValueNotifier<bool>(false);
  void toggle(){ isRecording.value=!isRecording.value; if(!isRecording.value) hasRecording.value=true; } void play(){} }
class CoachState{ final ValueNotifier<String> state=ValueNotifier<String>('idle'); }

abstract class BaseInstrumentGame extends FlameGame{
  final String instrumentId; BaseInstrumentGame({required this.instrumentId});
  final Conductor conductor=Conductor(); final Metronome metronome=Metronome(); final Recorder recorder=Recorder(); final CoachState coach=CoachState();
  @override Future<void> onLoad() async { overlays.add('Zana'); overlays.add('Rhythm'); overlays.add('Hints'); }
}
