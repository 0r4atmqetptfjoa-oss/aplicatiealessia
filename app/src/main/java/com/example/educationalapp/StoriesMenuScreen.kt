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
 * Displays a list of available stories.  Each entry navigates to the
 * interactive story book screen.  For simplicity this implementation uses
 * a single built‑in story; additional stories can be added by defining
 * separate routes or adding dynamic arguments and screens.
 */
@Composable
fun StoriesMenuScreen(navController: NavController, starState: MutableState<Int>) {
    val stories = listOf(
        "Poveste Interactivă"
        // Additional titles can be added here
    )
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Meniu Povești", modifier = Modifier.padding(bottom = 16.dp))
        stories.forEach { title ->
            Button(onClick = { navController.navigate(Screen.StoryBook.route) }, modifier = Modifier.padding(vertical = 4.dp)) {
                Text(text = title)
            }
        }
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }, modifier = Modifier.padding(top = 16.dp)) {
            Text(text = "Înapoi la Meniu Principal")
        }
    }
}