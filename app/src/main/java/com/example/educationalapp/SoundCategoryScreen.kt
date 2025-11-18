package com.example.educationalapp

import android.media.AudioManager
import android.media.ToneGenerator
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
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
 * Enhanced sound category screen presenting a grid of sound items with
 * rich feedback and styling.  Each item is a card with a large emoji
 * representing the sound.  Pressing an item plays a tone and awards a
 * star after exploring five unique sounds.  A background image and
 * header unify the look with other menus.
 */
@Composable
fun SoundCategoryScreen(
    navController: NavController,
    starState: MutableState<Int>,
    category: String
) {
    // Define each sound item with a name, emoji and ToneGenerator type.
    data class CategoryItem(val name: String, val emoji: String, val toneType: Int)
    val itemsForCategory: Map<String, List<CategoryItem>> = mapOf(
        "birds" to listOf(
            CategoryItem("Vrăbiuță", "🐦", ToneGenerator.TONE_CDMA_HIGH_L),
            CategoryItem("Bufniță", "🦉", ToneGenerator.TONE_CDMA_MED_L),
            CategoryItem("Papagal", "🦜", ToneGenerator.TONE_CDMA_ABBR_ALERT)
        ),
        "vehicles" to listOf(
            CategoryItem("Mașină", "🚗", ToneGenerator.TONE_CDMA_NETWORK_BUSY),
            CategoryItem("Tren", "🚂", ToneGenerator.TONE_SUP_RINGTONE),
            CategoryItem("Ambulanță", "🚑", ToneGenerator.TONE_CDMA_HIGH_SS)
        ),
        "farm" to listOf(
            CategoryItem("Vacă", "🐮", ToneGenerator.TONE_CDMA_LOW_L),
            CategoryItem("Cal", "🐴", ToneGenerator.TONE_SUP_CONGESTION),
            CategoryItem("Oaie", "🐑", ToneGenerator.TONE_CDMA_MED_SS)
        ),
        "jungle" to listOf(
            CategoryItem("Leu", "🦁", ToneGenerator.TONE_CDMA_HIGH_SS),
            CategoryItem("Maimuță", "🐒", ToneGenerator.TONE_CDMA_MED_L),
            CategoryItem("Elefant", "🐘", ToneGenerator.TONE_SUP_PIP)
        ),
        "maritime" to listOf(
            CategoryItem("Pește", "🐟", ToneGenerator.TONE_CDMA_LOW_SS),
            CategoryItem("Balena", "🐋", ToneGenerator.TONE_CDMA_MED_SS),
            CategoryItem("Delfin", "🐬", ToneGenerator.TONE_CDMA_MED_L)
        )
    )
    val items = itemsForCategory[category] ?: emptyList()
    // State to track plays and feedback messages.  Award a star after
    // exploring five sounds.
    var plays by remember { mutableStateOf(0) }
    var feedback by remember { mutableStateOf("") }
    val toneGenerator = remember { ToneGenerator(AudioManager.STREAM_MUSIC, 100) }
    DisposableEffect(Unit) {
        onDispose { toneGenerator.release() }
    }
    fun playTone(item: CategoryItem) {
        toneGenerator.startTone(item.toneType, 300)
        plays++
        if (plays >= 5) {
            starState.value += 1
            feedback = "Bravo! Ai explorat 5 sunete și ai câștigat o stea."
            plays = 0
        }
    }
    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.lumea_background),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
            val capitalized = category.replaceFirstChar { if (it.isLowerCase()) it.titlecase() else it.toString() }
            Text(
                text = "Categorie: $capitalized",
                style = MaterialTheme.typography.displayMedium,
                fontFamily = FontFamily.Cursive,
                modifier = Modifier
                    .padding(bottom = 16.dp)
                    .align(Alignment.CenterHorizontally)
            )
            if (items.isNotEmpty()) {
                LazyVerticalGrid(
                    columns = GridCells.Fixed(2),
                    modifier = Modifier.weight(1f),
                    verticalArrangement = Arrangement.spacedBy(12.dp),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    items(items.size) { idx ->
                        val item = items[idx]
                        val interactionSource = remember { MutableInteractionSource() }
                        val isPressed by interactionSource.collectIsPressedAsState()
                        val scale by animateFloatAsState(
                            targetValue = if (isPressed) 0.95f else 1f,
                            animationSpec = tween(durationMillis = 150),
                            label = "soundPressScale"
                        )
                        var visible by remember { mutableStateOf(false) }
                        LaunchedEffect(Unit) { visible = true }
                        AnimatedVisibility(
                            visible = visible,
                            enter = slideInVertically(initialOffsetY = { it / 2 }) + fadeIn(),
                            exit = slideOutVertically() + fadeOut()
                        ) {
                            Card(
                                onClick = { playTone(item) },
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
                                    modifier = Modifier
                                        .fillMaxSize()
                                        .padding(12.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Column(
                                        horizontalAlignment = Alignment.CenterHorizontally,
                                        verticalArrangement = Arrangement.Center,
                                        modifier = Modifier.fillMaxSize()
                                    ) {
                                        Text(
                                            text = item.emoji,
                                            style = MaterialTheme.typography.displayLarge
                                        )
                                        Spacer(modifier = Modifier.height(4.dp))
                                        Text(
                                            text = item.name,
                                            style = MaterialTheme.typography.titleMedium,
                                            fontFamily = FontFamily.Cursive
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Text(
                    text = "Nu există sunete pentru această categorie.",
                    style = MaterialTheme.typography.titleMedium,
                    fontFamily = FontFamily.Cursive,
                    modifier = Modifier.padding(16.dp)
                )
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
        // Back arrow to return to the sounds menu
        IconButton(
            onClick = { navController.navigate(Screen.SoundsMenu.route) },
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