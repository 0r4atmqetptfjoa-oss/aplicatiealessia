package com.example.educationalapp

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * Simple placeholder screen used for mini‑games or features that are not yet
 * implemented.  Displays a message and provides a button to return to the
 * games menu.
 *
 * @param title The name of the feature being stubbed.
 */
@Composable
fun NotImplementedScreen(navController: NavController, title: String) {
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = title, modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Această funcție nu este încă implementată.", modifier = Modifier.padding(bottom = 16.dp))
        Button(onClick = { navController.navigate(Screen.GamesMenu.route) }) {
            Text(text = "Înapoi la Meniu Jocuri")
        }
    }
}