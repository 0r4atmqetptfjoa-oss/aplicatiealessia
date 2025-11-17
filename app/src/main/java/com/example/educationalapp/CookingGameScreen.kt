package com.example.educationalapp

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * A simple cooking game where children add ingredients to a pot by tapping
 * buttons.  When all ingredients have been added a star is awarded and a
 * new recipe begins.  This is a simplified drag‑and‑drop mechanic suitable
 * for young children.
 */
data class Ingredient(val name: String, val emoji: String)

@Composable
fun CookingGameScreen(navController: NavController, starState: MutableState<Int>) {
    val allIngredients = listOf(
        Ingredient("Ou", "🥚"),
        Ingredient("Făină", "🌾"),
        Ingredient("Lapte", "🥛"),
        Ingredient("Unt", "🧈"),
        Ingredient("Zahăr", "🍬")
    )
    var remaining by remember { mutableStateOf(allIngredients.toMutableList()) }
    var feedback by remember { mutableStateOf("") }
    fun addIngredient(ingredient: Ingredient) {
        remaining.remove(ingredient)
        if (remaining.isEmpty()) {
            feedback = "Felicitări! Ai gătit rețeta."
            starState.value += 3
            // reset for next round
            remaining = allIngredients.toMutableList()
        }
    }
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Joc de Gătit", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Adaugă ingredientele în oală", modifier = Modifier.padding(bottom = 16.dp))
        remaining.forEach { ingredient ->
            Button(
                onClick = { addIngredient(ingredient) },
                modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)
            ) {
                Text(text = "${ingredient.emoji} ${ingredient.name}")
            }
        }
        if (feedback.isNotEmpty()) {
            Text(text = feedback, modifier = Modifier.padding(top = 16.dp))
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}