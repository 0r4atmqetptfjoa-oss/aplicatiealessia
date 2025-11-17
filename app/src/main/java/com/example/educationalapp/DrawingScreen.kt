package com.example.educationalapp

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

@Composable
fun DrawingScreen(navController: NavController, starState: MutableState<Int>) {
    // List of strokes; each stroke is a pair of color and path
    var strokes by remember { mutableStateOf<List<Pair<Color, Path>>>(emptyList()) }
    var currentPath by remember { mutableStateOf(Path()) }
    var currentColor by remember { mutableStateOf(Color.Red) }
    var drawn by remember { mutableStateOf(false) }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
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
        Canvas(modifier = Modifier
            .fillMaxWidth()
            .weight(1f)
            .background(Color.White)
            .pointerInput(Unit) {
                detectDragGestures(
                    onDragStart = { offset ->
                        currentPath = Path().apply { moveTo(offset.x, offset.y) }
                        drawn = true
                    },
                    onDrag = { change, _ ->
                        currentPath.lineTo(change.position.x, change.position.y)
                    },
                    onDragEnd = {
                        strokes = strokes + Pair(currentColor, currentPath)
                        currentPath = Path()
                    }
                )
            }) {
            // Draw existing strokes
            strokes.forEach { (color, path) ->
                drawPath(path = path, color = color, style = Stroke(width = 6f))
            }
            // Draw current path
            drawPath(path = currentPath, color = currentColor, style = Stroke(width = 6f))
        }
        Spacer(modifier = Modifier.height(8.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(onClick = {
                strokes = emptyList(); currentPath = Path()
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