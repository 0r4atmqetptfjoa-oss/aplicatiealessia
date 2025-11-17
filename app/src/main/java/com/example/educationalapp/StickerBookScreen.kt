package com.example.educationalapp

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * Displays a grid of stickers which unlock as the player earns more stars.
 * Each sticker requires a certain number of stars to unlock.  Unlocked
 * stickers are colourful; locked stickers are greyed out with a lock icon.
 */
data class Sticker(val name: String, val emoji: String, val requiredStars: Int)

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun StickerBookScreen(navController: NavController, starState: MutableState<Int>) {
    val stickers = listOf(
        Sticker("Stea", "⭐", 0),
        Sticker("Cățel", "🐶", 2),
        Sticker("Pisică", "🐱", 4),
        Sticker("Mașină", "🚗", 6),
        Sticker("Măr", "🍎", 8),
        Sticker("Balon", "🎈", 10),
        Sticker("Muzică", "🎵", 12),
        Sticker("Curcubeu", "🌈", 15)
    )
    val feedback = remember { mutableStateOf("") }
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Album de Stickere", modifier = Modifier.padding(bottom = 16.dp))
        LazyVerticalGrid(columns = GridCells.Fixed(3), modifier = Modifier.weight(1f)) {
            items(stickers) { sticker ->
                val unlocked = starState.value >= sticker.requiredStars
                Card(
                    modifier = Modifier
                        .padding(8.dp)
                        .fillMaxWidth()
                        .aspectRatio(1f)
                        .clickable {
                            if (unlocked) {
                                feedback.value = "Ai selectat stickerul ${sticker.name}!"
                            } else {
                                feedback.value = "Stickerul ${sticker.name} este blocat. Obține ${sticker.requiredStars} stele."
                            }
                        }
                ) {
                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(if (unlocked) Color(0xFFFFF9C4) else Color(0xFFE0E0E0)),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = if (unlocked) sticker.emoji else "🔒",
                            textAlign = TextAlign.Center,
                            modifier = Modifier.padding(8.dp)
                        )
                    }
                }
            }
        }
        if (feedback.value.isNotEmpty()) {
            Text(text = feedback.value, modifier = Modifier.padding(top = 8.dp))
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}