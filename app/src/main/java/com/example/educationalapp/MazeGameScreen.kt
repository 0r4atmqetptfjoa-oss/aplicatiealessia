package com.example.educationalapp

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

@Composable
fun MazeGameScreen(navController: NavController, starState: MutableState<Int>) {
    // 5x5 maze. 0 empty, 1 wall, 2 goal
    val maze = listOf(
        listOf(0, 0, 1, 0, 0),
        listOf(1, 0, 1, 0, 1),
        listOf(0, 0, 0, 0, 0),
        listOf(0, 1, 1, 1, 0),
        listOf(0, 0, 0, 2, 0)
    )
    var heroPosition by remember { mutableStateOf(Pair(0, 0)) }
    var feedback by remember { mutableStateOf("") }

    fun move(dx: Int, dy: Int) {
        val (x, y) = heroPosition
        val newX = x + dx
        val newY = y + dy
        if (newX in 0..4 && newY in 0..4 && maze[newX][newY] != 1) {
            heroPosition = Pair(newX, newY)
            if (maze[newX][newY] == 2) {
                feedback = "Ai găsit ieșirea!"
                starState.value += 3
            } else {
                feedback = ""
            }
        }
    }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp), horizontalAlignment = Alignment.CenterHorizontally) {
        Text(text = "Joc Labirint", modifier = Modifier.padding(bottom = 16.dp))
        // Draw grid
        for (i in 0 until 5) {
            Row {
                for (j in 0 until 5) {
                    val cell = maze[i][j]
                    val isHero = heroPosition.first == i && heroPosition.second == j
                    val color = when {
                        isHero -> Color.Magenta
                        cell == 1 -> Color.DarkGray
                        cell == 2 -> Color.Yellow
                        else -> Color(0xFFB2FF59)
                    }
                    Box(modifier = Modifier.size(40.dp).background(color).padding(2.dp)) {}
                }
            }
        }
        Text(text = feedback, modifier = Modifier.padding(top = 16.dp))
        Spacer(modifier = Modifier.height(16.dp))
        // Controls
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Button(onClick = { move(-1, 0) }) { Text("Sus") }
            }
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Button(onClick = { move(0, -1) }) { Text("Stânga") }
                Button(onClick = { move(1, 0) }) { Text("Jos") }
                Button(onClick = { move(0, 1) }) { Text("Dreapta") }
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { heroPosition = Pair(0, 0); feedback = "" }) {
            Text(text = "Repornește")
        }
        Spacer(modifier = Modifier.height(8.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}