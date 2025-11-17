package com.example.educationalapp

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.drawCircle
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.drawscope.drawLine
import androidx.compose.ui.graphics.drawscope.drawOval
import androidx.compose.ui.graphics.drawscope.rotate
import androidx.compose.ui.graphics.drawscope.drawArc
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * Screen that lets the child design a simple avatar.  They can pick a hair
 * colour, eye style and mouth expression.  When the avatar is saved for the
 * first time, the child earns three stars.  The drawing uses simple shapes on
 * a canvas and transitions animate smoothly when attributes change.
 */
@OptIn(ExperimentalAnimationApi::class)
@Composable
fun AvatarCreatorScreen(navController: NavController, starState: MutableState<Int>) {
    // Available hair colours
    val hairColours = listOf(Color(0xFF4A90E2), Color(0xFFFFD700), Color(0xFF8B4513), Color(0xFF000000), Color(0xFFFF69B4))
    // Eye types: 0 = round eyes, 1 = star eyes
    val eyeTypes = listOf("Rotunde", "Stele")
    // Mouth types: 0 = smile, 1 = neutral, 2 = surprins
    val mouthTypes = listOf("Zâmbet", "Neutru", "Surprins")

    var hairColour by remember { mutableStateOf(hairColours[0]) }
    var selectedEye by remember { mutableStateOf(0) }
    var selectedMouth by remember { mutableStateOf(0) }
    var saved by remember { mutableStateOf(false) }
    var feedback by remember { mutableStateOf("") }

    val density = LocalDensity.current

    fun saveAvatar() {
        if (!saved) {
            starState.value += 3
            feedback = "Avatar salvat! Ai primit 3 stele."
            saved = true
        } else {
            feedback = "Avatarul este deja salvat."
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(text = "Creează Avatar", style = MaterialTheme.typography.titleLarge)
        Spacer(modifier = Modifier.height(16.dp))
        // Display the avatar drawing
        Box(modifier = Modifier.size(200.dp)) {
            androidx.compose.foundation.Canvas(modifier = Modifier.fillMaxSize()) {
                // Draw head
                val centerX = size.width / 2
                val centerY = size.height / 2
                val radius = size.minDimension / 2 * 0.8f
                drawCircle(color = Color(0xFFFFE0BD), center = androidx.compose.ui.geometry.Offset(centerX, centerY), radius = radius)
                // Hair as a half circle at top
                drawOval(
                    color = hairColour,
                    topLeft = androidx.compose.ui.geometry.Offset(centerX - radius, centerY - radius * 1.1f),
                    size = androidx.compose.ui.geometry.Size(radius * 2, radius * 1.2f)
                )
                // Eyes
                val eyeY = centerY - radius * 0.3f
                val eyeXOffset = radius * 0.4f
                when (selectedEye) {
                    0 -> {
                        // round eyes
                        drawCircle(color = Color.Black, center = androidx.compose.ui.geometry.Offset(centerX - eyeXOffset, eyeY), radius = radius * 0.08f)
                        drawCircle(color = Color.Black, center = androidx.compose.ui.geometry.Offset(centerX + eyeXOffset, eyeY), radius = radius * 0.08f)
                    }
                    1 -> {
                        // star eyes – draw using simple star-like lines
                        fun drawStar(x: Float, y: Float) {
                            val size = radius * 0.12f
                            rotate(0f) {
                                drawLine(Color.Black, androidx.compose.ui.geometry.Offset(x - size, y), androidx.compose.ui.geometry.Offset(x + size, y), strokeWidth = 3f)
                                drawLine(Color.Black, androidx.compose.ui.geometry.Offset(x, y - size), androidx.compose.ui.geometry.Offset(x, y + size), strokeWidth = 3f)
                            }
                        }
                        drawStar(centerX - eyeXOffset, eyeY)
                        drawStar(centerX + eyeXOffset, eyeY)
                    }
                }
                // Mouth
                val mouthY = centerY + radius * 0.3f
                when (selectedMouth) {
                    0 -> {
                        // smile
                        drawArc(
                            color = Color.Black,
                            startAngle = 200f,
                            sweepAngle = 140f,
                            useCenter = false,
                            topLeft = androidx.compose.ui.geometry.Offset(centerX - radius * 0.4f, mouthY - radius * 0.1f),
                            size = androidx.compose.ui.geometry.Size(radius * 0.8f, radius * 0.5f)
                        )
                    }
                    1 -> {
                        // neutral
                        drawLine(
                            Color.Black,
                            androidx.compose.ui.geometry.Offset(centerX - radius * 0.3f, mouthY),
                            androidx.compose.ui.geometry.Offset(centerX + radius * 0.3f, mouthY),
                            strokeWidth = 6f
                        )
                    }
                    2 -> {
                        // surprised
                        drawCircle(
                            color = Color.Black,
                            center = androidx.compose.ui.geometry.Offset(centerX, mouthY),
                            radius = radius * 0.08f
                        )
                    }
                }
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        // Hair colour selection
        Text(text = "Alege culoarea părului:")
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            hairColours.forEach { colour ->
                Box(
                    modifier = Modifier
                        .size(40.dp)
                        .background(colour, shape = CircleShape)
                        .selectable(
                            selected = hairColour == colour,
                            onClick = { hairColour = colour }
                        )
                )
            }
        }
        Spacer(modifier = Modifier.height(12.dp))
        // Eye type selection
        Text(text = "Alege ochii:")
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            eyeTypes.forEachIndexed { index, label ->
                Button(onClick = { selectedEye = index }, modifier = Modifier.weight(1f).padding(4.dp)) {
                    Text(text = label)
                }
            }
        }
        Spacer(modifier = Modifier.height(12.dp))
        // Mouth type selection
        Text(text = "Alege gura:")
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            mouthTypes.forEachIndexed { index, label ->
                Button(onClick = { selectedMouth = index }, modifier = Modifier.weight(1f).padding(4.dp)) {
                    Text(text = label)
                }
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { saveAvatar() }) {
            Text(text = "Salvează Avatar")
        }
        if (feedback.isNotEmpty()) {
            Text(text = feedback, modifier = Modifier.padding(top = 8.dp))
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}