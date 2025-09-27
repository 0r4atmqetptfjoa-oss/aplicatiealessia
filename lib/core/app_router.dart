import 'package:alesia/features/games_menu/games_menu_screen.dart';
import 'package:alesia/features/home/home_screen.dart';
import 'package:alesia/features/instruments/presentation/drums_screen.dart';
import 'package:alesia/features/instruments/presentation/instruments_menu_screen.dart';
import 'package:alesia/features/instruments/presentation/organ_screen.dart';
import 'package:alesia/features/instruments/presentation/piano_screen.dart';
import 'package:alesia/features/instruments/presentation/xylophone_screen.dart';
import 'package:alesia/features/songs/songs_screen.dart';
import 'package:alesia/features/sounds/sounds_map_screen.dart';
import 'package:alesia/features/stories/story_player_screen.dart';
import 'package:alesia/features/parent/parent_hub_screen.dart';
import 'package:alesia/features/profiles/profiles_screen.dart';
import 'package:alesia/features/parents/parental_gate_screen.dart';
import 'package:alesia/features/parents/parents_dashboard_screen.dart';
import 'package:alesia/features/quests/quests_screen.dart';
import 'package:alesia/features/rewards/rewards_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/instrumente',
      builder: (context, state) => const InstrumentsMenuScreen(),
      routes: [
        GoRoute(path: 'pian', builder: (context, state) => const PianoScreen()),
        GoRoute(path: 'tobe', builder: (context, state) => const DrumsScreen()),
        GoRoute(path: 'xilofon', builder: (context, state) => const XylophoneScreen()),
      GoRoute(path: 'orga', builder: (context, state) => const OrganScreen()),
      ],
    ),
    // Intentional string from brief
    GoRoute(path: '/canciones', builder: (context, state) => const SongsScreen()),
    GoRoute(path: '/povesti', builder: (context, state) => const StoryPlayerScreen()),
    GoRoute(path: '/jocuri', builder: (context, state) => const GamesMenuScreen()),
    GoRoute(path: '/sunete', builder: (context, state) => const SoundsMapScreen()),
    GoRoute(path: '/parinte', builder: (context, state) => const ParentHubScreen()),
    GoRoute(path: '/profil', builder: (context, state) => const ProfilesScreen()),
    GoRoute(path: '/parinti', builder: (context, state) => const ParentalGateScreen(), routes: [
      GoRoute(path: 'panou', builder: (context, state) => const ParentsDashboardScreen()),
    ]),
    GoRoute(path: '/questuri', builder: (context, state) => const QuestsScreen()),
    GoRoute(path: '/recompense', builder: (context, state) => const RewardsScreen()),
  ],
);