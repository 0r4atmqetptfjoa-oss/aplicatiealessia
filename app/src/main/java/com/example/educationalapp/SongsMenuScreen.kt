package com.example.educationalapp

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * Displays a list of songs.  Selecting a song navigates to the SongPlayer
 * screen with the appropriate song ID.  Songs are free and not locked.
 */
@Composable
fun SongsMenuScreen(navController: NavController, starState: MutableState<Int>) {
    val songs = listOf(
        "Cântec de leagăn",
        "La mulți ani",
        "Bate toba",
        "Happy Birthday"
    )
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Meniu Melodii", modifier = Modifier.padding(bottom = 16.dp))
        LazyColumn(modifier = Modifier.weight(1f)) {
            itemsIndexed(songs) { index, title ->
                Card(modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 4.dp)) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(12.dp),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text(text = title)
                        Button(onClick = { navController.navigate("song_player/$index") }) {
                            Text(text = "Redă")
                        }
                    }
                }
            }
        }
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }, modifier = Modifier.padding(top = 16.dp)) {
            Text(text = "Înapoi la Meniu Principal")
        }
    }
}