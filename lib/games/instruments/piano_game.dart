import 'dart:async';
import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/quest_service.dart';
import 'package:alesia/services/parental_service.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';
import 'package:alesia/games/common/rhythm_coach.dart';
import 'package:alesia/games/common/recorder.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PianoGame extends FlameGame with HasTappables {
    final abVar = getIt<ABTestService>().getVariant('particles');
    final factor = abVar == 'B' ? 1.6 : 1.0;
  final List<_InstrumentPad> _pads = [];
  late final RhythmCoach coach;
  final ValueNotifier<String> zanaAnimation = ValueNotifier('idle');
  final ValueNotifier<RhythmState> _stateProxy = ValueNotifier(const RhythmState(phase: RhythmPhase.idle, progress: 0, length: 0, streak: 0, message: 'Idle'));
  final ValueNotifier<int> beat = ValueNotifier(0);
  final ValueNotifier<int> bpm = ValueNotifier(96);
  final SimpleRecorder recorder = SimpleRecorder();
  final ValueNotifier<bool> metronomeOn = ValueNotifier(false);
  Timer? _metroTimer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1080, 1920));

    const int keys = 7;
    final double margin = 20;
    final double keyWidth = (1080 - margin * (keys + 1)) / keys;
    final double keyHeight = 380;

    for (int i = 0; i < keys; i++) {
      final x = margin + i * (keyWidth + margin);
      final y = 1920 - keyHeight - 80;
      final idMap = ['piano_do4','piano_re4','piano_mi4','piano_fa4','piano_sol4','piano_la4','piano_si4'];
      final key = _InstrumentPad(
        index: i,
        label: ['Do','Re','Mi','Fa','Sol','La','Si'][i],
        audioId: idMap[i],
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu o clapă finală 'clapa_[culoare].png'
        spritePath: 'assets/images/placeholders/placeholder_square.png',
        size: Vector2(keyWidth, keyHeight),
        position: Vector2(x + keyWidth/2, y + keyHeight/2),
        onTap: (idx) async {
          recorder.onTap(idx);
          await coach.onUserTap(idx);
        },
      );
      _pads.add(key);
      add(key);
    }

    coach = RhythmCoach(
      count: _pads.length,
      highlight: (i, on) => _pads[i].highlight(on),
      playAt: (i) async {
        await getIt<AudioService>().playNote(_pads[i].audioId);
      },
      celebrate: () async {
        zanaAnimation.value = 'dance_fast';
        _celebrateBurst();
        final id = await getIt<ProgressService>().addRoundAndMaybeSticker('piano');
        if (id != null) {
          // extra confetti la sticker
          _celebrateBurst();
        }
      },
      onBeat: (c) async {
        beat.value = c;
        if (metronomeOn.value) {
          await getIt<AudioService>().playTick();
        }
      },
      baseLength: 4,
      maxLength: 8,
      baseBpm: 96,
      maxBpm: 144,
    );
    bpm.value = coach.bpm;
    coach.state.addListener(() { _stateProxy.value = coach.state.value; });

    overlays.add('RhythmHUD');
    overlays.add('ZanaHUD');
  }

  // expunere pentru overlay
  ValueListenable<RhythmState> get coachState => _stateProxy;
  void startCoach() { zanaAnimation.value = 'dance_slow'; _stopMetronome(); coach.start(); }
  void stopCoach()  { zanaAnimation.value = 'idle'; coach.stop(); _restartMetronomeIf(); }

  void setBpm(int value) {
    bpm.value = value;
    coach.setBpm(value);
    _restartMetronomeIf();
  }

  void toggleMetronome(bool on) {
    metronomeOn.value = on;
    _restartMetronomeIf();
  }

  void _restartMetronomeIf() {
    _stopMetronome();
    if (metronomeOn.value) {
      final interval = Duration(milliseconds: (60000 / bpm.value).round());
      _metroTimer = Timer.periodic(interval, (_) async {
        beat.value = beat.value + 1;
        await getIt<AudioService>().playTick();
      });
    }
  }

  void _stopMetronome() {
    _metroTimer?.cancel();
    _metroTimer = null;
  }

  void startRecordOrStop() {
    if (!recorder.isRecording) {
      recorder.start();
    } else {
      recorder.stop();
    }
  }

  Future<void> playRecording() async {
    await recorder.play((i) async {
      await getIt<AudioService>().playNote(_pads[i].audioId);
    });
  }

  void _celebrateBurst() {
    final rnd = Random();
    add(ParticleSystemComponent(
      particle: Particle.generate(
        count: ( 60 * factor ).toInt(),
        lifespan: 0.9,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 700),
          speed: Vector2((rnd.nextDouble()-0.5)*500, -rnd.nextDouble()*600),
          position: Vector2(size.x/2, size.y*0.4),
          child: CircleParticle(radius: 2 + rnd.nextDouble()*3, paint: Paint()..color = const Color(0xFF7C4DFF)),
        ),
      ),
    ));
  }
}

class _InstrumentPad extends SpriteComponent with TapCallbacks, HasGameRef<PianoGame> {
  final int index;
  final String label;
  final String audioId;
  final Future<void> Function(int index) onTap;

  _InstrumentPad({
    required this.index,
    required this.label,
    required this.audioId,
    required String spritePath,
    required this.onTap,
    super.size,
    super.position,
  }) {
    _spritePath = spritePath;
    anchor = Anchor.center;
  }

  late final String _spritePath;
  RectangleComponent? _glow;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(_spritePath);
    add(TextComponent(
      text: label,
      anchor: Anchor.center,
      position: Vector2(0, size.y * 0.35),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 36, color: Colors.black, fontWeight: FontWeight.bold)),
    ));
    _glow = RectangleComponent(
      position: -size/2,
      size: size,
      paint: Paint()..color = const Color(0x66FFFFFF),
      anchor: Anchor.topLeft,
      priority: -1,
    )..visible = false;
    add(_glow!);
  }

  void highlight(bool on) {
    _glow?.visible = on;
    if (on) {
      add(ScaleEffect.to(Vector2(0.98, 0.94), EffectController(duration: 0.08, curve: Curves.easeOut)));
    } else {
      add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(ScaleEffect.to(Vector2(0.98, 0.94), EffectController(duration: 0.06, curve: Curves.easeOut)));
  }

  @override
  Future<void> onTapUp(TapUpEvent event) async {
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    await onTap(index);
  }
}
