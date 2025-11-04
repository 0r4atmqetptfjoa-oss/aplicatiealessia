import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import 'package:rive/rive.dart' hide Image;
import 'package:lumea_alessiei/main.dart'; // Import pentru localeProvider

// Buton de meniu refolosit
class MenuButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imagePath, width: 120, height: 120),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 2.0)],
            ),
          ),
        ],
      ),
    );
  }
}

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {
  late VideoPlayerController _videoController;
  Artboard? _titleArtboard;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset('assets/video/menu/main_background_loop.mp4')
      ..initialize().then((_) {
        _videoController.setLooping(true);
        _videoController.play();
        setState(() {});
      });

    RiveFile.asset('assets/rive/title.riv').then((file) {
      final artboard = file.mainArtboard.instance();
      artboard.addController(SimpleAnimation('Timeline 1'));
      setState(() => _titleArtboard = artboard);
    });
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
          if (_videoController.value.isInitialized)
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

          Container(color: Colors.black.withOpacity(0.4)),

          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                SizedBox(
                  height: 120,
                  child: _titleArtboard != null
                      ? Rive(artboard: _titleArtboard!)
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    MenuButton(
                      imagePath: 'assets/images/menu/icon_sunete.png',
                      label: l10n.menuSounds,
                      onTap: () => context.go('/sounds'),
                    ),
                    MenuButton(
                      imagePath: 'assets/images/menu/icon_instrumente.png',
                      label: l10n.menuInstruments,
                      onTap: () => context.go('/instruments'),
                    ),
                    MenuButton(
                      imagePath: 'assets/images/menu/icon_cantece.png',
                      label: l10n.menuSongs,
                      onTap: () => context.go('/songs'),
                    ),
                    MenuButton(
                      imagePath: 'assets/images/menu/icon_povesti.png',
                      label: l10n.menuStories,
                      onTap: () => context.go('/stories'),
                    ),
                    MenuButton(
                      imagePath: 'assets/images/menu/icon_jocuri.png',
                      label: l10n.menuGames,
                      onTap: () => context.go('/games'),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),

          // Butoanele de schimbare a limbii
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLanguageButton(context, ref, 'RO', const Locale('ro')),
                  const SizedBox(width: 8),
                  _buildLanguageButton(context, ref, 'EN', const Locale('en')),
                ],
              ),
            ),
          ),

          // Butonul de setări
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
    );
  }

  Widget _buildLanguageButton(BuildContext context, WidgetRef ref, String label, Locale locale) {
    final currentLocale = ref.watch(localeProvider);
    final isSelected = currentLocale == locale;

    return ElevatedButton(
      onPressed: () {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
        foregroundColor: Colors.black,
      ),
      child: Text(label),
    );
  }
}
