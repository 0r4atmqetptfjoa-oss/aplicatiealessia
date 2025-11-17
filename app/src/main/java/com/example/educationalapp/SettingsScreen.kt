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

/**
 * Displays settings toggles for sound effects, background music and hard mode.
 * The parent maintains these boolean states; this screen simply modifies
 * them.  Hard mode could increase difficulty in some games (e.g. reduce
 * response time, more options) but this demo does not implement those
 * changes.
 */
@Composable
fun SettingsScreen(
    navController: NavController,
    soundEnabled: MutableState<Boolean>,
    musicEnabled: MutableState<Boolean>,
    hardModeEnabled: MutableState<Boolean>
) {
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Setări", modifier = Modifier.padding(bottom = 16.dp))
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = "Sunete activat")
            Switch(checked = soundEnabled.value, onCheckedChange = { soundEnabled.value = it })
        }
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = "Muzică activată")
            Switch(checked = musicEnabled.value, onCheckedChange = { musicEnabled.value = it })
        }
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = "Mod greu")
            Switch(checked = hardModeEnabled.value, onCheckedChange = { hardModeEnabled.value = it })
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }, modifier = Modifier) {
            Text(text = "Înapoi la Meniu Principal")
        }
    }
}