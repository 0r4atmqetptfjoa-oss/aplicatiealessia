package com.example.educationalapp

import android.media.ToneGenerator
import android.media.AudioManager
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

@Composable
fun InstrumentScreen(navController: NavController, starState: MutableState<Int>) {
    // Use ToneGenerator to play tones; define mapping of index to DTMF tones
    val toneGenerator = ToneGenerator(AudioManager.STREAM_MUSIC, 80)
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
        Color(0xFFE74C3C),
        Color(0xFFF39C12),
        Color(0xFFF1C40F),
        Color(0xFF2ECC71),
        Color(0xFF3498DB),
        Color(0xFF9B59B6),
        Color(0xFF7F8C8D)
    )

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Instrument Xilofon", modifier = Modifier.padding(bottom = 16.dp))
        colors.forEachIndexed { index, color ->
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(40.dp)
                    .padding(vertical = 4.dp)
                    .background(color)
                    .clickable {
                        toneGenerator.startTone(tones[index], 200)
                        starState.value += 1
                    }
            ) {
                // Optionally label notes
                Text(text = "Nota ${index + 1}", modifier = Modifier.padding(8.dp), color = Color.White)
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}