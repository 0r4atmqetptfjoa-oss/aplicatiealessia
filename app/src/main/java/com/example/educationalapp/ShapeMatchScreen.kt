package com.example.educationalapp

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Fill
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import kotlin.random.Random

enum class ShapeType { Circle, Square, Triangle }

data class NamedShape(val name: String, val type: ShapeType)

@Composable
fun ShapeMatchScreen(navController: NavController, starState: MutableState<Int>) {
    val shapes = remember {
        listOf(
            NamedShape("Cerc", ShapeType.Circle),
            NamedShape("Pătrat", ShapeType.Square),
            NamedShape("Triunghi", ShapeType.Triangle)
        )
    }
    var currentShape by remember { mutableStateOf(shapes[0]) }
    var options by remember { mutableStateOf(listOf<NamedShape>()) }
    var feedback by remember { mutableStateOf("") }
    var score by remember { mutableStateOf(0) }

    fun newRound() {
        feedback = ""
        currentShape = shapes.random()
        val set = mutableSetOf<NamedShape>()
        val optionList = mutableListOf<NamedShape>()
        val correctIndex = Random.nextInt(3)
        for (i in 0 until 3) {
            if (i == correctIndex) {
                optionList.add(currentShape)
            } else {
                var sh: NamedShape
                do {
                    sh = shapes.random()
                } while (sh == currentShape || sh in set)
                set.add(sh)
                optionList.add(sh)
            }
        }
        options = optionList
    }

    LaunchedEffect(Unit) { newRound() }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Potrivire Forme", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Alege forma: ${currentShape.name}", modifier = Modifier.padding(bottom = 16.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            options.forEach { option ->
                Box(
                    modifier = Modifier
                        .size(80.dp)
                        .background(Color(0xFFF0E68C))
                        .clickable {
                            if (option == currentShape) {
                                feedback = "Corect!";
                                score += 10; starState.value += 1
                            } else {
                                feedback = "Greșit!";
                                score = (score - 5).coerceAtLeast(0)
                            }
                            newRound()
                        }
                ) {
                    DrawShape(option.type)
                }
            }
        }
        Text(text = "Scor: $score", modifier = Modifier.padding(top = 16.dp))
        Text(text = feedback, modifier = Modifier.padding(top = 8.dp))
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}

@Composable
fun DrawShape(type: ShapeType) {
    Canvas(modifier = Modifier.fillMaxSize()) {
        when (type) {
            ShapeType.Circle -> {
                drawCircle(color = Color.Red, radius = size.minDimension / 3)
            }
            ShapeType.Square -> {
                val side = size.minDimension / 1.5f
                drawRect(color = Color.Green, topLeft = Offset((size.width - side) / 2, (size.height - side) / 2), size = androidx.compose.ui.geometry.Size(side, side))
            }
            ShapeType.Triangle -> {
                val path = Path().apply {
                    moveTo(size.width / 2f, size.height / 4f)
                    lineTo(size.width * 3/4f, size.height * 3/4f)
                    lineTo(size.width / 4f, size.height * 3/4f)
                    close()
                }
                drawPath(path = path, color = Color.Blue, style = Fill)
            }
        }
    }
}