import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:rive/rive.dart' as rive;

/// Controller simplu pentru integrarea Rive "Zâna Melodia" în jocuri.
class ZanaController {
  late final RiveComponent component;
  rive.SimpleAnimation? _simple;
  rive.StateMachineController? _sm;
  late final rive.Artboard _artboard;

  Future<RiveComponent> load({Vector2? size}) async {
    // TODO (Răzvan): Înlocuiește cu Rive-ul final, cu state machine & animații corecte.
    final file = await rive.RiveFile.asset('assets/rive/zana_melodia.riv');
    _artboard = file.mainArtboard;

    // Încearcă să folosești o mașină de stări numită 'Main' sau 'State Machine 1'; altfel SimpleAnimation('idle').
    _sm = rive.StateMachineController.fromArtboard(_artboard, 'Main')
        ?? rive.StateMachineController.fromArtboard(_artboard, 'State Machine 1');

    if (_sm != null) {
      _artboard.addController(_sm!);
    } else {
      _simple = rive.SimpleAnimation('idle');
      _artboard.addController(_simple!);
    }

    component = RiveComponent(artboard: _artboard, size: size ?? Vector2.all(220));
    component.priority = 100;
    return component;
  }

  void _setSimple(String name) {
    if (_simple != null) {
      _artboard.removeController(_simple!);
    }
    _simple = rive.SimpleAnimation(name);
    _artboard.addController(_simple!);
  }

  void idle() => _setSimple('idle');
  void danceSlow() => _setSimple('dance_slow');
  void danceFast() => _setSimple('dance_fast');
  void endingPose() => _setSimple('ending_pose');
}
