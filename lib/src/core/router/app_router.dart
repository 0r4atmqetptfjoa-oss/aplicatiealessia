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

// Import new game screens
import '../../features/games/memory_game_screen.dart';
import '../../features/games/shapes_game_screen.dart';
import '../../features/games/colors_game_screen.dart';
import '../../features/games/math_quiz_game_screen.dart';
import '../../features/games/puzzle2_game_screen.dart';
import '../../features/games/instruments_game_screen.dart';
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
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const SplashScreen()),
      ),
      GoRoute(
        path: '/profiles',
        name: 'profiles',
        pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const ProfileSelectionScreen()),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const MainMenuScreen()),
      ),
      GoRoute(
        path: '/paywall',
        name: 'paywall',
        pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const PaywallScreen()),
      ),
      GoRoute(
        path: '/parental-gate',
        name: 'parentalGate',
        pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const ParentalGateScreen()),
      ),
      GoRoute(
        path: '/sounds',
        name: 'sounds',
        pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const SoundsMenuScreen()),
        routes: [
          GoRoute(
            path: ':category',
            name: 'soundsDetail',
            pageBuilder: (context, state) => _buildPageWithTransition(
              key: state.pageKey,
              child: SoundCategoryScreen(category: state.pathParameters['category'] ?? ''),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/instruments',
        name: 'instruments',
        pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const InstrumentsScreen()),
      ),
      GoRoute(
        path: '/songs',
        name: 'songs',
        pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const SongsMenuScreen()),
        routes: [
          GoRoute(
            path: 'play/:songId',
            name: 'songPlayer',
            pageBuilder: (context, state) => _buildPageWithTransition(
              key: state.pageKey,
              child: SongPlayerScreen(songId: state.pathParameters['songId']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/stories',
        name: 'stories',
        pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const StoriesMenuScreen()),
        routes: [
          GoRoute(
            path: 'play/:storyId',
            name: 'storyPlayer',
            pageBuilder: (context, state) => _buildPageWithTransition(
              key: state.pageKey,
              child: StoryPlayerScreen(storyId: state.pathParameters['storyId']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/games',
        name: 'games',
        pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const GamesMenuScreen()),
        routes: [
          GoRoute(
            path: 'alphabet',
            name: 'alphabetGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const AlphabetGameScreen()),
          ),
          GoRoute(
            path: 'numbers',
            name: 'numbersGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const NumbersGameScreen()),
          ),
          GoRoute(
            path: 'puzzle',
            name: 'puzzleGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const PuzzleGameScreen()),
          ),
          // New game routes
          GoRoute(
            path: 'memory',
            name: 'memoryGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const MemoryGameScreen()),
          ),
          GoRoute(
            path: 'shapes',
            name: 'shapesGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const ShapesGameScreen()),
          ),
          GoRoute(
            path: 'colors',
            name: 'colorsGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const ColorsGameScreen()),
          ),
          GoRoute(
            path: 'math_quiz',
            name: 'mathQuizGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const MathQuizGameScreen()),
          ),
          GoRoute(
            path: 'puzzle_2',
            name: 'puzzle2Game',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const Puzzle2GameScreen()),
          ),
          GoRoute(
            path: 'instruments_game',
            name: 'instrumentsGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const InstrumentsGameScreen()),
          ),
          GoRoute(
            path: 'sorting_animals',
            name: 'sortingAnimalsGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const SortingAnimalsGameScreen()),
          ),
          GoRoute(
            path: 'cooking',
            name: 'cookingGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const CookingGameScreen()),
          ),
          GoRoute(
            path: 'maze',
            name: 'mazeGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const MazeGameScreen()),
          ),
          GoRoute(
            path: 'hidden_objects',
            name: 'hiddenObjectsGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const HiddenObjectsGameScreen()),
          ),
          GoRoute(
            path: 'blocks',
            name: 'blocksGame',
            pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: const BlocksGameScreen()),
          ),
        ],
      ),
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
