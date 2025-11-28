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
import kotlin.math.ceil

@Composable
fun SpriteAnimation(
    sheet: ImageBitmap,
    frameCount: Int,
    columns: Int, // Adăugat: Numărul de coloane din imagine (ex: 8 pentru titlu, 5 pentru butoane)
    fps: Int = 30,
    loop: Boolean = true,
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
            repeatMode = RepeatMode.Restart
        ),
        label = "FrameIndex"
    )

    Canvas(modifier = modifier) {
        // [MODIFICARE MAJORĂ] Calculăm dimensiunile dinamic bazat pe imaginea reală încărcată
        // Asta previne eroarea când imaginea este redimensionată de Android
        val sheetWidth = sheet.width
        val sheetHeight = sheet.height
        
        // Calculăm dimensiunea unui singur cadru
        val frameWidth = sheetWidth / columns
        val rows = ceil(frameCount.toFloat() / columns).toInt()
        val frameHeight = if (rows > 0) sheetHeight / rows else sheetHeight

        val currentFrame = frameIndex % frameCount
        val col = currentFrame % columns
        val row = currentFrame / columns
        
        val srcX = col * frameWidth
        val srcY = row * frameHeight

        drawIntoCanvas { canvas ->
            val nativePaint = android.graphics.Paint().apply {
                isAntiAlias = true
                isFilterBitmap = true
                isDither = true
            }
            
            // Decupăm exact cadrul curent
            val srcRect = Rect(srcX, srcY, srcX + frameWidth, srcY + frameHeight)
            // Îl desenăm pe tot spațiul disponibil în UI
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