package com.example.educationalapp

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.itemsIndexed
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import kotlin.random.Random

@Composable
fun PuzzleScreen(navController: NavController, starState: MutableState<Int>) {
    // Represent the puzzle as a list of 9 numbers 0..8; 0 is empty
    var tiles by remember { mutableStateOf(generatePuzzle()) }
    var moves by remember { mutableStateOf(0) }
    var feedback by remember { mutableStateOf("") }

    fun swap(index: Int) {
        val emptyIndex = tiles.indexOf(0)
        if (isAdjacent(index, emptyIndex)) {
            val list = tiles.toMutableList()
            list[emptyIndex] = tiles[index]
            list[index] = 0
            tiles = list
            moves++
            if (isSolved(list)) {
                feedback = "Puzzle complet!";
                starState.value += 2
            }
        }
    }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp), horizontalAlignment = Alignment.CenterHorizontally) {
        Text(text = "Puzzle", modifier = Modifier.padding(bottom = 16.dp))
        LazyVerticalGrid(columns = GridCells.Fixed(3), modifier = Modifier.size(240.dp)) {
            itemsIndexed(tiles) { index, tile ->
                Box(
                    modifier = Modifier
                        .size(80.dp)
                        .border(BorderStroke(1.dp, Color.Black))
                        .background(if (tile == 0) Color.LightGray else Color(0xFFB2DFDB))
                        .clickable { if (tile != 0) swap(index) },
                    contentAlignment = Alignment.Center
                ) {
                    if (tile != 0) Text(text = tile.toString())
                }
            }
        }
        Text(text = "Mutări: $moves", modifier = Modifier.padding(top = 16.dp))
        Text(text = feedback, modifier = Modifier.padding(top = 8.dp))
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { tiles = generatePuzzle(); moves = 0; feedback = "" }) {
            Text(text = "Repornește")
        }
        Spacer(modifier = Modifier.height(8.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}

private fun generatePuzzle(): List<Int> {
    val list = (0..8).toMutableList()
    list.shuffle(Random(System.currentTimeMillis()))
    return list
}

private fun isAdjacent(index: Int, emptyIndex: Int): Boolean {
    val row1 = index / 3
    val col1 = index % 3
    val row2 = emptyIndex / 3
    val col2 = emptyIndex % 3
    return (row1 == row2 && kotlin.math.abs(col1 - col2) == 1) || (col1 == col2 && kotlin.math.abs(row1 - row2) == 1)
}

private fun isSolved(list: List<Int>): Boolean {
    return list == listOf(1,2,3,4,5,6,7,8,0)
}