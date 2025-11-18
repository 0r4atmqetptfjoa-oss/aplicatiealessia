package com.example.educationalapp

import android.media.AudioManager
import android.media.ToneGenerator
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * A refreshed piano screen with a responsive layout and press animations.
 * Keys are displayed as square cards in a grid.  Tapping a key plays a
 * distinct tone and awards a star.  A background image and header tie
 * the experience together with the rest of the app.
 */
@Composable
fun PianoScreen(navController: NavController, starState: MutableState<Int>) {
    // Initialize ToneGenerator once and release it when leaving the screen.
    val toneGenerator = remember { ToneGenerator(AudioManager.STREAM_MUSIC, 80) }
    DisposableEffect(Unit) {
        onDispose { toneGenerator.release() }
    }
    // Define a set of tones to simulate piano notes.  We cycle through
    // these if there are more keys than tones.
    val tones = listOf(
        ToneGenerator.TONE_DTMF_1,
        ToneGenerator.TONE_DTMF_2,
        ToneGenerator.TONE_DTMF_3,
        ToneGenerator.TONE_DTMF_4,
        ToneGenerator.TONE_DTMF_5,
        ToneGenerator.TONE_DTMF_6,
        ToneGenerator.TONE_DTMF_7
    )
    // Build a list of 8 keys labelled 1 through 8.  The number of keys
    // can be changed by modifying this list.
    val keys = List(8) { index -> "Clapă ${index + 1}" }
    var feedback by remember { mutableStateOf("") }
    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.lumea_background),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
            Text(
                text = "Pian",
                style = MaterialTheme.typography.displayMedium,
                fontFamily = FontFamily.Cursive,
                modifier = Modifier
                    .padding(bottom = 16.dp)
                    .align(Alignment.CenterHorizontally)
            )
            LazyVerticalGrid(
                columns = GridCells.Fixed(2),
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(12.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                items(keys.size) { idx ->
                    val label = keys[idx]
                    val interactionSource = remember { MutableInteractionSource() }
                    val isPressed by interactionSource.collectIsPressedAsState()
                    val scale by animateFloatAsState(
                        targetValue = if (isPressed) 0.95f else 1f,
                        animationSpec = tween(durationMillis = 150),
                        label = "pianoKeyPressScale"
                    )
                    Card(
                        onClick = {
                            val tone = tones[idx % tones.size]
                            toneGenerator.startTone(tone, 200)
                            starState.value += 1
                            feedback = "Frumos! Ai câștigat o stea."
                        },
                        modifier = Modifier
                            .fillMaxWidth()
                            .aspectRatio(1f)
                            .graphicsLayer {
                                scaleX = scale
                                scaleY = scale
                            },
                        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
                        interactionSource = interactionSource
                    ) {
                        Box(
                            modifier = Modifier.fillMaxSize(),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = label,
                                style = MaterialTheme.typography.titleMedium,
                                fontFamily = FontFamily.Cursive
                            )
                        }
                    }
                }
            }
            if (feedback.isNotEmpty()) {
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = feedback,
                    style = MaterialTheme.typography.bodyLarge,
                    modifier = Modifier.align(Alignment.CenterHorizontally)
                )
            }
        }
        // Back arrow to return to the instruments menu
        IconButton(
            onClick = { navController.navigate(Screen.InstrumentsMenu.route) },
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(16.dp)
        ) {
            Icon(
                imageVector = Icons.Default.ArrowBack,
                contentDescription = "Înapoi",
                modifier = Modifier.size(36.dp)
            )
        }
    }
}