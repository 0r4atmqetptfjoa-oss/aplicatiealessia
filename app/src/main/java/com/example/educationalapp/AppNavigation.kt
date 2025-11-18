package com.example.educationalapp

import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.NavHostController

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
    object SortingGame : Screen("sorting_game")
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
        composable(Screen.Settings.route) {
            SettingsScreen(
                navController = navController,
                soundEnabled = soundEnabled,
                musicEnabled = musicEnabled,
                hardModeEnabled = hardModeEnabled
            )
        }
        composable(Screen.AlphabetQuiz.route) {
            AlphabetQuizScreen(navController, starState)
        }
        composable(Screen.NumberQuiz.route) {
            NumberQuizScreen(navController, starState)
        }
        composable(Screen.ColorMatch.route) {
            ColorMatchScreen(navController, starState)
        }
        composable(Screen.ShapeMatch.route) {
            ShapeMatchScreen(navController, starState)
        }
        composable(Screen.Puzzle.route) {
            PuzzleScreen(navController, starState)
        }
        composable(Screen.MemoryGame.route) {
            MemoryGameScreen(navController, starState)
        }
        composable(Screen.SortingGame.route) {
            SortingGameScreen(navController, starState)
        }
    }
}
