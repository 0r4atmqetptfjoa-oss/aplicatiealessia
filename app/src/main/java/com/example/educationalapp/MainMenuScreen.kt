package com.example.educationalapp

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

@Composable
fun MainMenuScreen(
    navController: NavController,
    starState: MutableState<Int>,
    hasFullVersion: MutableState<Boolean>,
    soundEnabled: MutableState<Boolean>,
    musicEnabled: MutableState<Boolean>,
    hardModeEnabled: MutableState<Boolean>,
    selectedProfileIndex: MutableState<Int>
) {
    val animatedStars by androidx.compose.animation.core.animateIntAsState(targetValue = starState.value)
    val profiles = listOf("Profil 1", "Profil 2", "Profil 3")
    val currentProfile = profiles.getOrElse(selectedProfileIndex.value) { profiles[0] }
    Column(
        modifier = Modifier.fillMaxSize().padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(text = "Bine ai venit, $currentProfile!", modifier = Modifier.padding(bottom = 8.dp))
        Text(text = "Stele: $animatedStars", modifier = Modifier.padding(bottom = 16.dp))
        // Main section buttons
        Button(onClick = { navController.navigate(Screen.GamesMenu.route) }, modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
            Text(text = "🎮 Jocuri")
        }
        Button(onClick = { navController.navigate(Screen.InstrumentsMenu.route) }, modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
            Text(text = "🎹 Instrumente")
        }
        Button(onClick = { navController.navigate(Screen.SongsMenu.route) }, modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
            Text(text = "🎵 Melodii")
        }
        Button(onClick = { navController.navigate(Screen.SoundsMenu.route) }, modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
            Text(text = "🔊 Sunete")
        }
        Button(onClick = { navController.navigate(Screen.StoriesMenu.route) }, modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
            Text(text = "📖 Povești")
        }
        Button(onClick = { navController.navigate(Screen.ProfilesMenu.route) }, modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
            Text(text = "👤 Profiluri")
        }
        // Parental Gate appears before upgrade to restrict access to certain settings
        Button(onClick = { navController.navigate(Screen.ParentalGate.route) }, modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
            Text(text = "🔒 Poarta Părinte")
        }
        Button(onClick = { navController.navigate(Screen.Paywall.route) }, modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
            Text(text = "🔓 Upgrade")
        }
        Button(onClick = { navController.navigate(Screen.Settings.route) }, modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
            Text(text = "⚙️ Setări")
        }
    }
}