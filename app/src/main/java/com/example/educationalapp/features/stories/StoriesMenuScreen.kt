package com.example.educationalapp.features.stories

import androidx.compose.foundation.background
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
fun StoriesMenuScreen(navController: NavController) {
    Box(modifier = Modifier.fillMaxSize().background(Color.Black)) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text("Listă cu povești ilustrate", color = Color.White)
            Button(onClick = { navController.navigate(Screen.StoryBook.route) }) {
                Text("Mergi la cartea de povești")
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun StoriesMenuScreenPreview() {
    StoriesMenuScreen(rememberNavController())
}
