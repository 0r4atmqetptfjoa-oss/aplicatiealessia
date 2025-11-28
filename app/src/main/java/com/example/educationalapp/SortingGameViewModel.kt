package com.example.educationalapp

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import kotlin.random.Random

class SortingGameViewModel : ViewModel() {

    var numbers by mutableStateOf(generateNumbers())
        private set

    var feedback by mutableStateOf("")
        private set

    var score by mutableStateOf(0)
        private set

    fun onNumberClick(number: Int, onGameWon: (stars: Int) -> Unit) {
        val min = numbers.minOrNull() ?: return
        if (number == min) {
            feedback = "Corect!"
            score += 10
            onGameWon(1)
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

    private fun generateNumbers(): List<Int> {
        return List(5) { Random.nextInt(1, 50) }
    }
}