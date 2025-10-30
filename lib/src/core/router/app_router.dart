import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';
import 'package:lumea_alessiei/src/features/paywall/paywall_screen.dart';
import 'package:lumea_alessiei/src/features/profiles/profile_selection_screen.dart';
import 'package:lumea_alessiei/src/services/subscription_service.dart';
import 'package:lumea_alessiei/src/services/user_profile_service.dart';

import '../app_animations.dart';
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
import '../../features/games/memory_game_screen.dart';
import '../../features/games/shapes_game_screen.dart';
import '../../features/games/colors_game_screen.dart';
import '../../features/games/math_quiz_screen.dart';
import '../../features/games/puzzle_2_game_screen.dart';
import '../../features/games/sorting_animals_game_screen.dart';
import '../../features/games/cooking_game_screen.dart';
import '../../features/games/maze_game_screen.dart';
import '../../features/games/hidden_objects_game_screen.dart';
import '../../features/games/blocks_game_screen.dart';

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
          final songId = state.pathParameters['songId'];
          if (songId != null && premiumSongs.contains(songId)) return '/paywall';
        }
        if (goingToStory) {
          final storyId = state.pathParameters['storyId'];
          if (storyId != null && premiumStories.contains(storyId)) return '/paywall';
        }
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(path: '/', name: 'splash', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const SplashScreen())),
      GoRoute(path: '/profiles', name: 'profiles', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const ProfileSelectionScreen())),
      GoRoute(path: '/home', name: 'home', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const MainMenuScreen())),
      GoRoute(path: '/paywall', name: 'paywall', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const PaywallScreen())),
      GoRoute(path: '/parental-gate', name: 'parentalGate', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const ParentalGateScreen())),
      GoRoute(
          path: '/sounds',
          name: 'sounds',
          pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const SoundsMenuScreen()),
          routes: [
            GoRoute(
                path: ':category',
                name: 'soundsDetail',
                pageBuilder: (c, s) => _buildPageWithTransition(
                    key: s.pageKey, child: SoundCategoryScreen(category: s.pathParameters['category'] ?? ''))),
          ]),
      GoRoute(
        path: '/instruments',
        name: 'instruments',
        pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const InstrumentsScreen()),
      ),
      GoRoute(
          path: '/songs',
          name: 'songs',
          pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const SongsMenuScreen()),
          routes: [
            GoRoute(
                path: 'play/:songId',
                name: 'songPlayer',
                pageBuilder: (c, s) => _buildPageWithTransition(
                    key: s.pageKey, child: SongPlayerScreen(songId: s.pathParameters['songId'] ?? ''))),
          ]),
      GoRoute(
          path: '/stories',
          name: 'stories',
          pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const StoriesMenuScreen()),
          routes: [
            GoRoute(
                path: 'play/:storyId',
                name: 'storyPlayer',
                pageBuilder: (c, s) => _buildPageWithTransition(
                    key: s.pageKey, child: StoryPlayerScreen(storyId: s.pathParameters['storyId'] ?? ''))),
          ]),
      GoRoute(
          path: '/games',
          name: 'games',
          pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const GamesMenuScreen()),
          routes: [
            GoRoute(path: 'alphabet', name: 'alphabetGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const AlphabetGameScreen())),
            GoRoute(path: 'numbers', name: 'numbersGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const NumbersGameScreen())),
            GoRoute(path: 'puzzle', name: 'puzzleGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const PuzzleGameScreen())),
            GoRoute(path: 'memory', name: 'memoryGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const MemoryGameScreen())),
            GoRoute(path: 'shapes', name: 'shapesGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const ShapesGameScreen())),
            GoRoute(path: 'colors', name: 'colorsGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const ColorsGameScreen())),
            GoRoute(path: 'math_quiz', name: 'mathQuizGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const MathQuizScreen())),
            GoRoute(path: 'puzzle_2', name: 'puzzle2Game', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const Puzzle2GameScreen())),
            GoRoute(path: 'instruments_game', name: 'instrumentsGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const InstrumentsScreen())),
            GoRoute(path: 'sorting_animals', name: 'sortingAnimalsGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const SortingAnimalsGameScreen())),
            GoRoute(path: 'cooking', name: 'cookingGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const CookingGameScreen())),
            GoRoute(path: 'maze', name: 'mazeGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const MazeGameScreen())),
            GoRoute(path: 'hidden_objects', name: 'hiddenObjectsGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const HiddenObjectsGameScreen())),
            GoRoute(path: 'blocks', name: 'blocksGame', pageBuilder: (c, s) => _buildPageWithTransition(key: s.pageKey, child: const BlocksGameScreen())),
          ]),
    ],
    errorBuilder: (c, s) => Scaffold(appBar: AppBar(title: const Text('Error')), body: Center(child: Text('Page not found: ${s.uri}'))),
  );
});

Page<dynamic> _buildPageWithTransition({required LocalKey key, required Widget child}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.scaled,
        child: child,
      );
    },
    transitionDuration: AppAnimations.mediumDuration,
  );
}
