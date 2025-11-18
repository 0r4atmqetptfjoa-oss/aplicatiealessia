package com.example.educationalapp

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * Lists all available mini‑games.  Games marked as free are always accessible,
 * while premium games require purchasing the full version.  When the user
 * attempts to launch a locked game without owning the full version, the
 * navigation is redirected to the paywall screen.
 */
data class GameItem(val name: String, val route: String, val isFree: Boolean)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GamesMenuScreen(
    navController: NavController,
    starState: MutableState<Int>,
    hasFullVersion: MutableState<Boolean>
) {
    // Define the list of games and whether each is free
    val games = listOf(
        GameItem("Quiz Alfabet", Screen.AlphabetQuiz.route, true),
        GameItem("Quiz Numere", Screen.NumberQuiz.route, true),
        GameItem("Potrivire Culori", Screen.ColorMatch.route, true),
        GameItem("Potrivire Forme", Screen.ShapeMatch.route, true),
        GameItem("Puzzle Simplu", Screen.Puzzle.route, true),
        GameItem("Joc Memorie", Screen.MemoryGame.route, true),
        GameItem("Joc Sortare", Screen.SortingGame.route, true),
    )
    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.lumea_background),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
            Text(text = "Meniu Jocuri", style = MaterialTheme.typography.displayMedium, fontFamily = FontFamily.Cursive, modifier = Modifier.padding(bottom = 16.dp).align(Alignment.CenterHorizontally))
            LazyColumn(modifier = Modifier.weight(1f)) {
                items(games) { game ->
                    val unlocked = game.isFree || hasFullVersion.value
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 4.dp),
                        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(12.dp),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(text = game.name, style = MaterialTheme.typography.titleMedium, fontFamily = FontFamily.Cursive)
                            if (unlocked) {
                                Button(onClick = { navController.navigate(game.route) }) {
                                    Text(text = "Joacă")
                                }
                            } else {
                                Button(onClick = { navController.navigate(Screen.Paywall.route) }) {
                                    Text(text = "Deblochează")
                                }
                            }
                        }
                    }
                }
            }
        }
        IconButton(
            onClick = { navController.navigate(Screen.MainMenu.route) },
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(16.dp)
        ) {
            Image(
                imageVector = Icons.Default.Home,
                contentDescription = "Acasă",
                modifier = Modifier.size(40.dp)
            )
        }
    }
}