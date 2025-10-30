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
  Artboard? _titleArtboard;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAssets();
  }

  Future<void> _initializeAssets() async {
    _videoController = VideoPlayerController.asset('assets/video/menu/main_background_loop.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _videoInitialized = true);
          _videoController.play();
        }
      });

    try {
      final riveFile = await RiveFile.asset('assets/rive/title.riv');
      final artboard = riveFile.mainArtboard;
      artboard.addController(SimpleAnimation('Timeline 1'));
      if (mounted) {
        setState(() => _titleArtboard = artboard);
      }
    } catch (e) {
      // Errors are logged visually in debug mode, no need for print.
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
    );
  }
}
