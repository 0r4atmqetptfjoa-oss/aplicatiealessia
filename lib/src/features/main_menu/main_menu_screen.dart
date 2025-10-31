import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import '../../core/widgets/rive_button.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> with TickerProviderStateMixin {
  Artboard? _titleArtboard;
  Artboard? _backgroundArtboard;
  StateMachineController? _backgroundController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeAnimationController);
    _initializeAssets();
  }

  Future<void> _initializeAssets() async {
    try {
      final titleFile = await RiveFile.asset('assets/rive/title.riv');
      final titleArtboard = titleFile.mainArtboard.instance();
      titleArtboard.addController(SimpleAnimation('Timeline 1'));

      final backgroundFile = await RiveFile.asset('assets/rive/background.riv');
      final backgroundArtboard = backgroundFile.mainArtboard.instance();
      _backgroundController = StateMachineController.fromArtboard(backgroundArtboard, 'State Machine 1');
      if (_backgroundController != null) {
        backgroundArtboard.addController(_backgroundController!);
      }

      if (mounted) {
        setState(() {
          _titleArtboard = titleArtboard;
          _backgroundArtboard = backgroundArtboard;
        });
        _fadeAnimationController.forward();
      }
    } catch (e) {
      // Errors are logged visually in debug mode, no need for print.
    }
  }

  @override
  void dispose() {
    _backgroundController?.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_backgroundController != null) {
      final SMINumber? xInput = _backgroundController!.findInput<double>('x') as SMINumber?;
      final SMINumber? yInput = _backgroundController!.findInput<double>('y') as SMINumber?;
      if (xInput != null && yInput != null) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(event.position);
        xInput.value = localPosition.dx;
        yInput.value = localPosition.dy;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Listener(
        onPointerMove: _onPointerMove,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_backgroundArtboard != null)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Rive(artboard: _backgroundArtboard!, fit: BoxFit.cover),
              )
            else
              Container(color: Colors.black),
            Container(color: Colors.black.withAlpha(77)),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                    height: 100,
                    child: _titleArtboard != null
                        ? Rive(artboard: _titleArtboard!)
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      RiveButton(
                        riveAsset: 'assets/rive/menu_buttons.riv',
                        artboardName: 'BTN_SUNETE',
                        stateMachineName: 'State Machine 1',
                        onTap: () => context.go('/sounds'),
                        label: l10n.menuSounds,
                      ),
                      RiveButton(
                        riveAsset: 'assets/rive/menu_buttons.riv',
                        artboardName: 'BTN_INSTRUMENTE',
                        stateMachineName: 'State Machine 1',
                        onTap: () => context.go('/instruments'),
                        label: l10n.menuInstruments,
                      ),
                      RiveButton(
                        riveAsset: 'assets/rive/menu_buttons.riv',
                        artboardName: 'BTN_CANTECE',
                        stateMachineName: 'State Machine 1',
                        onTap: () => context.go('/songs'),
                        label: l10n.menuSongs,
                      ),
                      RiveButton(
                        riveAsset: 'assets/rive/menu_buttons.riv',
                        artboardName: 'BTN_POVESTI',
                        stateMachineName: 'State Machine 1',
                        onTap: () => context.go('/stories'),
                        label: l10n.menuStories,
                      ),
                      RiveButton(
                        riveAsset: 'assets/rive/menu_buttons.riv',
                        artboardName: 'BTN_JOCURI',
                        stateMachineName: 'State Machine 1',
                        onTap: () => context.go('/games'),
                        label: l10n.menuGames,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: const Icon(Icons.settings, size: 40, color: Colors.white),
                        onPressed: () => context.go('/parental-gate'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
