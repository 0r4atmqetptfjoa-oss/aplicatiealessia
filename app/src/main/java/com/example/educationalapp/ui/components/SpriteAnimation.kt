package com.example.educationalapp.ui.components

import android.graphics.Rect
import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.runtime.*
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
    columns: Int, // Câte coloane are imaginea pe orizontală
    fps: Int = 30,
    loop: Boolean = true,
    isPlaying: Boolean = true,
    onAnimationFinished: () -> Unit = {},
    modifier: Modifier = Modifier
) {
    val animatable = remember { Animatable(0f) }

    LaunchedEffect(isPlaying, loop) {
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

    Canvas(modifier = modifier) {
        // 1. Aflăm dimensiunile REALE ale imaginii încărcate în memorie
        val sheetWidth = sheet.width
        val sheetHeight = sheet.height
        
        // 2. Calculăm dimensiunea unui singur cadru (frame)
        // Indiferent dacă imaginea a fost micșorată de Android, matematica rămâne corectă
        val frameWidth = sheetWidth / columns
        
        // Calculăm numărul de rânduri necesar
        val rows = ceil(frameCount.toFloat() / columns).toInt()
        // Evităm împărțirea la 0 dacă rows e calculat greșit, deși nu ar trebui
        val safeRows = if (rows > 0) rows else 1
        val frameHeight = sheetHeight / safeRows

        // 3. Aflăm cadrul curent
        val currentFrame = (animatable.value.toInt() % frameCount).coerceIn(0, frameCount - 1)
        
        // 4. Calculăm poziția X și Y a cadrului în imaginea mare
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
            
            // Decupăm EXACT pătrățelul cu cadrul curent
            val srcRect = Rect(srcX, srcY, srcX + frameWidth, srcY + frameHeight)
            
            // Îl desenăm pe tot spațiul disponibil în UI (dstRect)
            val dstRect = Rect(0, 0, size.width.toInt(), size.height.toInt())

            try {
                canvas.nativeCanvas.drawBitmap(
                    sheet.asAndroidBitmap(),
                    srcRect,
                    dstRect,
                    nativePaint
                )
            } catch (e: Exception) {
                // Prevenim crash-ul dacă ceva e greșit la desenare, dar logăm eroarea
                e.printStackTrace()
            }
        }
    }
}