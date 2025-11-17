package com.example.educationalapp

import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.navigation.NavController

fun lerp(start: Float, stop: Float, fraction: Float): Float {
    return start + fraction * (stop - start)
}

enum class AnswerState { UNANSWERED, CORRECT, INCORRECT }

data class NamedColor(val name: String, val color: Color)
data class NamedShape(val name: String, val icon: ImageVector, val color: Color)

@Composable
fun CompletionDialog(
    navController: NavController,
    title: String,
    message: String,
    onRestart: () -> Unit
) {
    AlertDialog(
        onDismissRequest = { navController.navigate(Screen.MainMenu.route) },
        title = { Text(text = title) },
        text = { Text(text = message) },
        confirmButton = {
            Button(onClick = onRestart) {
                Text("Joacă din nou")
            }
        },
        dismissButton = {
            Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
                Text("Meniu Principal")
            }
        }
    )
}
