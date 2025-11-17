package com.example.educationalapp

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.animation.with
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

@OptIn(ExperimentalAnimationApi::class)
@Composable
fun StoryBookScreen(navController: NavController, starState: MutableState<Int>) {
    val pages = listOf(
        "A fost odată ca niciodată un ursuleț curios care iubea să citească.",
        "Într-o zi, ursulețul a găsit o carte magică în bibliotecă.",
        "Cartea l-a purtat într-o aventură prin pădure, unde a întâlnit prieteni noi.",
        "La final, ursulețul a învățat că lectura îl poate duce oriunde dorește să meargă."
    )
    var pageIndex by remember { mutableStateOf(0) }
    var finished by remember { mutableStateOf(false) }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Poveste Interactivă", modifier = Modifier.padding(bottom = 16.dp))
        Box(modifier = Modifier.weight(1f).padding(16.dp)) {
            AnimatedContent(targetState = pageIndex, transitionSpec = {
                // Slide animation for page change
                tween(durationMillis = 400) with tween(durationMillis = 400)
            }) { targetPage ->
                Text(text = pages[targetPage])
            }
        }
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Button(onClick = { if (pageIndex > 0) pageIndex-- }) {
                Text(text = "Înapoi")
            }
            Button(onClick = {
                if (pageIndex < pages.size - 1) {
                    pageIndex++
                    if (pageIndex == pages.size - 1) {
                        finished = true
                    }
                }
            }) {
                Text(text = if (pageIndex == pages.size - 1) "Sfârșit" else "Următorul")
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
        if (finished) {
            // Award star once when finishing story
            LaunchedEffect(Unit) {
                starState.value += 3
                finished = false
            }
        }
    }
}