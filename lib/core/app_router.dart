import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/instruments/instruments_menu_screen.dart';
import '../features/songs/songs_screen.dart';
import '../features/stories/story_player_screen.dart';
import '../features/sounds/sounds_map_screen.dart';
import '../features/games/games_hub_screen.dart';

import '../features/instruments/piano_screen.dart';
import '../features/instruments/drums_screen.dart';
import '../features/instruments/xylophone_screen.dart';
import '../features/instruments/organ_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/instrumente',
      builder: (context, state) => const InstrumentsMenuScreen(),
      routes: [
        GoRoute(
          path: 'pian',
          builder: (context, state) => const PianoScreen(),
        ),
        GoRoute(
          path: 'tobe',
          builder: (context, state) => const DrumsScreen(),
        ),
        GoRoute(
          path: 'xilofon',
          builder: (context, state) => const XylophoneScreen(),
        ),
        GoRoute(
          path: 'orga',
          builder: (context, state) => const OrganScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/canciones',
      builder: (context, state) => const SongsScreen(),
    ),
    GoRoute(
      path: '/povesti',
      builder: (context, state) => const StoryPlayerScreen(),
    ),
    GoRoute(
      path: '/sunete',
      builder: (context, state) => const SoundsMapScreen(),
    ),
    GoRoute(
      path: '/jocuri',
      builder: (context, state) => const GamesHubScreen(),
    ),
  ],
);
