package com.example.educationalapp

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * Lists available instruments.  Each button navigates to a specific instrument
 * screen.  The xylophone uses the existing InstrumentScreen from the original
 * app; piano and drums are new simple implementations.
 */
@Composable
fun InstrumentsMenuScreen(navController: NavController, starState: MutableState<Int>) {
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Meniu Instrumente", modifier = Modifier.padding(bottom = 16.dp))
        Button(onClick = { navController.navigate(Screen.Piano.route) }, modifier = Modifier.padding(vertical = 4.dp)) {
            Text(text = "Pian")
        }
        Button(onClick = { navController.navigate(Screen.Drums.route) }, modifier = Modifier.padding(vertical = 4.dp)) {
            Text(text = "Tobe")
        }
        Button(onClick = { navController.navigate(Screen.Instrument.route) }, modifier = Modifier.padding(vertical = 4.dp)) {
            Text(text = "Xilofon")
        }
        Button(onClick = { navController.navigate(Screen.GamesMenu.route) }, modifier = Modifier.padding(top = 16.dp)) {
            Text(text = "Înapoi la Jocuri")
        }
    }
}