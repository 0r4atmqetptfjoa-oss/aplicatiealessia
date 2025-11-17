package com.example.educationalapp

import androidx.compose.runtime.MutableState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.compose.material3.Scaffold
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.navigation.NavGraphBuilder
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.NavType
import androidx.navigation.navArgument
import androidx.compose.ui.Modifier

// Defines the available screens for the app
sealed class Screen(val route: String) {
    object MainMenu : Screen("main_menu")
    // Main sections
    object GamesMenu : Screen("games_menu")
    object InstrumentsMenu : Screen("instruments_menu")
    object SongsMenu : Screen("songs_menu")
    object SoundsMenu : Screen("sounds_menu")
    object StoriesMenu : Screen("stories_menu")
    object ProfilesMenu : Screen("profiles_menu")
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
    starState: MutableState<Int>,
    hasFullVersion: MutableState<Boolean>,
    soundEnabled: MutableState<Boolean>,
    musicEnabled: MutableState<Boolean>,
    hardModeEnabled: MutableState<Boolean>,
    selectedProfileIndex: MutableState<Int>
) {
    // Wrap the NavHost in a Scaffold so we can provide a consistent top bar with a home button
    Scaffold(
        topBar = {
            // Determine the current route. When on the main menu we hide the home button.
            val navBackStackEntry by navController.currentBackStackEntryAsState()
            val currentRoute = navBackStackEntry?.destination?.route
            if (currentRoute != Screen.MainMenu.route) {
                TopAppBar(
                    title = {},
                    navigationIcon = {
                        IconButton(onClick = {
                            // Navigate back to the main menu. We pop up to avoid building up the stack.
                            navController.navigate(Screen.MainMenu.route) {
                                popUpTo(Screen.MainMenu.route) { inclusive = false }
                            }
                        }) {
                            Icon(Icons.Filled.Home, contentDescription = "Acasă")
                        }
                    }
                )
            }
        }
    ) { innerPadding ->
        // The NavHost itself handles navigation between screens. Use padding from Scaffold to avoid
        // overlapping the top bar.
        NavHost(
            navController = navController,
            startDestination = Screen.MainMenu.route,
            modifier = Modifier.padding(innerPadding)
        ) {
        composable(Screen.MainMenu.route) {
            MainMenuScreen(
                navController = navController,
                starState = starState,
                hasFullVersion = hasFullVersion,
                soundEnabled = soundEnabled,
                musicEnabled = musicEnabled,
                hardModeEnabled = hardModeEnabled,
                selectedProfileIndex = selectedProfileIndex
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
            InstrumentsMenuScreen(
                navController = navController,
                starState = starState
            )
        }
        composable(Screen.SongsMenu.route) {
            SongsMenuScreen(
                navController = navController,
                starState = starState
            )
        }
        composable(Screen.SoundsMenu.route) {
            SoundsMenuScreen(
                navController = navController,
                starState = starState
            )
        }
        composable(Screen.StoriesMenu.route) {
            StoriesMenuScreen(
                navController = navController,
                starState = starState
            )
        }
        composable(Screen.ProfilesMenu.route) {
            ProfilesMenuScreen(
                navController = navController,
                selectedProfileIndex = selectedProfileIndex
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
        composable(Screen.Paywall.route) {
            PaywallScreen(
                navController = navController,
                hasFullVersion = hasFullVersion
            )
        }
        composable(Screen.ParentalGate.route) {
            ParentalGateScreen(
                navController = navController
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
        composable(Screen.AnimalSounds.route) {
            AnimalSoundsScreen(navController, starState)
        }
        composable(Screen.Instrument.route) {
            InstrumentScreen(navController, starState)
        }
        composable(Screen.SortingGame.route) {
            SortingGameScreen(navController, starState)
        }
        composable(Screen.MazeGame.route) {
            MazeGameScreen(navController, starState)
        }
        composable(Screen.MathQuiz.route) {
            MathQuizScreen(navController, starState)
        }
        composable(Screen.SequenceMemory.route) {
            SequenceMemoryScreen(navController, starState)
        }
        composable(Screen.StoryBook.route) {
            StoryBookScreen(navController, starState)
        }
        composable(Screen.Drawing.route) {
            DrawingScreen(navController, starState)
        }
        composable(Screen.AvatarCreator.route) {
            AvatarCreatorScreen(navController, starState)
        }
        composable(Screen.StickerBook.route) {
            StickerBookScreen(navController, starState)
        }
        composable(Screen.AnimalSoundBoard.route) {
            AnimalSoundBoardScreen(navController, starState)
        }
        composable(Screen.EmotionsGame.route) {
            EmotionsGameScreen(navController, starState)
        }
        // Stubs for additional mini-games (not implemented yet)
        composable(Screen.BlockGame.route) { BlockGameScreen(navController, starState) }
        composable(Screen.CookingGame.route) { CookingGameScreen(navController, starState) }
        composable(Screen.HiddenObjectsGame.route) { HiddenObjectsGameScreen(navController, starState) }
        composable(Screen.InstrumentGuessGame.route) { InstrumentGuessGameScreen(navController, starState) }
        composable(Screen.JigsawPuzzle.route) { JigsawPuzzleScreen(navController, starState) }
        composable(Screen.AnimalSorting.route) { AnimalSortingGameScreen(navController, starState) }
        composable(Screen.Piano.route) { PianoScreen(navController, starState) }
        composable(Screen.Drums.route) { DrumsScreen(navController, starState) }
        // Song player screen with songId argument
        composable(
            route = Screen.SongPlayer.route,
            arguments = listOf(androidx.navigation.navArgument("songId") { type = androidx.navigation.NavType.IntType })
        ) { backStackEntry ->
            val songId = backStackEntry.arguments?.getInt("songId") ?: 0
            SongPlayerScreen(navController, starState, songId)
        }
        // Sounds category screen with category argument
        composable(
            route = Screen.SoundCategory.route,
            arguments = listOf(androidx.navigation.navArgument("category") { type = androidx.navigation.NavType.StringType })
        ) { backStackEntry ->
            val category = backStackEntry.arguments?.getString("category") ?: ""
            SoundCategoryScreen(navController, starState, category)
        }
        }
    }
}