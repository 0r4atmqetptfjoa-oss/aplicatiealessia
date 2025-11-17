package com.example.educationalapp

import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.navArgument

// Defines the available screens for the app
sealed class Screen(val route: String) {
    object MainMenu : Screen("main_menu")
    // Main sections
    object GamesMenu : Screen("games_menu")
    object InstrumentsMenu : Screen("instruments_menu")
    object SongsMenu : Screen("songs_menu")
    object SoundsMenu : Screen("sounds_menu")
    object StoriesMenu : Screen("stories_menu")
    object Settings : Screen("settings")
    object Paywall : Screen("paywall")
    object ParentalGate : Screen("parental_gate")
    object AlphabetQuiz : Screen("alphabet_quiz")
    object NumberQuiz : Screen("number_quiz")
    object ColorMatch : Screen("color_match")
    object ShapeMatch : Screen("shape_match")
    object Puzzle : Screen("puzzle")
    object MemoryGame : Screen("memory_game")
    object AnimalSounds : Screen("animal_sounds")
    object Instrument : Screen("instrument")
    object SortingGame : Screen("sorting_game")
    object MazeGame : Screen("maze_game")
    object MathQuiz : Screen("math_quiz")
    object SequenceMemory : Screen("sequence_memory")
    object StoryBook : Screen("story_book")
    object Drawing : Screen("drawing")
    object AvatarCreator : Screen("avatar_creator")
    object StickerBook : Screen("sticker_book")
    object AnimalSoundBoard : Screen("animal_sound_board")
    object EmotionsGame : Screen("emotions_game")
    // Additional mini-game stubs for new specification
    object BlockGame : Screen("block_game")
    object CookingGame : Screen("cooking_game")
    object HiddenObjectsGame : Screen("hidden_objects")
    object InstrumentGuessGame : Screen("instrument_guess")
    object JigsawPuzzle : Screen("jigsaw_puzzle")
    object AnimalSorting : Screen("animal_sorting")
    // Instrument screens
    object Piano : Screen("piano")
    object Drums : Screen("drums")
    // Song player with dynamic argument; append the song id when navigating
    object SongPlayer : Screen("song_player/{songId}")
    // Sounds category screen with dynamic argument; append the category name when navigating
    object SoundCategory : Screen("sound_category/{category}")
}

@Composable
fun AppNavigation(
    navController: NavHostController,
    viewModel: MainViewModel
) {
    val uiState by viewModel.uiState.collectAsState()

    NavHost(
        navController = navController,
        startDestination = Screen.MainMenu.route,
    ) {
        composable(Screen.MainMenu.route) {
            MainMenuScreen(
                navController = navController,
                starCount = uiState.stars,
                // TODO: Pass other states from viewModel
            )
        }
        composable(Screen.GamesMenu.route) {
            GamesMenuScreen(
                navController = navController,
                // TODO: Pass states
            )
        }
        // TODO: Update all other screens to use the viewmodel state and events
        composable(Screen.Settings.route) {
            SettingsScreen(
                navController = navController,
                uiState = uiState,
                onSoundEnabledChanged = viewModel::updateSoundEnabled,
                onMusicEnabledChanged = viewModel::updateMusicEnabled,
                onHardModeChanged = viewModel::updateHardMode,
                onDarkThemeChanged = viewModel::updateDarkTheme
            )
        }
        composable(Screen.AlphabetQuiz.route) {
            AlphabetQuizScreen(navController) { viewModel.updateStars(uiState.stars + it) }
        }
        composable(Screen.NumberQuiz.route) {
            NumberQuizScreen(navController) { viewModel.updateStars(uiState.stars + it) }
        }
        composable(Screen.ColorMatch.route) {
            ColorMatchScreen(navController) { viewModel.updateStars(uiState.stars + it) }
        }
        composable(Screen.ShapeMatch.route) {
            ShapeMatchScreen(navController) { viewModel.updateStars(uiState.stars + it) }
        }
        composable(Screen.Puzzle.route) {
            PuzzleScreen(navController) { viewModel.updateStars(uiState.stars + it) }
        }
        composable(Screen.MemoryGame.route) {
            MemoryGameScreen(navController) { viewModel.updateStars(uiState.stars + it) }
        }
        composable(Screen.SortingGame.route) {
            SortingGameScreen(navController) { viewModel.updateStars(uiState.stars + it) }
        }

        // --- Placeholder and other screens --- 
        // These will be updated in subsequent steps

    }
}
