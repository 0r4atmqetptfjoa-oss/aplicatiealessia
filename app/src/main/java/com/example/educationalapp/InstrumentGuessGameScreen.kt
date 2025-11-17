package com.example.educationalapp

import android.media.ToneGenerator
import android.media.AudioManager
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import kotlin.random.Random

/**
 * A game where a tone representing a musical instrument is played and the
 * child must guess which instrument it is.  Since we do not include real
 * audio samples, each instrument is represented by a different tone
 * pattern.  Correct guesses yield stars and points.  This is a fun way
 * to reinforce instrument names before trying the real instrument screens.
 */
data class InstrumentTone(val name: String, val toneType: Int)

@Composable
fun InstrumentGuessGameScreen(navController: NavController, starState: MutableState<Int>) {
    val instruments = listOf(
        InstrumentTone("Pian", ToneGenerator.TONE_CDMA_HIGH_L),
        InstrumentTone("Tobe", ToneGenerator.TONE_CDMA_LOW_L),
        InstrumentTone("Xilofon", ToneGenerator.TONE_CDMA_MED_L)
    )
    val toneGenerator = remember { ToneGenerator(AudioManager.STREAM_MUSIC, 100) }
    DisposableEffect(Unit) { onDispose { toneGenerator.release() } }
    var current by remember { mutableStateOf(instruments[0]) }
    var options by remember { mutableStateOf(listOf<InstrumentTone>()) }
    var feedback by remember { mutableStateOf("") }
    var score by remember { mutableStateOf(0) }
    fun playInstrument(instrument: InstrumentTone) {
        // Play the tone for 500 ms
        toneGenerator.startTone(instrument.toneType, 500)
    }
    fun newRound() {
        feedback = ""
        current = instruments.random()
        playInstrument(current)
        val set = mutableSetOf<InstrumentTone>()
        val list = mutableListOf<InstrumentTone>()
        val correctIndex = Random.nextInt(3)
        for (i in 0 until 3) {
            if (i == correctIndex) {
                list.add(current)
            } else {
                var inst: InstrumentTone
                do {
                    inst = instruments.random()
                } while (inst == current || inst in set)
                set.add(inst)
                list.add(inst)
            }
        }
        options = list
    }
    LaunchedEffect(Unit) { newRound() }
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Ghicește Instrumentul", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Ascultă sunetul și alege instrumentul corect", modifier = Modifier.padding(bottom = 16.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            options.forEach { option ->
                Button(onClick = {
                    if (option == current) {
                        feedback = "Corect!";
                        score += 10; starState.value += 2
                    } else {
                        feedback = "Greșit!";
                        score = (score - 5).coerceAtLeast(0)
                    }
                    newRound()
                }, modifier = Modifier.weight(1f)) {
                    Text(text = option.name)
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