package com.example.educationalapp

import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.NavHostController
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
    object MathGame : Screen("math_game") // Renamed from NumberQuiz
    object ColorMatch : Screen("color_match")
    object ShapeMatch : Screen("shape_match")
    object Puzzle : Screen("puzzle")
    object MemoryGame : Screen("memory_game")
    object AnimalSortingGame : Screen("animal_sorting_game") // Renamed from SortingGame
    object CookingGame : Screen("cooking_game")
    object InstrumentsGame : Screen("instruments_game")
    object BlocksGame : Screen("blocks_game")
    object MazeGame : Screen("maze_game")
    object StoryBook : Screen("story_book")
    object Piano : Screen("piano")
    object Drums : Screen("drums")
    object Xylophone : Screen("instrument")
    object SongPlayer : Screen("song_player/{song_index}")
    object SoundCategory : Screen("sound_category/{category}")
}

@Composable
fun AppNavigation(
    navController: NavHostController,
    starState: MutableState<Int>,
    hasFullVersion: MutableState<Boolean>,
    soundEnabled: MutableState<Boolean>,
    musicEnabled: MutableState<Boolean>,
    hardModeEnabled: MutableState<Boolean>
) {
    NavHost(
        navController = navController,
        startDestination = Screen.MainMenu.route,
    ) {
        composable(Screen.MainMenu.route) {
            MainMenuScreen(
                navController = navController,
                starCount = starState.value
            )
        }
        composable(Screen.GamesMenu.route) {
            GamesMenuScreen(
                navController = navController,
                starState = starState,
                hasFullVersion = hasFullVersion
            )
        }
        composable(Screen.InstrumentsMenu.route) {
            InstrumentsMenuScreen(navController, starState)
        }
        composable(Screen.SongsMenu.route) {
            SongsMenuScreen(navController, starState)
        }
        composable(Screen.SoundsMenu.route) {
            SoundsMenuScreen(navController, starState)
        }
        composable(Screen.StoriesMenu.route) {
            StoriesMenuScreen(navController, starState)
        }
        composable(Screen.Settings.route) {
            SettingsScreen(
                navController = navController,
                soundEnabled = soundEnabled,
                musicEnabled = musicEnabled,
                hardModeEnabled = hardModeEnabled
            )
        }
        composable(Screen.Paywall.route) {
            PaywallScreen(navController, hasFullVersion)
        }
        composable(Screen.AlphabetQuiz.route) {
            AlphabetQuizScreen(navController, starState)
        }
        composable(Screen.MathGame.route) {
            NumberQuizScreen(navController, starState) // Placeholder, will be renamed
        }
        composable(Screen.ColorMatch.route) {
            ColorMatchScreen(navController, starState)
        }
        composable(Screen.ShapeMatch.route) {
            ShapeMatchScreen(navController, starState)
        }
        composable(Screen.Puzzle.route) {
            PuzzleScreen(navController) { starsEarned ->
                starState.value += starsEarned
            }
        }
        composable(Screen.MemoryGame.route) {
            MemoryGameScreen(navController) { starsEarned ->
                starState.value += starsEarned
            }
        }
        composable(Screen.AnimalSortingGame.route) {
            SortingGameScreen(navController, starState) // Placeholder, will be renamed
        }
        composable(Screen.CookingGame.route) {
            CookingGameScreen(navController, starState)
        }
        composable(Screen.InstrumentsGame.route) {
            InstrumentsGameScreen(navController, starState)
        }
        composable(Screen.BlocksGame.route) {
            BlocksGameScreen(navController, starState)
        }
        composable(Screen.MazeGame.route) {
            MazeGameScreen(navController, starState)
        }
        composable(Screen.Piano.route) {
            PianoScreen(navController, starState)
        }
        composable(Screen.Drums.route) {
            DrumsScreen(navController, starState)
        }
        composable(Screen.Xylophone.route) {
            XylophoneScreen(navController, starState)
        }
        composable(Screen.StoryBook.route) {
            StoryBookScreen(navController, starState)
        }
        composable(
            route = Screen.SongPlayer.route,
            arguments = listOf(navArgument("song_index") { type = NavType.IntType })
        ) { backStackEntry ->
            val songIndex = backStackEntry.arguments?.getInt("song_index") ?: 0
            SongPlayerScreen(navController, starState, songIndex)
        }
        composable(
            route = Screen.SoundCategory.route,
            arguments = listOf(navArgument("category") { type = NavType.StringType })
        ) { backStackEntry ->
            val category = backStackEntry.arguments?.getString("category") ?: ""
            SoundCategoryScreen(navController, starState, category)
        }
    }
}
