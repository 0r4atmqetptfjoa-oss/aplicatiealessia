import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import stub screens for the initial routing configuration.  These
// placeholders will be fleshed out in subsequent phases of the project.
import '../../features/splash/splash_screen.dart';
import '../../features/main_menu/main_menu_screen.dart';
import '../../features/parental_gate/parental_gate_screen.dart';
import '../../features/sounds/sounds_menu_screen.dart';
import '../../features/sounds/sound_category_screen.dart'; // Import the new unified screen
import '../../features/instruments/instruments_screen.dart';
import '../../features/songs/songs_menu_screen.dart';
import '../../features/songs/song_player_screen.dart';
import '../../features/stories/stories_menu_screen.dart';
import '../../features/stories/story_player_screen.dart';
import '../../features/games/games_menu_screen.dart';
import '../../features/games/puzzle_game_screen.dart';
import '../../features/games/alphabet_game_screen.dart';
import '../../features/games/numbers_game_screen.dart';

/// A Riverpod provider that exposes the application's router.
///
/// By defining the router as a provider we make it easy to read
/// elsewhere in the app (for example in unit tests).  The router
/// declares all top‑level routes up front.  Nested or parameterized
/// routes can be added as the application grows.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
        redirect: (BuildContext context, GoRouterState state) async {
          // Simulate a delay for the splash screen
          await Future.delayed(const Duration(seconds: 2));
          return '/home';
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const MainMenuScreen();
        },
      ),
      GoRoute(
        path: '/parental-gate',
        name: 'parentalGate',
        builder: (BuildContext context, GoRouterState state) {
          return const ParentalGateScreen();
        },
      ),
      GoRoute(
        path: '/sounds',
        name: 'sounds',
        builder: (BuildContext context, GoRouterState state) {
          return const SoundsMenuScreen();
        },
        routes: [
          GoRoute(
            path: ':category',
            name: 'soundsDetail',
            builder: (BuildContext context, GoRouterState state) {
              final category = state.pathParameters['category'] ?? '';
              return SoundCategoryScreen(category: category);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/instruments',
        name: 'instruments',
        builder: (BuildContext context, GoRouterState state) {
          return const InstrumentsScreen();
        },
      ),
      GoRoute(
        path: '/songs',
        name: 'songs',
        builder: (BuildContext context, GoRouterState state) {
          return const SongsMenuScreen();
        },
        routes: [
          GoRoute(
            path: 'play/:songId',
            name: 'songPlayer',
            builder: (BuildContext context, GoRouterState state) {
              final songId = state.pathParameters['songId'];
              if (songId == null) {
                return const Text('Error: songId is missing');
              }
              return SongPlayerScreen(songId: songId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/stories',
        name: 'stories',
        builder: (BuildContext context, GoRouterState state) {
          return const StoriesMenuScreen();
        },
        routes: [
          GoRoute(
            path: 'play/:storyId',
            name: 'storyPlayer',
            builder: (BuildContext context, GoRouterState state) {
              final storyId = state.pathParameters['storyId'];
              if (storyId == null) {
                return const Text('Error: storyId is missing');
              }
              return StoryPlayerScreen(storyId: storyId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/games',
        name: 'games',
        builder: (BuildContext context, GoRouterState state) {
          return const GamesMenuScreen();
        },
        routes: [
          GoRoute(
            path: 'alphabet',
            name: 'alphabetGame',
            builder: (BuildContext context, GoRouterState state) {
              return const AlphabetGameScreen();
            },
          ),
          GoRoute(
            path: 'numbers',
            name: 'numbersGame',
            builder: (BuildContext context, GoRouterState state) {
              return const NumbersGameScreen();
            },
          ),
          GoRoute(
            path: 'puzzle',
            name: 'puzzleGame',
            builder: (BuildContext context, GoRouterState state) {
              return const PuzzleGameScreen();
            },
          ),
        ],
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Eroare')),
        body: Center(
          child: Text('Pagina nu a fost găsită: ${state.uri}'),
        ),
      );
    },
  );
});
