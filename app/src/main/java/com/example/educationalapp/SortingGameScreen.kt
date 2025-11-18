package com.example.educationalapp

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import kotlin.random.Random

@Composable
fun SortingGameScreen(navController: NavController, starState: MutableState<Int>) {
    var numbers by remember { mutableStateOf(generateNumbers()) }
    var feedback by remember { mutableStateOf("") }
    var score by remember { mutableStateOf(0) }

    fun handleClick(number: Int) {
        val min = numbers.minOrNull() ?: return
        if (number == min) {
            feedback = "Corect!"
            score += 10
            starState.value += 1
            numbers = numbers.filter { it != number }
            if (numbers.isEmpty()) {
                feedback = "Ai sortat toate numerele!"
                numbers = generateNumbers()
            }
        } else {
            feedback = "Greșit!"
            score = (score - 5).coerceAtLeast(0)
        }
    }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Joc Sortare", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Apasă numerele în ordine crescătoare", modifier = Modifier.padding(bottom = 16.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            numbers.forEach { number ->
                Button(onClick = { handleClick(number) }, modifier = Modifier.weight(1f)) {
                    Text(text = number.toString())
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

private fun generateNumbers(): List<Int> {
    return List(5) { Random.nextInt(1, 50) }
}