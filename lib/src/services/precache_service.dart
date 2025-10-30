import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:video_player/video_player.dart';
import '../core/data_provider.dart';

class PrecacheService {
  Future<void> precacheCriticalAssets(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      // Pre-cache main menu video
      final videoController = VideoPlayerController.asset('assets/video/menu/main_background_loop.mp4');
      await videoController.initialize();
      videoController.dispose();

      // Pre-cache main menu Rive animations
      await RiveFile.asset('assets/rive/menu_buttons.riv');
      await RiveFile.asset('assets/rive/title.riv');

      // Pre-cache the first icon from each sound category dynamically
      final appData = await ref.read(appDataProvider.future);
      final categories = appData.sounds['categories'] as List;

      for (var category in categories) {
        final iconPath = 'assets/images/sounds_module/categories/${category['id']}.png';
        if (context.mounted) {
          try {
            await precacheImage(AssetImage(iconPath), context);
          } catch (e) {
            // Using print in a development tool is acceptable.
            // ignore: avoid_print
            print('Could not precache image: $iconPath. Error: $e');
          }
        }
      }
    } catch (e) {
      // Using print in a development tool is acceptable.
      // ignore: avoid_print
      print('A critical asset failed to precache. Error: $e');
    }
  }
}

final precacheServiceProvider = Provider<PrecacheService>((ref) {
  return PrecacheService();
});
