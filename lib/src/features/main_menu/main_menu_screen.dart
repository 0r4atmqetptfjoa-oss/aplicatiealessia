import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'rive_menu_button.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late final VideoPlayerController _videoController;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'assets/video/menu/main_background_loop.mp4',
    )
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          _videoInitialized = true;
        });
        _videoController.play();
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
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.mainMenuTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24,
                        runSpacing: 24,
                        children: [
                          RiveMenuButton(
                            riveAsset: 'assets/rive/menu_buttons.riv',
                            artboardName: 'BTN_SUNETE',
                            stateMachineName: 'State Machine 1',
                            onTap: () => context.go('/sounds'),
                            label: l10n.sounds,
                          ),
                          RiveMenuButton(
                            riveAsset: 'assets/rive/menu_buttons.riv',
                            artboardName: 'BTN_INSTRUMENTE',
                            stateMachineName: 'State Machine 1',
                            onTap: () => context.go('/instruments'),
                            label: l10n.instruments,
                          ),
                          RiveMenuButton(
                            riveAsset: 'assets/rive/menu_buttons.riv',
                            artboardName: 'BTN_CANTECE',
                            stateMachineName: 'State Machine 1',
                            onTap: () => context.go('/songs'),
                            label: l10n.songs,
                          ),
                          RiveMenuButton(
                            riveAsset: 'assets/rive/menu_buttons.riv',
                            artboardName: 'BTN_POVESTI',
                            stateMachineName: 'State Machine 1',
                            onTap: () => context.go('/stories'),
                            label: l10n.stories,
                          ),
                          RiveMenuButton(
                            riveAsset: 'assets/rive/menu_buttons.riv',
                            artboardName: 'BTN_JOCURI',
                            stateMachineName: 'State Machine 1',
                            onTap: () => context.go('/games'),
                            label: l10n.games,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white, size: 40),
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
