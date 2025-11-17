package com.example.educationalapp

import android.media.MediaPlayer
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.example.educationalapp.R

/**
 * A simple sound board that plays animal sounds when tapped.  Children receive
 * a star after playing a number of different sounds.  Audio files must be
 * placed in res/raw with names matching the soundResId provided (e.g.
 * R.raw.sound_cat).
 */
data class SoundItem(val name: String, val emoji: String, val soundResId: Int)

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun AnimalSoundBoardScreen(navController: NavController, starState: MutableState<Int>) {
    val context = LocalContext.current
    // Define the available sound items; actual audio resources must be added to res/raw
    val sounds = listOf(
        SoundItem("Câine", "🐶", R.raw.sound_dog),
        SoundItem("Pisică", "🐱", R.raw.sound_cat),
        SoundItem("Vacă", "🐮", R.raw.sound_cow),
        SoundItem("Cal", "🐴", R.raw.sound_horse),
        SoundItem("Broască", "🐸", R.raw.sound_frog),
        SoundItem("Leu", "🦁", R.raw.sound_lion),
        SoundItem("Oaie", "🐑", R.raw.sound_sheep),
        SoundItem("Elefant", "🐘", R.raw.sound_elephant)
    )
    var mediaPlayer by remember { mutableStateOf<MediaPlayer?>(null) }
    var plays by remember { mutableStateOf(0) }
    val feedback = remember { mutableStateOf("") }

    DisposableEffect(Unit) {
        onDispose {
            mediaPlayer?.release()
        }
    }

    fun playSound(item: SoundItem) {
        // release previous player
        mediaPlayer?.release()
        mediaPlayer = MediaPlayer.create(context, item.soundResId)
        mediaPlayer?.setOnCompletionListener { it.release() }
        mediaPlayer?.start()
        plays++
        if (plays >= 5) {
            starState.value += 1
            feedback.value = "Bravo! Ai explorat 5 sunete și ai câștigat o stea."
            plays = 0
        }
    }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Panou Sunete Animale", modifier = Modifier.padding(bottom = 16.dp))
        LazyVerticalGrid(columns = GridCells.Fixed(2), modifier = Modifier.weight(1f)) {
            items(sounds) { item ->
                Card(modifier = Modifier.padding(8.dp).fillMaxWidth().aspectRatio(1f)) {
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center
                    ) {
                        Button(onClick = { playSound(item) }) {
                            Text(text = "${item.emoji}\n${item.name}")
                        }
                    }
                }
            }
        }
        if (feedback.value.isNotEmpty()) {
            Text(text = feedback.value, modifier = Modifier.padding(bottom = 8.dp))
        }
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}