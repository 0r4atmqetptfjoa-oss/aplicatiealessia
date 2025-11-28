package com.example.educationalapp

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel

class StoryBookViewModel : ViewModel() {

    val pages = listOf(
        "A fost odată ca niciodată un ursuleț curios care iubea să citească.",
        "Într-o zi, ursulețul a găsit o carte magică în bibliotecă.",
        "Cartea l-a purtat într-o aventură prin pădure, unde a întâlnit prieteni noi.",
        "La final, ursulețul a învățat că lectura îl poate duce oriunde dorește să meargă."
    )

    var pageIndex by mutableStateOf(0)
        private set

    var finished by mutableStateOf(false)
        private set

    fun onNextPage() {
        if (pageIndex < pages.size - 1) {
            pageIndex++
            if (pageIndex == pages.size - 1) {
                finished = true
            }
        }
    }

    fun onPreviousPage() {
        if (pageIndex > 0) {
            pageIndex--
        }
    }

    fun onFinished(onGameWon: () -> Unit) {
        if (finished) {
            onGameWon()
            finished = false
        }
    }
}