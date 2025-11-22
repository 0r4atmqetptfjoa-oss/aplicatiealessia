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
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
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
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * A refreshed xylophone screen using colourful bars with press
 * animations.  Each bar plays a different tone and awards a star.
 * Children are invited to explore by the vibrant colours and clear
 * typography.  A background image and header tie this screen into the
 * overall application.
 */
@Composable
fun InstrumentScreen(navController: NavController, starState: MutableState<Int>) {
    val toneGenerator = remember { ToneGenerator(AudioManager.STREAM_MUSIC, 80) }
    DisposableEffect(Unit) {
        onDispose { toneGenerator.release() }
    }
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
    var feedback by remember { mutableStateOf("") }
    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.generic_background_mainmenu_morning_f0001),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
            Text(
                text = "Instrument Xilofon",
                style = MaterialTheme.typography.displayMedium,
                fontFamily = FontFamily.Cursive,
                modifier = Modifier
                    .padding(bottom = 16.dp)
                    .align(Alignment.CenterHorizontally)
            )
            // Display each bar in a column.  We could use a grid but bars
            // look better stacked vertically with different colours.
            tones.forEachIndexed { index, tone ->
                val color = colors[index]
                val interactionSource = remember { MutableInteractionSource() }
                val isPressed by interactionSource.collectIsPressedAsState()
                val scale by animateFloatAsState(
                    targetValue = if (isPressed) 0.98f else 1f,
                    animationSpec = tween(durationMillis = 150),
                    label = "xylophonePressScale"
                )
                Card(
                    onClick = {
                        toneGenerator.startTone(tone, 200)
                        starState.value += 1
                        feedback = "Bravo! Ai câștigat o stea."
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(40.dp)
                        .padding(vertical = 4.dp)
                        .graphicsLayer {
                            scaleX = scale
                            scaleY = scale
                        },
                    colors = CardDefaults.cardColors(containerColor = color),
                    elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
                    interactionSource = interactionSource
                ) {
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.CenterStart
                    ) {
                        Text(
                            text = "Nota ${index + 1}",
                            modifier = Modifier.padding(start = 16.dp),
                            color = Color.White,
                            style = MaterialTheme.typography.bodyLarge,
                            fontFamily = FontFamily.Cursive
                        )
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
        IconButton(
            onClick = { navController.navigate(Screen.MainMenu.route) },
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