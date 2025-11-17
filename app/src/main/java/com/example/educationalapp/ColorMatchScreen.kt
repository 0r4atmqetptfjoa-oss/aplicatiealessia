package com.example.educationalapp

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import kotlin.random.Random

data class NamedColor(val name: String, val color: Color)

@Composable
fun ColorMatchScreen(navController: NavController, starState: MutableState<Int>) {
    val colors = remember {
        listOf(
            NamedColor("Roșu", Color(0xFFE74C3C)),
            NamedColor("Verde", Color(0xFF2ECC71)),
            NamedColor("Albastru", Color(0xFF3498DB)),
            NamedColor("Galben", Color(0xFFF1C40F)),
            NamedColor("Mov", Color(0xFF9B59B6)),
        )
    }
    var currentColor by remember { mutableStateOf(colors[0]) }
    var options by remember { mutableStateOf(listOf<NamedColor>()) }
    var feedback by remember { mutableStateOf("") }
    var score by remember { mutableStateOf(0) }

    fun newRound() {
        feedback = ""
        currentColor = colors.random()
        val set = mutableSetOf<NamedColor>()
        val optionList = mutableListOf<NamedColor>()
        val correctIndex = Random.nextInt(3)
        for (i in 0 until 3) {
            if (i == correctIndex) {
                optionList.add(currentColor)
            } else {
                var col: NamedColor
                do {
                    col = colors.random()
                } while (col == currentColor || col in set)
                set.add(col)
                optionList.add(col)
            }
        }
        options = optionList
    }

    LaunchedEffect(Unit) {
        newRound()
    }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Potrivire Culori", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Alege culoarea: ${currentColor.name}", modifier = Modifier.padding(bottom = 16.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            options.forEach { option ->
                Box(
                    modifier = Modifier
                        .size(80.dp)
                        .background(option.color)
                        .clickable {
                            if (option == currentColor) {
                                feedback = "Corect!";
                                score += 10; starState.value += 1
                            } else {
                                feedback = "Greșit!";
                                score = (score - 5).coerceAtLeast(0)
                            }
                            newRound()
                        }
                )
            }
        }
        Text(text = "Scor: $score", modifier = Modifier.padding(top = 16.dp))
        Text(text = feedback, modifier = Modifier.padding(top = 8.dp))
        Spacer(modifier = Modifier.height(16.dp))
        androidx.compose.material3.Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}