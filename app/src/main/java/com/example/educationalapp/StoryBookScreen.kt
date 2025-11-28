package com.example.educationalapp

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.animation.core.tween
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.with
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController

@OptIn(ExperimentalAnimationApi::class)
@Composable
fun StoryBookScreen(
    navController: NavController, 
    starState: MutableState<Int>,
    viewModel: StoryBookViewModel = hiltViewModel()
) {
    var pageIndex by remember { mutableStateOf(viewModel.pageIndex) }

    if (viewModel.finished) {
        LaunchedEffect(Unit) {
            viewModel.onFinished { starState.value += 3 }
        }
    }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Poveste Interactivă", modifier = Modifier.padding(bottom = 16.dp))
        Box(modifier = Modifier.weight(1f).padding(16.dp)) {
            AnimatedContent(targetState = pageIndex, transitionSpec = {
                slideInHorizontally(initialOffsetX = { it }, animationSpec = tween(400)) with
                    slideOutHorizontally(targetOffsetX = { -it }, animationSpec = tween(400))
            }, label = "") { targetPage ->
                Text(text = viewModel.pages[targetPage])
            }
        }
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Button(onClick = { viewModel.onPreviousPage() }) {
                Text(text = "Înapoi")
            }
            Button(onClick = { viewModel.onNextPage() }) {
                Text(text = if (pageIndex == viewModel.pages.size - 1) "Sfârșit" else "Următorul")
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Text(text = "Înapoi la Meniu")
        }
    }
}