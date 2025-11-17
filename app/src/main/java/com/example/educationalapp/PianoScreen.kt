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
import androidx.navigation.NavController

/**
 * A simple piano implementation using ToneGenerator.  Each bar plays a
 * different tone when tapped.  Pressing a key awards a star.
 */
@Composable
fun PianoScreen(navController: NavController, starState: MutableState<Int>) {
    val toneGenerator = ToneGenerator(AudioManager.STREAM_MUSIC, 80)
    // Use a selection of DTMF tones to simulate different piano notes
    val tones = listOf(
        ToneGenerator.TONE_DTMF_1,
        ToneGenerator.TONE_DTMF_2,
        ToneGenerator.TONE_DTMF_3,
        ToneGenerator.TONE_DTMF_4,
        ToneGenerator.TONE_DTMF_5,
        ToneGenerator.TONE_DTMF_6,
        ToneGenerator.TONE_DTMF_7
    )
    val colors = listOf(
        Color(0xFFFFFFFF), // white keys
        Color(0xFFF8F8F8),
        Color(0xFFF0F0F0),
        Color(0xFFE8E8E8),
        Color(0xFFE0E0E0),
        Color(0xFFD8D8D8),
        Color(0xFFD0D0D0)
    )
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Pian", modifier = Modifier.padding(bottom = 16.dp))
        colors.forEachIndexed { index, color ->
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(40.dp)
                    .padding(vertical = 2.dp)
                    .background(color)
                    .clickable {
                        toneGenerator.startTone(tones[index % tones.size], 200)
                        starState.value += 1
                    }
            ) {
                Text(text = "Clapă ${index + 1}", modifier = Modifier.padding(8.dp))
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.InstrumentsMenu.route) }) {
            Text(text = "Înapoi la Instrumente")
        }
    }
}