import 'package:alesia/features/games_menu/games_menu_screen.dart';
import 'package:alesia/features/home/home_screen.dart';
import 'package:alesia/features/instruments/presentation/drums_screen.dart';
import 'package:alesia/features/instruments/presentation/instruments_menu_screen.dart';
import 'package:alesia/features/instruments/presentation/organ_screen.dart';
import 'package:alesia/features/instruments/presentation/piano_screen.dart';
import 'package:alesia/features/instruments/presentation/xylophone_screen.dart';
import 'package:alesia/features/songs/songs_screen.dart';
import 'package:alesia/features/songs/advanced_songs_screen.dart';
import 'package:alesia/features/sounds/sounds_map_screen.dart';
import 'package:alesia/features/stories/story_player_screen.dart';
import 'package:alesia/features/stories/story_json_editor_screen.dart';
import 'package:alesia/features/parent/parent_hub_screen.dart';
import 'package:alesia/features/rewards/rewards_screen.dart';
import 'package:alesia/features/profile/profile_screen.dart';
import 'package:alesia/features/parent/parent_settings_screen.dart';
import 'package:alesia/features/parent/analytics_screen.dart';
import 'package:alesia/features/quests/quests_screen.dart';
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
    GoRoute(path: '/canciones', builder: (context, state) => const AdvancedSongsScreen()),
    GoRoute(path: '/povesti', builder: (context, state) => const StoryPlayerScreen()),
    GoRoute(path: '/story_editor', builder: (context, state) => const StoryJsonEditorScreen()),
    GoRoute(path: '/jocuri', builder: (context, state) => const GamesMenuScreen()),
    GoRoute(path: '/sunete', builder: (context, state) => const SoundsMapScreen()),
    GoRoute(path: '/parinte', builder: (context, state) => const ParentHubScreen()),
    GoRoute(path: '/recompense', builder: (context, state) => const RewardsScreen()),
  ],
);
