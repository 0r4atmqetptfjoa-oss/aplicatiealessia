package com.example.educationalapp

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.Button
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavController
import com.example.educationalapp.data.UserPreferences
import com.example.educationalapp.designsystem.Spacing

@Composable
fun SettingsScreen(
    navController: NavController,
    uiState: UserPreferences,
    onSoundEnabledChanged: (Boolean) -> Unit,
    onMusicEnabledChanged: (Boolean) -> Unit,
    onHardModeChanged: (Boolean) -> Unit,
    onDarkThemeChanged: (Boolean) -> Unit
) {
    Column(modifier = Modifier.fillMaxSize().padding(Spacing.large)) {
        Text(text = "Setări", modifier = Modifier.padding(bottom = Spacing.large))
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.medium),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = "Sunete activat")
            Switch(checked = uiState.soundEnabled, onCheckedChange = onSoundEnabledChanged)
        }
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.medium),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = "Muzică activată")
            Switch(checked = uiState.musicEnabled, onCheckedChange = onMusicEnabledChanged)
        }
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.medium),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = "Mod greu")
            Switch(checked = uiState.hardModeEnabled, onCheckedChange = onHardModeChanged)
        }
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.medium),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = "Temă întunecată")
            Switch(checked = uiState.darkTheme, onCheckedChange = onDarkThemeChanged)
        }
        Spacer(modifier = Modifier.height(Spacing.large))
        Button(onClick = { navController.navigate(Screen.ParentalGate.route) }) {
            Text(text = "Poarta Părinte")
        }
        Spacer(modifier = Modifier.height(Spacing.large))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }, modifier = Modifier) {
            Text(text = "Înapoi la Meniu Principal")
        }
    }
}