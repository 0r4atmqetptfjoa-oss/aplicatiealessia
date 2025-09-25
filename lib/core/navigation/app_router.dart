import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/placeholder_screen.dart';
import '../../features/instruments/piano/piano_screen.dart';
import '../../features/instruments/drums/drums_screen.dart';
import '../../features/instruments/xylophone/xylophone_screen.dart';
import '../../features/instruments/organ/organ_screen.dart';
import '../../features/songs/songs_screen.dart';
import '../../features/games/games_menu_screen.dart';
import '../../features/games/alphabet/alphabet_screen.dart';
import '../../features/games/memory/memory_screen.dart';
import '../../features/games/puzzle/puzzle_screen.dart';
import '../../features/sounds/sounds_screen.dart';
import '../../features/stories/stories_screen.dart';

/// Central place where all application routes are declared.
///
/// Using [GoRouter] makes it easy to declare typed paths and handle simple
/// navigation without a nested Navigator.  Each route points at a
/// placeholder screen for now; later phases will replace these with
/// complete feature implementations.
class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/instruments',
        name: 'instruments',
        builder: (BuildContext context, GoRouterState state) {
          return const PlaceholderScreen(title: 'Instrumente');
        },
        routes: <GoRoute>[
          GoRoute(
            path: 'piano',
            name: 'piano',
            builder: (context, state) => const PianoScreen(),
          ),
          GoRoute(
            path: 'drums',
            name: 'drums',
            builder: (context, state) => const DrumsScreen(),
          ),
          GoRoute(
            path: 'xylophone',
            name: 'xylophone',
            builder: (context, state) => const XylophoneScreen(),
          ),
          GoRoute(
            path: 'organ',
            name: 'organ',
            builder: (context, state) => const OrganScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/songs',
        name: 'songs',
        builder: (BuildContext context, GoRouterState state) {
          return const SongsScreen();
        },
      ),
      GoRoute(
        path: '/stories',
        name: 'stories',
        builder: (BuildContext context, GoRouterState state) {
          return const StoriesScreen();
        },
      ),
      GoRoute(
        path: '/games',
        name: 'games',
        builder: (BuildContext context, GoRouterState state) {
          return const GamesMenuScreen();
        },
        routes: <GoRoute>[
          GoRoute(
            path: 'alphabet',
            name: 'alphabet',
            builder: (context, state) => const AlphabetScreen(),
          ),
            GoRoute(
              path: 'memory',
              name: 'memory',
              builder: (context, state) => const MemoryScreen(),
            ),
            GoRoute(
              path: 'puzzle',
              name: 'puzzle',
              builder: (context, state) => const PuzzleScreen(),
            ),
        ],
      ),
      GoRoute(
        path: '/sounds',
        name: 'sounds',
        builder: (BuildContext context, GoRouterState state) {
          return const SoundsScreen();
        },
      ),
    ],
  );
}