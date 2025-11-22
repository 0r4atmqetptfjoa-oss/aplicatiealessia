package com.example.educationalapp

import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.educationalapp.features.games.GamesMenuScreen
import com.example.educationalapp.features.instruments.InstrumentsMenuScreen
import com.example.educationalapp.features.mainmenu.MainMenuScreen
import com.example.educationalapp.features.songs.SongsMenuScreen
import com.example.educationalapp.features.sounds.SoundsMenuScreen
import com.example.educationalapp.features.stories.StoriesMenuScreen

@Composable
fun AppNavigation(starCount: Int) {
    val navController = rememberNavController()
    NavHost(navController = navController, startDestination = Screen.MainMenu.route) {
        composable(Screen.MainMenu.route) {
            MainMenuScreen(navController = navController, starCount = starCount)
        }
        composable(Screen.SoundsMenu.route) { SoundsMenuScreen(navController) }
        composable(Screen.InstrumentsMenu.route) { InstrumentsMenuScreen(navController) }
        composable(Screen.StoriesMenu.route) { StoriesMenuScreen(navController) }
        composable(Screen.SongsMenu.route) { SongsMenuScreen(navController) }
        composable(Screen.GamesMenu.route) { GamesMenuScreen(navController) }
        composable(Screen.Paywall.route) { 
            NotImplementedScreen(navController = navController, title = "Paywall") 
        } 
    }
}
