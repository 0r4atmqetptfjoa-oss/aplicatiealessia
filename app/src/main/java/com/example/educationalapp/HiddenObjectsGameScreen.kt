package com.example.educationalapp

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.clickable
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import androidx.compose.ui.unit.sp

/**
 * A simple hidden objects game. A target emoji is shown and a grid of emojis
 * is displayed.  The player must find and tap the target within the grid.  If
 * correct, the player earns points and a star and a new target is chosen.
 */
@Composable
fun HiddenObjectsGameScreen(navController: NavController, starState: MutableState<Int>) {
    val objects = remember { listOf("🍎", "🍌", "🍇", "🍓", "🍒", "🥑", "🍉", "🍍", "🥕", "🍆", "🌽", "🥔") }
    var target by remember { mutableStateOf(objects.random()) }
    var grid by remember { mutableStateOf(generateGrid(objects, target)) }
    var score by remember { mutableStateOf(0) }
    var foundCount by remember { mutableStateOf(0) }
    var showEndDialog by remember { mutableStateOf(false) }

    fun generateGrid(pool: List<String>, currentTarget: String): List<String> {
        val list = mutableListOf<String>()
        list.add(currentTarget)
        while (list.size < 16) {
            list.add(pool.random())
        }
        return list.shuffled()
    }

    fun newRound(correct: Boolean) {
        if (correct) {
            score += 10
            starState.value += 1
            foundCount++
            if (foundCount >= 10) {
                showEndDialog = true
                return
            }
        } else {
            score = (score - 5).coerceAtLeast(0)
        }
        target = objects.random()
        grid = generateGrid(objects, target)
    }

    if (showEndDialog) {
        AlertDialog(
            onDismissRequest = { navController.navigate(Screen.MainMenu.route) },
            title = { Text("Joc Terminat!", textAlign = TextAlign.Center) },
            text = { Text("Ai găsit toate obiectele! Scorul tău este $score.", textAlign = TextAlign.Center) },
            confirmButton = {
                Button(onClick = {
                    score = 0
                    foundCount = 0
                    target = objects.random()
                    grid = generateGrid(objects, target)
                    showEndDialog = false
                }) {
                    Text("Joacă din nou")
                }
            },
            dismissButton = {
                Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
                    Text("Meniu Principal")
                }
            }
        )
    }

    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.background_meniu_principal),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(text = "Obiecte Ascunse", style = MaterialTheme.typography.headlineSmall, color = Color.White)
            Spacer(modifier = Modifier.height(16.dp))
            Text(text = "Găsește: $target", style = MaterialTheme.typography.displayMedium, color = Color.White)
            Spacer(modifier = Modifier.height(16.dp))
            LazyVerticalGrid(columns = GridCells.Fixed(4), modifier = Modifier.weight(1f)) {
                items(grid) { item ->
                    Box(
                        modifier = Modifier
                            .padding(4.dp)
                            .fillMaxWidth()
                            .aspectRatio(1f)
                            .clickable { newRound(item == target) },
                        contentAlignment = Alignment.Center
                    ) {
                        Text(text = item, fontSize = 24.sp)
                    }
                }
            }
            Spacer(modifier = Modifier.height(16.dp))
            Text(text = "Scor: $score", color = Color.White, style = MaterialTheme.typography.titleMedium)
            Spacer(modifier = Modifier.height(16.dp))
            Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
                Text("Înapoi la Meniu")
            }
        }
    }
}