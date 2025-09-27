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

class DrumsGame extends FlameGame with HasTappables {
    final abVar = getIt<ABTestService>().getVariant('particles');
    final factor = abVar == 'B' ? 1.6 : 1.0;
  final List<_DrumPad> _pads = [];
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

    final positions = [
      Vector2(360, 740), Vector2(720, 740),
      Vector2(360, 1160), Vector2(720, 1160),
    ];
    final ids = ['drum_kick','drum_snare','drum_hihat','drum_tom'];

    for (int i = 0; i < positions.length; i++) {
      final pad = _DrumPad(
        index: i,
        label: ['Kick','Snare','HiHat','Tom'][i],
        audioId: ids[i],
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu un pad final de tobă 'toba_[culoare].png'
        spritePath: 'assets/images/placeholders/placeholder_square.png',
        position: positions[i],
        size: Vector2(280, 280),
        onTap: (idx) async {
          recorder.onTap(idx);
          await coach.onUserTap(idx);
        },
      );
      _pads.add(pad);
      add(pad);
    }

    coach = RhythmCoach(
      count: _pads.length,
      highlight: (i, on) => _pads[i].highlight(on),
      playAt: (i) async => getIt<AudioService>().playNote(_pads[i].audioId),
      celebrate: () async {
        zanaAnimation.value = 'dance_fast';
        _burst(center: Vector2(size.x/2, size.y*0.45), color: const Color(0xFFFF7043));
        final id = await getIt<ProgressService>().addRoundAndMaybeSticker('drums');
        if (id != null) {
          _burst(center: Vector2(size.x/2, size.y*0.35), color: const Color(0xFFFF7043));
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
      baseBpm: 100,
      maxBpm: 152,
    );
    bpm.value = coach.bpm;
    coach.state.addListener(() { _stateProxy.value = coach.state.value; });

    overlays.add('RhythmHUD');
    overlays.add('ZanaHUD');
  }

  ValueListenable<RhythmState> get coachState => _stateProxy;
  void startCoach() { zanaAnimation.value = 'dance_slow'; _stopMetronome(); coach.start(); }
  void stopCoach()  { zanaAnimation.value = 'idle'; coach.stop(); _restartMetronomeIf(); }

  void setBpm(int value) { bpm.value = value; coach.setBpm(value); _restartMetronomeIf(); }
  void toggleMetronome(bool on) { metronomeOn.value = on; _restartMetronomeIf(); }

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

  void _burst({required Vector2 center, required Color color}) {
    final rnd = Random();
    add(ParticleSystemComponent(
      particle: Particle.generate(
        count: ( 48 * factor ).toInt(),
        lifespan: 0.6,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 700),
          speed: Vector2((rnd.nextDouble()-0.5)*450, -rnd.nextDouble()*500),
          position: center.clone(),
          child: CircleParticle(radius: 2 + rnd.nextDouble()*3, paint: Paint()..color = color),
        ),
      ),
    ));
  }
}

class _DrumPad extends SpriteComponent with TapCallbacks, HasGameRef<DrumsGame> {
  final int index;
  final String label;
  final String audioId;
  final Future<void> Function(int index) onTap;
  _DrumPad({required this.index, required this.label, required this.audioId, required String spritePath, required Vector2 position, required Vector2 size, required this.onTap})
      : super(position: position, size: size, anchor: Anchor.center) {
    _spritePath = spritePath;
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
      textRenderer: TextPaint(style: const TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold)),
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
      add(ScaleEffect.to(Vector2.all(0.9), EffectController(duration: 0.06, curve: Curves.easeOut)));
    } else {
      add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(ScaleEffect.to(Vector2.all(0.9), EffectController(duration: 0.06, curve: Curves.easeOut)));
  }

  @override
  Future<void> onTapUp(TapUpEvent event) async {
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    add(RotateEffect.by(0.1, EffectController(duration: 0.08)));
    await onTap(index);
  }
}
