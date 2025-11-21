package com.example.educationalapp

import androidx.annotation.DrawableRes
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.res.imageResource
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

data class DrawingStroke(val points: List<Offset>, val color: Color)

@Composable
fun DrawingScreen(navController: NavController, starState: MutableState<Int>) {
    var strokes by remember { mutableStateOf<List<DrawingStroke>>(emptyList()) }
    var currentPoints by remember { mutableStateOf<List<Offset>>(emptyList()) }
    var currentColor by remember { mutableStateOf(Color.Red) }
    var drawn by remember { mutableStateOf(false) }

    Column(modifier = Modifier
        .fillMaxSize()
        .padding(16.dp)) {
        Text(text = "Desen și Colorează", modifier = Modifier.padding(bottom = 8.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            listOf(Color.Red, Color.Green, Color.Blue, Color.Yellow, Color.Magenta, Color.Cyan).forEach { color ->
                Box(
                    modifier = Modifier
                        .size(32.dp)
                        .background(color)
                        .clickable { currentColor = color }
                )
            }
        }
        Spacer(modifier = Modifier.height(8.dp))

        Box(modifier = Modifier
            .fillMaxWidth()
            .weight(1f)) {
            Canvas(modifier = Modifier
                .fillMaxSize()
                .background(Color.White)
                .pointerInput(Unit) {
                    detectDragGestures(
                        onDragStart = { offset ->
                            currentPoints = listOf(offset)
                            drawn = true
                        },
                        onDrag = { change, _ ->
                            currentPoints = currentPoints + change.position
                        },
                        onDragEnd = {
                            if (currentPoints.isNotEmpty()) {
                                strokes = strokes + DrawingStroke(currentPoints, currentColor)
                            }
                            currentPoints = emptyList()
                        }
                    )
                }) {
                // Draw existing strokes
                strokes.forEach { stroke ->
                    if (stroke.points.size > 1) {
                        val path = Path().apply {
                            moveTo(stroke.points.first().x, stroke.points.first().y)
                            stroke.points.drop(1).forEach { lineTo(it.x, it.y) }
                        }
                        drawPath(path = path, color = stroke.color, style = Stroke(width = 6f))
                    }
                }
                // Draw current path
                if (currentPoints.size > 1) {
                    val path = Path().apply {
                        moveTo(currentPoints.first().x, currentPoints.first().y)
                        currentPoints.drop(1).forEach { lineTo(it.x, it.y) }
                    }
                    drawPath(path = path, color = currentColor, style = Stroke(width = 6f))
                }
            }

            BouncingBallAnimation(
                modifier = Modifier
                    .size(50.dp)
                    .align(Alignment.TopEnd)
            )
        }

        Spacer(modifier = Modifier.height(8.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(onClick = {
                strokes = emptyList()
                currentPoints = emptyList()
            }) {
                Text(text = "Curăță")
            }
            Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
                Text(text = "Înapoi la Meniu")
            }
        }
        // Award star after first draw
        if (drawn) {
            LaunchedEffect(Unit) {
                starState.value += 2
                drawn = false
            }
        }
    }
}

@Composable
fun BouncingBallAnimation(modifier: Modifier = Modifier) {
    val infiniteTransition = rememberInfiniteTransition(label = "bouncing_ball")
    val yOffset by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 50f,
        animationSpec = infiniteRepeatable(
            animation = tween(1000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ), label = "ball_bounce"
    )

    Canvas(modifier = modifier.graphicsLayer { translationY = yOffset }) {
        drawCircle(
            color = Color.Blue,
            radius = size.minDimension / 2
        )
    }
}

/*
 * Puteți utiliza acest Composable pentru a reda o animație dintr-o foaie de calcul (sprite sheet).
 * Asigurați-vă că adăugați fișierul de imagine în `res/drawable` și actualizați `drawableResId`.
 *
 * @param modifier Modificatorul care va fi aplicat animației.
 * @param drawableResId ID-ul resursei pentru foaia de calcul.
 * @param totalFrames Numărul total de cadre din foaia de calcul (presupunând că sunt pe un singur rând orizontal).
 * @param frameDurationMillis Durata de afișare a fiecărui cadru.
 */
/*
@Composable
fun SpriteSheetAnimation(
    modifier: Modifier = Modifier,
    @DrawableRes drawableResId: Int,
    totalFrames: Int,
    frameDurationMillis: Int
) {
    val imageBitmap = imageResource(id = drawableResId)
    val frameWidth = imageBitmap.width / totalFrames

    val infiniteTransition = rememberInfiniteTransition(label = "sprite_animation_transition")
    val currentFrame by infiniteTransition.animateValue(
        initialValue = 0,
        targetValue = totalFrames,
        typeConverter = Int.VectorConverter,
        animationSpec = infiniteRepeatable(
            animation = tween(
                durationMillis = totalFrames * frameDurationMillis,
                easing = LinearEasing
            ),
            repeatMode = RepeatMode.Restart
        ), label = "sprite_frame"
    )

    Canvas(modifier = modifier) {
        drawImage(
            image = imageBitmap,
            srcOffset = IntOffset(currentFrame * frameWidth, 0),
            srcSize = IntSize(frameWidth, imageBitmap.height),
            dstSize = IntSize(size.width.toInt(), size.height.toInt())
        )
    }
}
*/
