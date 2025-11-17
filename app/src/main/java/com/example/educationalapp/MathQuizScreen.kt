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
fun MathQuizScreen(navController: NavController, starState: MutableState<Int>) {
    var question by remember { mutableStateOf("1 + 1") }
    var answer by remember { mutableStateOf(2) }
    var options by remember { mutableStateOf(listOf<Int>()) }
    var feedback by remember { mutableStateOf("") }
    var score by remember { mutableStateOf(0) }

    fun generateQuestion() {
        feedback = ""
        // Random arithmetic operation between 1 and 10
        val a = Random.nextInt(1, 10)
        val b = Random.nextInt(1, 10)
        when (Random.nextInt(3)) {
            0 -> { question = "$a + $b"; answer = a + b }
            1 -> { question = "$a - $b"; answer = a - b }
            else -> { question = "$a × $b"; answer = a * b }
        }
        // Generate options
        val set = mutableSetOf(answer)
        val optionList = mutableListOf<Int>()
        val correctIndex = Random.nextInt(3)
        for (i in 0 until 3) {
            if (i == correctIndex) {
                optionList.add(answer)
            } else {
                var opt: Int
                do {
                    opt = answer + Random.nextInt(-5, 6)
                } while (opt in set)
                set.add(opt)
                optionList.add(opt)
            }
        }
        options = optionList
    }

    LaunchedEffect(Unit) { generateQuestion() }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Quiz Matematic", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Rezolvă: $question", modifier = Modifier.padding(bottom = 16.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            options.forEach { opt ->
                Button(onClick = {
                    if (opt == answer) {
                        feedback = "Corect!";
                        score += 10; starState.value += 1
                    } else {
                        feedback = "Greșit!";
                        score = (score - 5).coerceAtLeast(0)
                    }
                    generateQuestion()
                }, modifier = Modifier.weight(1f)) {
                    Text(text = opt.toString())
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