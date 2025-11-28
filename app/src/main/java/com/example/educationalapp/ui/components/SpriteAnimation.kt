package com.example.educationalapp.ui.components

import android.graphics.Rect
import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.platform.LocalDensity
import kotlin.math.ceil

@Composable
fun SpriteAnimation(
    sheet: ImageBitmap,
    frameCount: Int,
    columns: Int,
    modifier: Modifier = Modifier,
    frameIndex: Int? = null,
    fps: Int = 30,
    loop: Boolean = true,
    isPlaying: Boolean = true,
    onAnimationFinished: () -> Unit = {},
) {
    val animatable = remember { Animatable(0f) }

    LaunchedEffect(isPlaying, loop, frameIndex) {
        if (frameIndex != null) {
            animatable.snapTo(frameIndex.toFloat())
            return@LaunchedEffect
        }

        if (isPlaying) {
            val target = frameCount.toFloat()
            if (loop) {
                animatable.snapTo(0f)
                animatable.animateTo(
                    targetValue = target,
                    animationSpec = infiniteRepeatable(
                        animation = tween((frameCount * 1000) / fps, easing = LinearEasing),
                        repeatMode = RepeatMode.Restart
                    )
                )
            } else {
                animatable.snapTo(0f)
                animatable.animateTo(
                    targetValue = target,
                    animationSpec = tween((frameCount * 1000) / fps, easing = LinearEasing)
                )
                onAnimationFinished()
            }
        } else {
            animatable.snapTo(0f)
        }
    }

    // 🔹 dimensiunea naturală a unui frame, în px
    val sheetWidth = sheet.width
    val sheetHeight = sheet.height
    val frameWidthPx = sheetWidth / columns
    val rows = ceil(frameCount.toFloat() / columns).toInt().coerceAtLeast(1)
    val frameHeightPx = sheetHeight / rows

    // 🔹 transformăm px -> dp ca să facem Canvas exact cât un frame
    val density = LocalDensity.current
    val frameWidthDp = with(density) { frameWidthPx.toDp() }
    val frameHeightDp = with(density) { frameHeightPx.toDp() }

    // 🔹 întâi punem dimensiunea naturală, apoi aplicăm modifier-ul utilizatorului.
    // Dacă utilizatorul pune .size(115.dp), ACELA câștigă (e ultimul).
    val baseModifier = Modifier
        .size(frameWidthDp, frameHeightDp)
        .then(modifier)

    Canvas(modifier = baseModifier) {
        // recalculăm aici, dar e ieftin
        val frameWidth = size.width.toInt()   // 1:1 cu dp -> px
        val frameHeight = size.height.toInt()

        val currentFrame = (animatable.value.toInt() % frameCount).coerceIn(0, frameCount - 1)
        val col = currentFrame % columns
        val row = currentFrame / columns

        val srcX = col * frameWidthPx
        val srcY = row * frameHeightPx

        drawIntoCanvas { canvas ->
            val nativePaint = android.graphics.Paint().apply {
                isAntiAlias = true
                isFilterBitmap = true
                isDither = true
            }

            val srcRect = android.graphics.Rect(
                srcX,
                srcY,
                srcX + frameWidthPx,
                srcY + frameHeightPx
            )

            // ❗ dstRect acum are FIX dimensiunea Canvas-ului, care e setată la 1:1 cu frame-ul
            val dstRect = android.graphics.Rect(
                0,
                0,
                frameWidth,
                frameHeight
            )

            try {
                canvas.nativeCanvas.drawBitmap(
                    sheet.asAndroidBitmap(),
                    srcRect,
                    dstRect,
                    nativePaint
                )
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
