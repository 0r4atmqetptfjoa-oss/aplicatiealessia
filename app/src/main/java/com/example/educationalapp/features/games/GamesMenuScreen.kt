package com.example.educationalapp.features.games

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import androidx.navigation.compose.rememberNavController
import com.example.educationalapp.Screen

@Composable
fun GamesMenuScreen(navController: NavController) {
    Box(modifier = Modifier.fillMaxSize().background(Color.Black)) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Button(onClick = { navController.navigate(Screen.ColorMatch.route) }) { Text("Culori") }
            Button(onClick = { navController.navigate(Screen.ShapeMatch.route) }) { Text("Forme") }
            Button(onClick = { navController.navigate(Screen.AlphabetQuiz.route) }) { Text("Alfabet") }
            Button(onClick = { navController.navigate(Screen.MathGame.route) }) { Text("Numere") }
            Button(onClick = { navController.navigate(Screen.CookingGame.route) }) { Text("Gătit") }
            Button(onClick = { navController.navigate(Screen.Puzzle.route) }) { Text("Puzzle") }
            Button(onClick = { navController.navigate(Screen.MemoryGame.route) }) { Text("Memorie") }
            Button(onClick = { /* TODO: Navigate to Hidden Objects game */ }) { Text("Obiecte ascunse") }
            Button(onClick = { /* TODO: Navigate to Shadow Matching game */ }) { Text("Potrivire umbre") }
            Button(onClick = { navController.navigate(Screen.AnimalSortingGame.route) }) { Text("Potrivire animale") }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun GamesMenuScreenPreview() {
    GamesMenuScreen(rememberNavController())
}
