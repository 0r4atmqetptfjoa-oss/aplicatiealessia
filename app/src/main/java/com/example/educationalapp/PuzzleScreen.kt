package com.example.educationalapp

import androidx.compose.animation.core.animateDpAsState
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.random.Random

@Composable
fun PuzzleScreen(navController: NavController, onGameWon: (stars: Int) -> Unit) {
    var tiles by remember { mutableStateOf(generateSolvablePuzzle()) }
    var moves by remember { mutableStateOf(0) }
    var isSolved by remember { mutableStateOf(false) }
    val coroutineScope = rememberCoroutineScope()

    fun onTileClick(index: Int) {
        if (isSolved) return

        val emptyIndex = tiles.indexOf(0)
        if (isAdjacent(index, emptyIndex)) {
            val newTiles = tiles.toMutableList()
            newTiles[emptyIndex] = tiles[index]
            newTiles[index] = 0
            tiles = newTiles
            moves++

            if (checkIfSolved(newTiles)) {
                isSolved = true
                onGameWon(5) // Award stars for solving
                coroutineScope.launch {
                    delay(2000) // Show solved state before dialog
                }
            }
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.lumea_background),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )

        Column(
            modifier = Modifier.fillMaxSize().padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            PuzzleHeader(navController, moves)

            PuzzleGrid(tiles = tiles, onTileClick = ::onTileClick)

            Button(onClick = {
                tiles = generateSolvablePuzzle()
                moves = 0
                isSolved = false
            }) {
                Text("Repornește")
            }
        }

        if (isSolved) {
            CompletionDialog(navController = navController, title = "Felicitări!", message = "Ai rezolvat puzzle-ul!", onRestart = {
                tiles = generateSolvablePuzzle()
                moves = 0
                isSolved = false
            })
        }
    }
}

@Composable
private fun PuzzleHeader(navController: NavController, moves: Int) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        IconButton(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Icon(Icons.Default.Home, contentDescription = "Acasă", tint = Color.White, modifier = Modifier.size(40.dp))
        }
        Text(text = "Mutări: $moves", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Color.White)
    }
}

@Composable
private fun PuzzleGrid(tiles: List<Int>, onTileClick: (Int) -> Unit) {
    val gridSize = 3
    Box(modifier = Modifier.size(300.dp)) {
        for (i in 0 until gridSize * gridSize) {
            val row = i / gridSize
            val col = i % gridSize
            val tileValue = tiles.indexOf(i + 1)
            val animatedOffset by animateDpAsState(targetValue = 0.dp, label = "")

            if (tileValue != -1) { // Only draw numbered tiles
                 Box(
                    modifier = Modifier
                        .offset((col * 100).dp, (row * 100).dp)
                        .size(100.dp)
                        .padding(4.dp)
                        .shadow(4.dp, RoundedCornerShape(8.dp))
                        .background(Color(0xFF80CBC4), RoundedCornerShape(8.dp))
                        .clickable { onTileClick(tiles.indexOf(i + 1)) },
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = (i + 1).toString(),
                        fontSize = 32.sp, 
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    )
                }
            }
        }
    }
}

private fun generateSolvablePuzzle(): List<Int> {
    var list: List<Int>
    do {
        list = (0..8).shuffled(Random(System.currentTimeMillis()))
    } while (!isSolvable(list))
    return list
}

private fun isSolvable(puzzle: List<Int>): Boolean {
    val puzzleWithoutZero = puzzle.filter { it != 0 }
    var inversions = 0
    for (i in 0 until puzzleWithoutZero.size) {
        for (j in i + 1 until puzzleWithoutZero.size) {
            if (puzzleWithoutZero[i] > puzzleWithoutZero[j]) {
                inversions++
            }
        }
    }
    return inversions % 2 == 0
}

private fun isAdjacent(index1: Int, index2: Int): Boolean {
    val r1 = index1 / 3
    val c1 = index1 % 3
    val r2 = index2 / 3
    val c2 = index2 % 3
    return (r1 == r2 && kotlin.math.abs(c1 - c2) == 1) || (c1 == c2 && kotlin.math.abs(r1 - r2) == 1)
}

private fun checkIfSolved(tiles: List<Int>): Boolean {
    return tiles == listOf(1, 2, 3, 4, 5, 6, 7, 8, 0)
}
