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
import androidx.compose.foundation.layout.size
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

@Composable
fun XylophoneScreen(navController: NavController, starState: MutableState<Int>) {
    val toneGenerator = remember { ToneGenerator(AudioManager.STREAM_MUSIC, 80) }
    DisposableEffect(Unit) {
        onDispose { toneGenerator.release() }
    }
    val tones = listOf(
        ToneGenerator.TONE_DTMF_0,
        ToneGenerator.TONE_DTMF_1,
        ToneGenerator.TONE_DTMF_2,
        ToneGenerator.TONE_DTMF_3,
        ToneGenerator.TONE_DTMF_4,
        ToneGenerator.TONE_DTMF_5,
        ToneGenerator.TONE_DTMF_6,
        ToneGenerator.TONE_DTMF_7
    )
    val colors = listOf(
        Color(0xFFC62828), // Red
        Color(0xFFF9A825), // Yellow
        Color(0xFF2E7D32), // Green
        Color(0xFF1565C0), // Blue
        Color(0xFF6A1B9A), // Purple
        Color(0xFFE65100), // Orange
        Color(0xFFD81B60),  // Pink
        Color(0xFF00838F)  // Cyan
    )

    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.lumea_background),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
            Text(
                text = "Xilofon",
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
                items(tones.size) { idx ->
                    val tone = tones[idx]
                    val color = colors[idx]
                    val interactionSource = remember { MutableInteractionSource() }
                    val isPressed by interactionSource.collectIsPressedAsState()
                    val scale by animateFloatAsState(
                        targetValue = if (isPressed) 0.95f else 1f,
                        animationSpec = tween(durationMillis = 150),
                        label = "xylophoneKeyPressScale"
                    )
                    Card(
                        onClick = {
                            toneGenerator.startTone(tone, 200)
                            starState.value += 1
                        },
                        modifier = Modifier
                            .fillMaxWidth()
                            .aspectRatio(1f)
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
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = "Nota ${idx + 1}",
                                style = MaterialTheme.typography.titleMedium,
                                color = Color.White,
                                fontFamily = FontFamily.Cursive
                            )
                        }
                    }
                }
            }
        }
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
