import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumea_alessiei/src/features/paywall/paywall_screen.dart';
import 'package:lumea_alessiei/src/features/profiles/profile_selection_screen.dart';
import 'package:lumea_alessiei/src/services/subscription_service.dart';
import 'package:lumea_alessiei/src/services/user_profile_service.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/main_menu/main_menu_screen.dart';
import '../../features/parental_gate/parental_gate_screen.dart';
import '../../features/sounds/sounds_menu_screen.dart';
import '../../features/sounds/sound_category_screen.dart';
import '../../features/instruments/instruments_screen.dart';
import '../../features/songs/songs_menu_screen.dart';
import '../../features/songs/song_player_screen.dart';
import '../../features/stories/stories_menu_screen.dart';
import '../../features/stories/story_player_screen.dart';
import '../../features/games/games_menu_screen.dart';
import '../../features/games/puzzle_game_screen.dart';
import '../../features/games/alphabet_game_screen.dart';
import '../../features/games/numbers_game_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  const premiumSongs = {'twinkle_twinkle'};
  const premiumStories = {'scufita_rosie'};

  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) async {
      final profileService = ref.read(userProfileServiceProvider);
      final subscriptionService = ref.read(subscriptionServiceProvider);

      final activeProfileId = await profileService.getActiveProfileId();
      final isAtSplash = state.uri.toString() == '/';

      if (isAtSplash) {
        await Future.delayed(const Duration(seconds: 2));
        return activeProfileId == null ? '/profiles' : '/home';
      }

      final isSubscribed = subscriptionService.isSubscribed;
      final goingToSong = state.uri.toString().startsWith('/songs/play/');
      final goingToStory = state.uri.toString().startsWith('/stories/play/');

      if (!isSubscribed) {
        if (goingToSong) {
          final songId = state.pathParameters['songId']!;
          if (premiumSongs.contains(songId)) return '/paywall';
        }
        if (goingToStory) {
          final storyId = state.pathParameters['storyId']!;
          if (premiumStories.contains(storyId)) return '/paywall';
        }
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(path: '/', name: 'splash', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/profiles', name: 'profiles', builder: (c, s) => const ProfileSelectionScreen()),
      GoRoute(path: '/home', name: 'home', builder: (c, s) => const MainMenuScreen()),
      GoRoute(path: '/paywall', name: 'paywall', builder: (c, s) => const PaywallScreen()),
      GoRoute(path: '/parental-gate', name: 'parentalGate', builder: (c, s) => const ParentalGateScreen()),
      GoRoute(
        path: '/sounds',
        name: 'sounds',
        builder: (c, s) => const SoundsMenuScreen(),
        routes: [
          GoRoute(
            path: ':category',
            name: 'soundsDetail',
            builder: (c, s) => SoundCategoryScreen(category: s.pathParameters['category'] ?? ''),
          ),
        ],
      ),
      GoRoute(
        path: '/instruments',
        name: 'instruments',
        builder: (c, s) => const InstrumentsScreen(),
      ),
      GoRoute(
        path: '/songs',
        name: 'songs',
        builder: (c, s) => const SongsMenuScreen(),
        routes: [
          GoRoute(
            path: 'play/:songId',
            name: 'songPlayer',
            builder: (c, s) => SongPlayerScreen(songId: s.pathParameters['songId']!),
          ),
        ],
      ),
      GoRoute(
        path: '/stories',
        name: 'stories',
        builder: (c, s) => const StoriesMenuScreen(),
        routes: [
          GoRoute(
            path: 'play/:storyId',
            name: 'storyPlayer',
            builder: (c, s) => StoryPlayerScreen(storyId: s.pathParameters['storyId']!),
          ),
        ],
      ),
      GoRoute(
        path: '/games',
        name: 'games',
        builder: (c, s) => const GamesMenuScreen(),
        routes: [
          GoRoute(path: 'alphabet', name: 'alphabetGame', builder: (c, s) => const AlphabetGameScreen()),
          GoRoute(path: 'numbers', name: 'numbersGame', builder: (c, s) => const NumbersGameScreen()),
          GoRoute(path: 'puzzle', name: 'puzzleGame', builder: (c, s) => const PuzzleGameScreen()),
        ],
      ),
    ],
    errorBuilder: (c, s) => Scaffold(appBar: AppBar(title: const Text('Error')), body: Center(child: Text('Page not found: ${s.uri}'))),
  );
});
