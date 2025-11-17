package com.example.educationalapp

import android.media.MediaPlayer
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * Screen for playing a selected song.  Uses MediaPlayer to play an audio
 * resource stored in res/raw.  When the song completes, the player awards
 * one star.
 *
 * @param songId Index of the song selected in the SongsMenuScreen.
 */
@Composable
fun SongPlayerScreen(navController: NavController, starState: MutableState<Int>, songId: Int) {
    val context = LocalContext.current
    val songTitles = listOf(
        "Cântec de leagăn",
        "La mulți ani",
        "Bate toba",
        "Happy Birthday"
    )
    val resIds = listOf(
        R.raw.song_0,
        R.raw.song_1,
        R.raw.song_2,
        R.raw.song_3
    )
    val title = songTitles.getOrElse(songId) { "Melodie" }
    val resId = resIds.getOrElse(songId) { R.raw.song_0 }
    var mediaPlayer by remember { mutableStateOf<MediaPlayer?>(null) }
    var isPlaying by remember { mutableStateOf(false) }
    DisposableEffect(key1 = resId) {
        onDispose {
            mediaPlayer?.release()
        }
    }
    fun startPlayback() {
        mediaPlayer?.release()
        mediaPlayer = MediaPlayer.create(context, resId)
        mediaPlayer?.setOnCompletionListener {
            isPlaying = false
            starState.value += 1
            it.release()
        }
        isPlaying = true
        mediaPlayer?.start()
    }
    fun stopPlayback() {
        mediaPlayer?.let {
            if (it.isPlaying) {
                it.stop()
            }
            it.release()
        }
        isPlaying = false
        mediaPlayer = null
    }
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = title, modifier = Modifier.padding(bottom = 16.dp))
        Row(modifier = Modifier.padding(bottom = 16.dp)) {
            Button(onClick = {
                if (isPlaying) {
                    stopPlayback()
                } else {
                    startPlayback()
                }
            }) {
                Text(text = if (isPlaying) "Pauză" else "Redă")
            }
        }
        Button(onClick = { navController.navigate(Screen.SongsMenu.route) }) {
            Text(text = "Înapoi la Melodii")
        }
    }
}