import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:rive/rive.dart';

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

  Widget _buildMenuButton({
    required String artboard,
    required VoidCallback onTap,
    Key? key,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        height: 120,
        child: RiveAnimation.asset(
          'assets/rive/menu_buttons.riv',
          artboard: artboard,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      const RiveAnimation.asset(
                        'assets/rive/title.riv', // Placeholder for the title animation
                        artboard: 'TITLE_ANIMATION',
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 40),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24,
                        runSpacing: 24,
                        children: [
                          _buildMenuButton(
                            artboard: 'BTN_SUNETE',
                            onTap: () => context.go('/sounds'),
                          ),
                          _buildMenuButton(
                            artboard: 'BTN_INSTRUMENTE',
                            onTap: () => context.go('/instruments'),
                          ),
                          _buildMenuButton(
                            artboard: 'BTN_CANTECE',
                            onTap: () => context.go('/songs'),
                          ),
                          _buildMenuButton(
                            artboard: 'BTN_POVESTI',
                            onTap: () => context.go('/stories'),
                          ),
                          _buildMenuButton(
                            artboard: 'BTN_JOCURI',
                            onTap: () => context.go('/games'),
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
