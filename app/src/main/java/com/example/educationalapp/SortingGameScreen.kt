package com.example.educationalapp

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController

@Composable
fun SortingGameScreen(
    navController: NavController, 
    starState: MutableState<Int>,
    viewModel: SortingGameViewModel = hiltViewModel()
) {
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Joc Sortare", modifier = Modifier.padding(bottom = 16.dp))
        Text(text = "Apasă numerele în ordine crescătoare", modifier = Modifier.padding(bottom = 16.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            viewModel.numbers.forEach { number ->
                Button(onClick = { viewModel.onNumberClick(number) { starState.value++ } }, modifier = Modifier.weight(1f)) {
                    Text(text = number.toString())
                }
            }
        }
        Text(text = "Scor: ${viewModel.score}", modifier = Modifier.padding(top = 16.dp))
        Text(text = viewModel.feedback, modifier = Modifier.padding(top = 8.dp))
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}