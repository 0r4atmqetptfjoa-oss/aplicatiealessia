package com.example.educationalapp

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import kotlin.random.Random

/**
 * A sorting game where animals must be categorized into their habitats
 * (fermă, junglă, marină).  The child chooses the correct category from
 * three options.  Points and stars are awarded for correct answers.  This
 * reinforces vocabulary and animal classification.
 */
data class AnimalCategory(val name: String, val category: String)

@Composable
fun AnimalSortingGameScreen(navController: NavController, starState: MutableState<Int>) {
    val animals = listOf(
        AnimalCategory("Vacă", "Fermă"),
        AnimalCategory("Cal", "Fermă"),
        AnimalCategory("Oaie", "Fermă"),
        AnimalCategory("Leu", "Junglă"),
        AnimalCategory("Maimuță", "Junglă"),
        AnimalCategory("Elefant", "Junglă"),
        AnimalCategory("Delfin", "Marină"),
        AnimalCategory("Pește", "Marină"),
        AnimalCategory("Rechin", "Marină")
    )
    val categories = listOf("Fermă", "Junglă", "Marină")
    var current by remember { mutableStateOf(animals[0]) }
    var feedback by remember { mutableStateOf("") }
    var score by remember { mutableStateOf(0) }
    fun newRound() { current = animals.random(); feedback = "" }
    LaunchedEffect(Unit) { newRound() }
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Sortarea Animalelor", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Unde locuiește: ${current.name}?", modifier = Modifier.padding(bottom = 16.dp))
        categories.forEach { cat ->
            Button(onClick = {
                if (cat == current.category) {
                    feedback = "Corect!";
                    score += 10; starState.value += 1
                } else {
                    feedback = "Greșit!";
                    score = (score - 5).coerceAtLeast(0)
                }
                newRound()
            }, modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
                Text(text = cat)
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