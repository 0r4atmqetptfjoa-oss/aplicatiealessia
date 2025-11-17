package com.example.educationalapp

import android.media.AudioManager
import android.media.ToneGenerator
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.Alignment
import androidx.navigation.NavController

/**
 * A simple drum kit using ToneGenerator.  Each drum pad plays a different
 * system tone to mimic drum sounds.  Tapping a drum earns a star.
 */
@Composable
fun DrumsScreen(navController: NavController, starState: MutableState<Int>) {
    val toneGenerator = ToneGenerator(AudioManager.STREAM_MUSIC, 80)
    val drumTones = listOf(
        ToneGenerator.TONE_PROP_BEEP,
        ToneGenerator.TONE_PROP_ACK,
        ToneGenerator.TONE_PROP_NACK,
        ToneGenerator.TONE_PROP_PROMPT
    )
    val colors = listOf(
        Color(0xFFB71C1C),
        Color(0xFF1B5E20),
        Color(0xFF0D47A1),
        Color(0xFFF57F17)
    )
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Tobe", modifier = Modifier.padding(bottom = 16.dp))
        // Display drum pads in a grid (2x2)
        val pads = drumTones.size
        for (row in 0 until 2) {
            Row(modifier = Modifier.fillMaxWidth().weight(1f), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                for (col in 0 until 2) {
                    val index = row * 2 + col
                    Box(
                        modifier = Modifier
                            .weight(1f)
                            .fillMaxHeight()
                            .background(colors[index])
                            .clickable {
                                toneGenerator.startTone(drumTones[index], 200)
                                starState.value += 1
                            },
                        contentAlignment = Alignment.Center
                    ) {
                        Text(text = "Pad ${index + 1}", color = Color.White)
                    }
                }
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.InstrumentsMenu.route) }) {
            Text(text = "Înapoi la Instrumente")
        }
    }
}