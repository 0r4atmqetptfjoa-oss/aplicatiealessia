import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:rive/rive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import '../../core/widgets/rive_button.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {
  late VideoPlayerController _videoController;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/video/menu/main_background_loop.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _videoInitialized = true;
            _videoController.play();
          });
        }
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_videoInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            )
          else
            Container(color: Colors.black),
          Container(color: Colors.black.withOpacity(0.3)),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: RiveAnimation.asset(
                          'assets/rive/title.riv',
                          artboard: 'TITLE_ANIMATION',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24,
                        runSpacing: 24,
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
                    ],
                  ),
                ),
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
    );
  }
}
