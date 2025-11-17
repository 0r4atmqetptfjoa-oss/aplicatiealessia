package com.example.educationalapp

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import androidx.compose.foundation.layout.Box
import kotlin.random.Random

/**
 * A hidden objects game that displays a grid of emojis.  The player is
 * instructed to find a specific object.  Correct selections yield points
 * and stars; incorrect picks reduce score.  After finding the object the
 * grid is reshuffled with a new target.  This basic version uses emojis
 * instead of images, making it easy to extend by adding more items.
 */
data class HiddenItem(val name: String, val emoji: String)

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun HiddenObjectsGameScreen(navController: NavController, starState: MutableState<Int>) {
    val items = listOf(
        HiddenItem("Măr", "🍎"),
        HiddenItem("Banana", "🍌"),
        HiddenItem("Strugure", "🍇"),
        HiddenItem("Cireașă", "🍒"),
        HiddenItem("Ananas", "🍍"),
        HiddenItem("Morcov", "🥕"),
        HiddenItem("Pepene", "🍉"),
        HiddenItem("Lămâie", "🍋")
    )
    var grid by remember { mutableStateOf(listOf<HiddenItem>()) }
    var target by remember { mutableStateOf(items[0]) }
    var feedback by remember { mutableStateOf("") }
    var score by remember { mutableStateOf(0) }
    fun newRound() {
        feedback = ""
        target = items.random()
        grid = items.shuffled().take(6)
    }
    LaunchedEffect(Unit) { newRound() }
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Obiecte Ascunse", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Găsește: ${target.name}", modifier = Modifier.padding(bottom = 8.dp))
        LazyVerticalGrid(columns = GridCells.Fixed(3), modifier = Modifier.weight(1f)) {
            items(grid) { item ->
                Card(modifier = Modifier.padding(8.dp).fillMaxWidth().aspectRatio(1f)) {
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center
                    ) {
                        Button(onClick = {
                            if (item == target) {
                                feedback = "Corect!";
                                score += 10; starState.value += 1
                            } else {
                                feedback = "Greșit!";
                                score = (score - 5).coerceAtLeast(0)
                            }
                            newRound()
                        }) {
                            Text(text = item.emoji)
                        }
                    }
                }
            }
        }
        Text(text = "Scor: $score", modifier = Modifier.padding(top = 16.dp))
        Text(text = feedback, modifier = Modifier.padding(top = 8.dp))
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}