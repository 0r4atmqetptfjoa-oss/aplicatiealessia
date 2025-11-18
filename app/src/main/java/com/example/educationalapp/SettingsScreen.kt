package com.example.educationalapp

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.Button
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.example.educationalapp.designsystem.Spacing

@Composable
fun SettingsScreen(
    navController: NavController,
    soundEnabled: MutableState<Boolean>,
    musicEnabled: MutableState<Boolean>,
    hardModeEnabled: MutableState<Boolean>
) {
    Column(modifier = Modifier.fillMaxSize().padding(Spacing.large)) {
        Text(text = "Setări", modifier = Modifier.padding(bottom = Spacing.large))
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.medium),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = "Sunete activat")
            Switch(checked = soundEnabled.value, onCheckedChange = { soundEnabled.value = it })
        }
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.medium),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = "Muzică activată")
            Switch(checked = musicEnabled.value, onCheckedChange = { musicEnabled.value = it })
        }
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.medium),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = "Mod greu")
            Switch(checked = hardModeEnabled.value, onCheckedChange = { hardModeEnabled.value = it })
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