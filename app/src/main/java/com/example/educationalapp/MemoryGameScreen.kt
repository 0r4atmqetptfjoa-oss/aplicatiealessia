package com.example.educationalapp

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.itemsIndexed
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import kotlinx.coroutines.delay
import kotlin.random.Random

data class MemoryCard(val id: Int, val icon: String, var isMatched: Boolean = false, var isFaceUp: Boolean = false)

@Composable
fun MemoryGameScreen(navController: NavController, starState: MutableState<Int>) {
    val icons = listOf("🍎", "🍌", "🍇", "🍓", "🍍", "🥕", "🍒", "🍉")
    var cards by remember { mutableStateOf(listOf<MemoryCard>()) }
    var moves by remember { mutableStateOf(0) }
    var firstIndex by remember { mutableStateOf<Int?>(null) }
    var secondIndex by remember { mutableStateOf<Int?>(null) }
    var lockBoard by remember { mutableStateOf(false) }
    var matchedPairs by remember { mutableStateOf(0) }

    fun resetGame() {
        val selectedIcons = icons.shuffled().take(6)
        val pairCards = (selectedIcons + selectedIcons).mapIndexed { index, icon -> MemoryCard(id = index, icon = icon) }
        cards = pairCards.shuffled(Random(System.currentTimeMillis()))
        moves = 0
        firstIndex = null
        secondIndex = null
        lockBoard = false
        matchedPairs = 0
    }

    LaunchedEffect(Unit) {
        resetGame()
    }

    fun flipCard(index: Int) {
        if (lockBoard) return
        val card = cards[index]
        if (card.isFaceUp || card.isMatched) return
        val list = cards.toMutableList()
        list[index] = card.copy(isFaceUp = true)
        cards = list

        if (firstIndex == null) {
            firstIndex = index
        } else if (secondIndex == null) {
            secondIndex = index
            moves++
            lockBoard = true
        }
    }

    LaunchedEffect(secondIndex) {
        if (firstIndex != null && secondIndex != null) {
            delay(600)
            val fIndex = firstIndex!!
            val sIndex = secondIndex!!
            val cardA = cards[fIndex]
            val cardB = cards[sIndex]
            if (cardA.icon == cardB.icon) {
                val newList = cards.toMutableList()
                newList[fIndex] = cardA.copy(isMatched = true)
                newList[sIndex] = cardB.copy(isMatched = true)
                cards = newList
                matchedPairs++
                starState.value += 1
            } else {
                val newList = cards.toMutableList()
                newList[fIndex] = cardA.copy(isFaceUp = false)
                newList[sIndex] = cardB.copy(isFaceUp = false)
                cards = newList
            }
            firstIndex = null
            secondIndex = null
            lockBoard = false
        }
    }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp), horizontalAlignment = Alignment.CenterHorizontally) {
        Text(text = "Joc de Memorie", modifier = Modifier.padding(bottom = 16.dp))
        LazyVerticalGrid(columns = GridCells.Fixed(3), modifier = Modifier.size(240.dp)) {
            itemsIndexed(cards) { index, card ->
                val scale by animateFloatAsState(
                    targetValue = if (card.isFaceUp || card.isMatched) 1.1f else 1f, label = ""
                )
                Box(
                    modifier = Modifier
                        .size(80.dp)
                        .graphicsLayer {
                            scaleX = scale
                            scaleY = scale
                        }
                        .background(
                            when {
                                card.isMatched -> Color(0xFF00B894)
                                card.isFaceUp -> Color(0xFFFFEAA7)
                                else -> Color(0xFF74B9FF)
                            }
                        )
                        .clickable { flipCard(index) },
                    contentAlignment = Alignment.Center
                ) {
                    if (card.isFaceUp || card.isMatched) Text(text = card.icon)
                }
            }
        }
        Text(text = "Mutări: $moves", modifier = Modifier.padding(top = 16.dp))
        if (matchedPairs == cards.size / 2 && cards.isNotEmpty()) {
            Text(text = "Felicitări! Ai găsit toate perechile.", modifier = Modifier.padding(top = 8.dp))
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { resetGame() }) {
            Text(text = "Repornește")
        }
        Spacer(modifier = Modifier.height(8.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}