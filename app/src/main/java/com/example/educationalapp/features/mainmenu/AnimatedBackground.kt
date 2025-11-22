package com.example.educationalapp.features.mainmenu

import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import com.example.educationalapp.R

@Composable
fun AnimatedBackground(modifier: Modifier = Modifier) {
    val backgroundImages = listOf(
        R.drawable.generic_background_mainmenu_morning_f0001,
        R.drawable.generic_background_mainmenu_morning_f0002,
        R.drawable.generic_background_mainmenu_morning_f0003,
        R.drawable.generic_background_mainmenu_morning_f0004,
        R.drawable.generic_background_mainmenu_morning_f0005,
        R.drawable.generic_background_mainmenu_morning_f0006,
        R.drawable.generic_background_mainmenu_morning_f0007,
        R.drawable.generic_background_mainmenu_morning_f0008,
        R.drawable.generic_background_mainmenu_morning_f0009,
        R.drawable.generic_background_mainmenu_morning_f0010,
        R.drawable.generic_background_mainmenu_morning_f0011,
        R.drawable.generic_background_mainmenu_morning_f0012,
    )

    val infiniteTransition = rememberInfiniteTransition(label = "background_animation")
    val imageIndex by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = backgroundImages.size.toFloat(),
        animationSpec = infiniteRepeatable(
            // Durata totala a animatiei: 12 cadre * 250ms/cadru = 3000ms
            animation = tween(durationMillis = 3000, easing = LinearEasing)
        ),
        label = "background_image_index"
    )

    Box(modifier = modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = backgroundImages[imageIndex.toInt() % backgroundImages.size]),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
    }
}
