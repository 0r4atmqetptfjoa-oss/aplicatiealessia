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
fun AlphabetQuizScreen(navController: NavController, starState: MutableState<Int>) {
    // Letters A-Z
    val letters = remember { ('A'..'Z').toList() }
    var currentLetter by remember { mutableStateOf('A') }
    var options by remember { mutableStateOf(listOf<Char>()) }
    var feedback by remember { mutableStateOf("") }
    var score by remember { mutableStateOf(0) }

    fun newRound() {
        feedback = ""
        currentLetter = letters.random()
        val set = mutableSetOf(currentLetter)
        val optionList = mutableListOf<Char>()
        val correctIndex = Random.nextInt(3)
        for (i in 0 until 3) {
            if (i == correctIndex) {
                optionList.add(currentLetter)
            } else {
                var letter: Char
                do {
                    letter = letters.random()
                } while (letter in set)
                set.add(letter)
                optionList.add(letter)
            }
        }
        options = optionList
    }

    LaunchedEffect(Unit) {
        newRound()
    }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Quiz Alfabet", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Găsește litera: $currentLetter", modifier = Modifier.padding(bottom = 16.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            options.forEach { option ->
                Button(onClick = {
                    if (option == currentLetter) {
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