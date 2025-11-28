package com.example.educationalapp.ui.components

import android.graphics.Rect
import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.nativeCanvas

@Composable
fun SpriteAnimation(
    sheet: ImageBitmap,
    frameWidth: Int,
    frameHeight: Int,
    frameCount: Int,
    fps: Int = 30,
    loop: Boolean = true,
    modifier: Modifier = Modifier
) {
    // Check for oversized bitmaps to prevent GPU texture limit errors
    if (sheet.width > 4096 || sheet.height > 4096) {
        throw IllegalArgumentException("Sprite sheet dimensions (${sheet.width}x${sheet.height}) exceed the maximum recommended texture size (4096x4096). Downscale the bitmap before use.")
    }

    val transition = rememberInfiniteTransition(label = "SpriteTransition")
    
    val frameIndex by transition.animateValue(
        initialValue = 0,
        targetValue = frameCount, 
        typeConverter = Int.VectorConverter,
        animationSpec = infiniteRepeatable(
            animation = tween(
                durationMillis = (frameCount * 1000) / fps, 
                easing = LinearEasing 
            ),
            repeatMode = if (loop) RepeatMode.Restart else RepeatMode.Restart 
        ),
        label = "FrameIndex"
    )

    Canvas(modifier = modifier) {
        val cols = if (frameWidth > 0) sheet.width / frameWidth else 1
        val currentFrame = frameIndex % frameCount
        val col = currentFrame % cols
        val row = currentFrame / cols
        val srcX = col * frameWidth
        val srcY = row * frameHeight

        drawIntoCanvas { canvas ->
            // Use native Android Paint directly to fix import issues
            val nativePaint = android.graphics.Paint().apply {
                isAntiAlias = true
                isFilterBitmap = true
                isDither = true
            }
            val srcRect = Rect(srcX, srcY, srcX + frameWidth, srcY + frameHeight)
            val dstRect = Rect(0, 0, size.width.toInt(), size.height.toInt())
            
            canvas.nativeCanvas.drawBitmap(
                sheet.asAndroidBitmap(),
                srcRect,
                dstRect,
                nativePaint
            )
        }
    }
}
