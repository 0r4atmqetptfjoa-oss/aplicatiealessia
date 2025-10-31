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

// Game Screens
import '../../features/games/alphabet_game_screen.dart';
import '../../features/games/numbers_game_screen.dart';
import '../../features/games/puzzle_game_screen.dart';
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
  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) async {
      final profileService = ref.read(userProfileServiceProvider);
      final activeProfileId = await profileService.getActiveProfileId();
      if (state.uri.toString() == '/') {
        await Future.delayed(const Duration(seconds: 2));
        return activeProfileId == null ? '/profiles' : '/home';
      }
      // Add premium content check here if needed
      return null;
    },
    routes: <RouteBase>[
      _buildRoute('/', 'splash', const SplashScreen()),
      _buildRoute('/profiles', 'profiles', const ProfileSelectionScreen()),
      _buildRoute('/home', 'home', const MainMenuScreen()),
      _buildRoute('/paywall', 'paywall', const PaywallScreen()),
      _buildRoute('/parental-gate', 'parentalGate', const ParentalGateScreen()),
      _buildRoute('/sounds', 'sounds', const SoundsMenuScreen(), routes: [
        _buildRoute(':category', 'soundsDetail', (state) => SoundCategoryScreen(category: state.pathParameters['category']!)),
      ]),
      _buildRoute('/instruments', 'instruments', const InstrumentsScreen()),
      _buildRoute('/songs', 'songs', const SongsMenuScreen(), routes: [
        _buildRoute('play/:songId', 'songPlayer', (state) => SongPlayerScreen(songId: state.pathParameters['songId']!)),
      ]),
      _buildRoute('/stories', 'stories', const StoriesMenuScreen(), routes: [
        _buildRoute('play/:storyId', 'storyPlayer', (state) => StoryPlayerScreen(storyId: state.pathParameters['storyId']!)),
      ]),
      _buildRoute('/games', 'games', const GamesMenuScreen(), routes: [
        _buildRoute('alphabet', 'alphabetGame', const AlphabetGameScreen()),
        _buildRoute('numbers', 'numbersGame', const NumbersGameScreen()),
        _buildRoute('puzzle', 'puzzleGame', const PuzzleGameScreen()),
        _buildRoute('memory', 'memoryGame', const MemoryGameScreen()),
        _buildRoute('shapes', 'shapesGame', const ShapesGameScreen()),
        _buildRoute('colors', 'colorsGame', const ColorsGameScreen()),
        _buildRoute('math_quiz', 'mathQuizGame', const MathQuizGameScreen()),
        _buildRoute('puzzle_2', 'puzzle2Game', const Puzzle2GameScreen()),
        _buildRoute('instruments_game', 'instrumentsGame', const InstrumentsGameScreen()),
        _buildRoute('sorting_animals', 'sortingAnimalsGame', const SortingAnimalsGameScreen()),
        _buildRoute('cooking', 'cookingGame', const CookingGameScreen()),
        _buildRoute('maze', 'mazeGame', const MazeGameScreen()),
        _buildRoute('hidden_objects', 'hiddenObjectsGame', const HiddenObjectsGameScreen()),
        _buildRoute('blocks', 'blocksGame', const BlocksGameScreen()),
      ]),
    ],
    errorBuilder: (c, s) => Scaffold(appBar: AppBar(title: const Text('Error')), body: Center(child: Text('Page not found: ${s.uri}'))),
  );
});

GoRoute _buildRoute(String path, String name, dynamic child, {List<RouteBase> routes = const []}) {
  return GoRoute(
    path: path,
    name: name,
    pageBuilder: (context, state) => _buildPageWithTransition(key: state.pageKey, child: child is Widget ? child : child(state)),
    routes: routes,
  );
}

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
