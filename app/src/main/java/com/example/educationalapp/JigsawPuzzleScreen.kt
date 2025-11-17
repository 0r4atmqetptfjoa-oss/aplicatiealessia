package com.example.educationalapp

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * Placeholder for a jigsaw puzzle game.  Building a full jigsaw puzzle in
 * Jetpack Compose requires more advanced gesture handling and image
 * segmentation; this screen simply informs the user that the feature is
 * forthcoming.  Visiting the page still awards a star to encourage
 * exploration.
 */
@Composable
fun JigsawPuzzleScreen(navController: NavController, starState: MutableState<Int>) {
    // Award a star on first composition
    LaunchedEffect(Unit) { starState.value += 1 }
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Puzzle Jigsaw", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Acest joc va fi disponibil în curând. Revenim cu o actualizare!", modifier = Modifier.padding(bottom = 16.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}