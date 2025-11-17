import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Feature screens
import 'features/main_menu/main_menu_screen.dart';
import 'features/games/games_menu_screen.dart';
import 'features/games/alphabet_game_screen.dart';
import 'features/games/shapes_game_screen.dart';
import 'features/games/puzzle_game_screen.dart';
import 'features/games/blocks_game_screen.dart';
import 'features/games/colors_game_screen.dart';
import 'features/games/cooking_game_screen.dart';
import 'features/games/hidden_objects_game_screen.dart';
import 'features/games/instruments_game_screen.dart';
import 'features/games/math_quiz_game_screen.dart';
import 'features/games/maze_game_screen.dart';
import 'features/games/memory_game_screen.dart';
import 'features/games/numbers_game_screen.dart';
import 'features/games/puzzle2_game_screen.dart';
import 'features/games/sorting_animals_game_screen.dart';
import 'features/instruments/instruments_menu_screen.dart';
import 'features/instruments/drums_play_screen.dart';
import 'features/instruments/piano_play_screen.dart';
import 'features/instruments/xylophone_play_screen.dart';
import 'features/songs/songs_menu_screen.dart';
import 'features/songs/song_player_screen.dart';
import 'features/sounds/sounds_menu_screen.dart';
import 'features/sounds/sound_category_screen.dart';
import 'features/sounds/sounds_detail_screen.dart';
import 'features/sounds/birds_screen.dart';
import 'features/stories/stories_menu_screen.dart';
import 'features/stories/story_player_screen.dart';

// Additional feature screens
import 'features/parental_gate/parental_gate_screen.dart';
import 'features/paywall/paywall_screen.dart';
import 'features/profiles/profile_selection_screen.dart';
import 'features/settings/settings_screen.dart';

/// Encapsulates the routing configuration for the NumVP app.
class AppRouter {
  /// An instance of [GoRouter] configured with all application routes.
  final GoRouter router;

  AppRouter()
      : router = GoRouter(
          initialLocation: '/',
          routes: <GoRoute>[
            // Main menu
            GoRoute(
              path: '/',
              name: 'main-menu',
              builder: (context, state) => const MainMenuScreen(),
            ),
            // Games section with nested game routes
            GoRoute(
              path: '/games',
              name: 'games-menu',
              builder: (context, state) => const GamesMenuScreen(),
              routes: [
                GoRoute(
                  path: 'alphabet',
                  name: 'alphabet-game',
                  builder: (context, state) => const AlphabetGameScreen(),
                ),
                GoRoute(
                  path: 'blocks',
                  name: 'blocks-game',
                  builder: (context, state) => const BlocksGameScreen(),
                ),
                GoRoute(
                  path: 'colors',
                  name: 'colors-game',
                  builder: (context, state) => const ColorsGameScreen(),
                ),
                GoRoute(
                  path: 'cooking',
                  name: 'cooking-game',
                  builder: (context, state) => const CookingGameScreen(),
                ),
                GoRoute(
                  path: 'hidden',
                  name: 'hidden-objects-game',
                  builder: (context, state) => const HiddenObjectsGameScreen(),
                ),
                GoRoute(
                  path: 'instruments',
                  name: 'instruments-game',
                  builder: (context, state) => const InstrumentsGameScreen(),
                ),
                GoRoute(
                  path: 'math-quiz',
                  name: 'math-quiz-game',
                  builder: (context, state) => const MathQuizGameScreen(),
                ),
                GoRoute(
                  path: 'maze',
                  name: 'maze-game',
                  builder: (context, state) => const MazeGameScreen(),
                ),
                GoRoute(
                  path: 'memory',
                  name: 'memory-game',
                  builder: (context, state) => const MemoryGameScreen(),
                ),
                GoRoute(
                  path: 'numbers',
                  name: 'numbers-game',
                  builder: (context, state) => const NumbersGameScreen(),
                ),
                GoRoute(
                  path: 'puzzle',
                  name: 'puzzle-game',
                  builder: (context, state) => const PuzzleGameScreen(),
                ),
                GoRoute(
                  path: 'puzzle2',
                  name: 'puzzle2-game',
                  builder: (context, state) => const Puzzle2GameScreen(),
                ),
                GoRoute(
                  path: 'shapes',
                  name: 'shapes-game',
                  builder: (context, state) => const ShapesGameScreen(),
                ),
                GoRoute(
                  path: 'sorting-animals',
                  name: 'sorting-animals-game',
                  builder: (context, state) => const SortingAnimalsGameScreen(),
                ),
              ],
            ),
            // Instruments section with nested instrument routes
            GoRoute(
              path: '/instruments',
              name: 'instruments-menu',
              builder: (context, state) => const InstrumentsMenuScreen(),
              routes: [
                GoRoute(
                  path: 'piano',
                  name: 'piano-play',
                  builder: (context, state) => const PianoPlayScreen(),
                ),
                GoRoute(
                  path: 'drums',
                  name: 'drums-play',
                  builder: (context, state) => const DrumsPlayScreen(),
                ),
                GoRoute(
                  path: 'xylophone',
                  name: 'xylophone-play',
                  builder: (context, state) => const XylophonePlayScreen(),
                ),
              ],
            ),
            // Songs section
            GoRoute(
              path: '/songs',
              name: 'songs-menu',
              builder: (context, state) => const SongsMenuScreen(),
              routes: [
                GoRoute(
                  path: 'player',
                  name: 'song-player',
                  builder: (context, state) => const SongPlayerScreen(),
                ),
              ],
            ),
            // Sounds section with nested categories
            GoRoute(
              path: '/sounds',
              name: 'sounds-menu',
              builder: (context, state) => const SoundsMenuScreen(),
              routes: [
                GoRoute(
                  path: 'category',
                  name: 'sound-category',
                  builder: (context, state) => const SoundCategoryScreen(),
                ),
                GoRoute(
                  path: 'detail',
                  name: 'sounds-detail',
                  builder: (context, state) => const SoundsDetailScreen(),
                ),
                GoRoute(
                  path: 'birds',
                  name: 'birds-sounds',
                  builder: (context, state) => const BirdsScreen(),
                ),
              ],
            ),
            // Stories section
            GoRoute(
              path: '/stories',
              name: 'stories-menu',
              builder: (context, state) => const StoriesMenuScreen(),
              routes: [
                GoRoute(
                  path: 'player',
                  name: 'story-player',
                  builder: (context, state) => const StoryPlayerScreen(),
                ),
              ],
            ),
            // Profile selection
            GoRoute(
              path: '/profiles',
              name: 'profile-selection',
              builder: (context, state) => const ProfileSelectionScreen(),
            ),
            // Parental gate
            GoRoute(
              path: '/parental-gate',
              name: 'parental-gate',
              builder: (context, state) => const ParentalGateScreen(),
            ),
            // Paywall
            GoRoute(
              path: '/paywall',
              name: 'paywall',
              builder: (context, state) => const PaywallScreen(),
            ),

            // Settings
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        );
}