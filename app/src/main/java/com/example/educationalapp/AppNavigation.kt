package com.example.educationalapp

import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.LaunchedEffect
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.educationalapp.alphabet.AlphabetGameScreen // Import the new screen
import com.example.educationalapp.features.games.*
import com.example.educationalapp.features.instruments.InstrumentsMenuScreen
import com.example.educationalapp.features.mainmenu.MainMenuScreen
import com.example.educationalapp.features.songs.SongsMenuScreen
import com.example.educationalapp.features.songs.SongPlayerScreen
import com.example.educationalapp.features.sounds.*
import com.example.educationalapp.features.stories.StoriesMenuScreen

/**
 * The central navigation graph for the application.  This function wires together
 * all of the routes defined in [Screen] with their corresponding composable
 * screens.  A shared [starState] is used to propagate the total number of
 * stars earned across all games and keep it synchronised with [MainViewModel].
 */
@Composable
fun AppNavigation(viewModel: MainViewModel) {
    val navController = rememberNavController()

    // Collect state from the ViewModel
    val starCount by viewModel.starCount.collectAsState()
    val soundEnabled by viewModel.soundEnabled.collectAsState()
    val musicEnabled by viewModel.musicEnabled.collectAsState()
    val hardModeEnabled by viewModel.hardModeEnabled.collectAsState()

    // Local star state used by games.  It is initialised from the ViewModel and
    // updates the ViewModel whenever it changes.
    val starState = remember { mutableStateOf(starCount) }
    // Sync local state when ViewModel changes (e.g. restored state)
    LaunchedEffect(starCount) {
        if (starState.value != starCount) {
            starState.value = starCount
        }
    }
    // Persist local changes back to ViewModel
    LaunchedEffect(starState.value) {
        viewModel.setStarCount(starState.value)
    }

    NavHost(navController = navController, startDestination = Screen.MainMenu.route) {
        composable(Screen.MainMenu.route) {
            MainMenuScreen(
                navController = navController,
                starCount = starCount
            )
        }

        composable(Screen.SettingsScreen.route) {
            SettingsScreen(
                navController = navController,
                soundEnabled = soundEnabled,
                musicEnabled = musicEnabled,
                hardModeEnabled = hardModeEnabled,
                onSoundChanged = { viewModel.toggleSound() },
                onMusicChanged = { viewModel.toggleMusic() },
                onHardModeChanged = { viewModel.toggleHardMode() }
            )
        }

        composable("games") {
            GamesCategoryScreen { selected ->
                navController.navigate(selected.destination)
            }
        }

        // --- UPDATED ROUTE FOR ALPHABET GAME ---
        composable("alphabet") {
            AlphabetGameScreen(onBackToMenu = { navController.popBackStack() })
        }
        // ----------------------------------------

        composable("colors") { GameContainer(gamesList[1]) { ColorMatchScreen(navController = navController, starState = starState) } }
        composable("shapes") { GameContainer(gamesList[2]) { ShapeMatchScreen(navController = navController, starState = starState) } }
        composable("puzzle") { GameContainer(gamesList[3]) { JigsawPuzzleScreen(navController = navController, starState = starState) } }
        composable("memory") { GameContainer(gamesList[4]) { MemoryGameScreen(navController = navController, starState = starState) } }
        composable("hidden") { GameContainer(gamesList[5]) { HiddenObjectsGameScreen(navController = navController, starState = starState) } }
        composable("sorting") { GameContainer(gamesList[6]) { SortingGameScreen(navController = navController, starState = starState) } }
        composable("instruments") { GameContainer(gamesList[7]) { InstrumentsGameScreen(navController = navController, starState = starState) } }
        composable("vehicles") { GameContainer(gamesList[8]) { Text("Vehicles Screen") } } // Placeholder
        composable("sequence") { GameContainer(gamesList[9]) { SequenceMemoryGameScreen(navController = navController, starState = starState) } }
        composable("math") { GameContainer(gamesList[10]) { MathGameScreen(navController = navController, starState = starState) } }

        // Menu screens
        composable(Screen.SoundsMenu.route) { SoundsMenuScreen(navController) }
        composable(Screen.InstrumentsMenu.route) { InstrumentsMenuScreen(navController) }
        composable(Screen.StoriesMenu.route) { StoriesMenuScreen(navController) }
        composable(Screen.SongsMenu.route) { SongsMenuScreen(navController) }

        // Individual sound screens
        composable(Screen.WildSounds.route) { WildSoundsScreen() }
        composable(Screen.MarineSounds.route) { MarineSoundsScreen() }
        composable(Screen.FarmSounds.route) { FarmSoundsScreen() }
        composable(Screen.BirdSounds.route) { BirdSoundsScreen() }

        // Paywall or placeholder
        composable(Screen.Paywall.route) {
            NotImplementedScreen(navController = navController, title = "Paywall")
        }

        // Song player screens.  Each screen loads a specific song based on the route
        composable(Screen.Song1.route) { backStackEntry ->
            SongPlayerScreen(navController = navController, backStackEntry = backStackEntry, starState = starState)
        }
        composable(Screen.Song2.route) { backStackEntry ->
            SongPlayerScreen(navController = navController, backStackEntry = backStackEntry, starState = starState)
        }
        composable(Screen.Song3.route) { backStackEntry ->
            SongPlayerScreen(navController = navController, backStackEntry = backStackEntry, starState = starState)
        }
        composable(Screen.Song4.route) { backStackEntry ->
            SongPlayerScreen(navController = navController, backStackEntry = backStackEntry, starState = starState)
        }
    }
}
