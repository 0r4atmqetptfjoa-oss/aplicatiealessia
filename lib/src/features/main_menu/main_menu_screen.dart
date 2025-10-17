import 'package:flutter/material.dart';

/// Placeholder for the Main Menu screen.
///
/// The actual implementation will include a looping video background,
/// animated title and buttons for each module.  Currently it provides a
/// basic scaffold so that the router can build a widget tree without
/// errors.
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
// Rive is used for animations in later phases.  For the placeholder
// implementation we avoid loading Rive assets that don't exist yet.  When
// real assets are provided, you can re-introduce the Rive imports and
// widgets.
// import 'package:rive/rive.dart';

/// The main menu for the application.
///
/// Displays a looping video background, an animated title and a row of
/// Rive-powered buttons that navigate to the different modules.  The
/// parent will ensure this screen is visible after the splash screen.
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
    // Initialize the looping background video.  The asset must exist
    // under assets/video/menu/main_background_loop.mp4 as declared in
    // pubspec.yaml.  Once initialized, the controller is set to play
    // automatically and loop.
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

  /// Builds a Rive button for the main menu.
  ///
  /// Each button loads its own artboard from the menu animations
  /// file.  A transparent [GestureDetector] is layered on top to
  /// handle taps.  Animations such as hover or press should be
  /// configured inside the Rive file.  If you wish to trigger a
  /// specific state machine input on tap, adjust the `onInit`
  /// callback accordingly.
  Widget _buildMenuButton({
    required String artboard,
    required VoidCallback onTap,
    Key? key,
  }) {
    // Placeholder implementation: use an IconButton with an icon that
    // represents the module.  When the real Rive assets become
    // available, replace this widget with a RiveAnimation as shown in
    // the commented code above.
    IconData icon;
    switch (artboard) {
      case 'BTN_SUNETE':
        icon = Icons.volume_up;
        break;
      case 'BTN_INSTRUMENTE':
        icon = Icons.piano;
        break;
      case 'BTN_CANTECE':
        icon = Icons.music_note;
        break;
      case 'BTN_POVESTI':
        icon = Icons.menu_book;
        break;
      case 'BTN_JOCURI':
      default:
        icon = Icons.extension;
        break;
    }
    return IconButton(
      iconSize: 64,
      color: Colors.white,
      onPressed: onTap,
      icon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background video layer
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
            // Show a placeholder while the video initializes
            Container(color: Colors.black),
          // Semi-transparent overlay to improve contrast
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Foreground: title and buttons
          SafeArea(
            child: Column(
              children: [
                // The central section (title + buttons) expands to fill
                // available space to prevent overflow on devices with
                // limited vertical height.
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title: Use plain text while placeholder assets
                      // are in use.  Replace this with a Rive animation
                      // when the real file is available.
                      const Text(
                        'Lumea Alessiei',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      // Row of menu buttons.  Use Wrap so that
                      // buttons automatically wrap to the next line on
                      // narrow screens, preventing overflow in
                      // landscape mode.
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
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
                // Parental control/settings button anchored to bottom
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
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