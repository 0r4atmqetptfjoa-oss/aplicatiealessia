package com.example.educationalapp.ui.components

import androidx.annotation.DrawableRes
import androidx.compose.foundation.Image
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource

/**
 * Displays a drawable resource. 
 *
 * This is a step towards a full frame-by-frame animation player. The final
 * implementation will handle loading and displaying a sequence of drawable
 * resources to create an animation effect.
 */
@Composable
fun FrameAnimationPlayer(
    modifier: Modifier = Modifier,
    @DrawableRes drawableId: Int,
) {
    Image(
        painter = painterResource(id = drawableId),
        contentDescription = null, // decorative element
        modifier = modifier,
        contentScale = ContentScale.Fit
    )
}
