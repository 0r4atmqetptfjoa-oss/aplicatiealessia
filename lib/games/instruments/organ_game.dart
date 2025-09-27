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

class OrganGame extends FlameGame with HasTappables {
    final abVar = getIt<ABTestService>().getVariant('particles');
    final factor = abVar == 'B' ? 1.6 : 1.0;
  final List<_ShellKey> _keys = [];
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

    const int shells = 5;
    final double margin = 24;
    final double width = (1080 - margin * (shells + 1)) / shells;
    final double height = 340;
    final double baseY = 1920 - height - 100;
    final ids = ['organ_c4','organ_d4','organ_e4','organ_g4','organ_a4'];

    for (int i = 0; i < shells; i++) {
      final x = margin + i * (width + margin);
      final y = baseY - (i % 2) * 20;
      final key = _ShellKey(
        index: i,
        label: 'S${i+1}',
        audioId: ids[i],
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu clapă-scoică finală 'scoica_[i].png'
        spritePath: 'assets/images/placeholders/placeholder_square.png',
        size: Vector2(width, height),
        position: Vector2(x + width/2, y + height/2),
        onTap: (idx) async {
          recorder.onTap(idx);
          await coach.onUserTap(idx);
        },
      );
      _keys.add(key);
      add(key);
    }

    coach = RhythmCoach(
      count: _keys.length,
      highlight: (i, on) => _keys[i].highlight(on),
      playAt: (i) async => getIt<AudioService>().playNote(_keys[i].audioId),
      celebrate: () async {
        zanaAnimation.value = 'dance_fast';
        _splash();
        final id = await getIt<ProgressService>().addRoundAndMaybeSticker('organ');
        if (id != null) {
          _splash();
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
      baseBpm: 92,
      maxBpm: 140,
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
      await getIt<AudioService>().playNote(_keys[i].audioId);
    });
  }

  void _splash() {
    final rnd = Random();
    add(ParticleSystemComponent(
      particle: Particle.generate(
        count: ( 52 * factor ).toInt(),
        lifespan: 0.7,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 680),
          speed: Vector2((rnd.nextDouble()-0.5)*420, -rnd.nextDouble()*540),
          position: Vector2(size.x/2, size.y*0.43),
          child: CircleParticle(radius: 2 + rnd.nextDouble()*2.5, paint: Paint()..color = const Color(0xFF7E57C2)),
        ),
      ),
    ));
  }
}

class _ShellKey extends SpriteComponent with TapCallbacks, HasGameRef<OrganGame> {
  final int index;
  final String label;
  final String audioId;
  final Future<void> Function(int index) onTap;
  _ShellKey({required this.index, required this.label, required this.audioId, required String spritePath, super.size, super.position, required this.onTap}) {
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
      add(SequenceEffect([
        ScaleEffect.to(Vector2(0.96, 0.9), EffectController(duration: 0.06, curve: Curves.easeOut)),
        MoveByEffect(Vector2(0, 6), EffectController(duration: 0.06)),
      ]));
    } else {
      add(SequenceEffect([
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)),
        MoveByEffect(Vector2(0, -6), EffectController(duration: 0.12, curve: Curves.easeOutBack)),
      ]));
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(SequenceEffect([
      ScaleEffect.to(Vector2(0.96, 0.9), EffectController(duration: 0.06, curve: Curves.easeOut)),
      MoveByEffect(Vector2(0, 6), EffectController(duration: 0.06)),
    ]));
  }

  @override
  Future<void> onTapUp(TapUpEvent event) async {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)),
      MoveByEffect(Vector2(0, -6), EffectController(duration: 0.12, curve: Curves.easeOutBack)),
    ]));
    await onTap(index);
  }
}
