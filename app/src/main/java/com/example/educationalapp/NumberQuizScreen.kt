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
fun NumberQuizScreen(navController: NavController, starState: MutableState<Int>) {
    val numbers = remember { (0..20).toList() }
    var currentNumber by remember { mutableStateOf(0) }
    var options by remember { mutableStateOf(listOf<Int>()) }
    var feedback by remember { mutableStateOf("") }
    var score by remember { mutableStateOf(0) }

    fun newRound() {
        feedback = ""
        currentNumber = numbers.random()
        val set = mutableSetOf(currentNumber)
        val optionList = mutableListOf<Int>()
        val correctIndex = Random.nextInt(3)
        for (i in 0 until 3) {
            if (i == correctIndex) {
                optionList.add(currentNumber)
            } else {
                var num: Int
                do {
                    num = numbers.random()
                } while (num in set)
                set.add(num)
                optionList.add(num)
            }
        }
        options = optionList
    }

    LaunchedEffect(Unit) {
        newRound()
    }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Quiz Numere", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Găsește numărul: $currentNumber", modifier = Modifier.padding(bottom = 16.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            options.forEach { option ->
                Button(onClick = {
                    if (option == currentNumber) {
                        feedback = "Corect!";
                        score += 10; starState.value += 1
                    } else {
                        feedback = "Greșit!";
                        score = (score - 5).coerceAtLeast(0)
                    }
                    newRound()
                }, modifier = Modifier.weight(1f)) {
                    Text(text = option.toString())
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