package com.example.educationalapp.ui.components

import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.graphics.asFrameworkPaint
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.graphics.Paint
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.IntSize
import android.graphics.Rect

@Composable
fun SpriteAnimation(
    sheet: ImageBitmap,       // Imaginea mare (Sprite Sheet)
    frameWidth: Int,          // Latimea unui singur cadru (din JSON)
    frameHeight: Int,         // Inaltimea unui singur cadru (din JSON)
    frameCount: Int,          // Numarul total de cadre (din JSON)
    fps: Int = 30,            // Viteza (din JSON)
    loop: Boolean = true,     // Daca se repeta
    modifier: Modifier = Modifier
) {
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
        val cols = sheet.width / frameWidth
        
        val currentFrame = frameIndex % frameCount
        
        val col = currentFrame % cols
        val row = currentFrame / cols
        
        val srcX = col * frameWidth
        val srcY = row * frameHeight

        drawIntoCanvas { canvas ->
            val paint = Paint()
            val srcRect = Rect(srcX, srcY, srcX + frameWidth, srcY + frameHeight)
            
            val dstRect = Rect(0, 0, size.width.toInt(), size.height.toInt())
            
            canvas.nativeCanvas.drawBitmap(
                sheet.asAndroidBitmap(),
                srcRect,
                dstRect,
                paint.asFrameworkPaint()
            )
        }
    }
}