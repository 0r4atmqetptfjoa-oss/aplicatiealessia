package com.example.educationalapp

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * Displays a list of available stories.  Each entry navigates to the
 * interactive story book screen.  For simplicity this implementation uses
 * a single built‑in story; additional stories can be added by defining
 * separate routes or adding dynamic arguments and screens.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun StoriesMenuScreen(navController: NavController, starState: MutableState<Int>) {
    val stories = listOf(
        "Poveste Interactivă"
        // Additional titles can be added here
    )
    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.lumea_background),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
            Text(
                text = "Meniu Povești",
                style = MaterialTheme.typography.displayMedium,
                fontFamily = FontFamily.Cursive,
                modifier = Modifier.padding(bottom = 16.dp).align(Alignment.CenterHorizontally)
            )
            LazyColumn(modifier = Modifier.weight(1f)) {
                items(stories) { title ->
                    Card(
                        onClick = { navController.navigate(Screen.StoryBook.route) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 4.dp),
                        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(16.dp),
                            horizontalArrangement = Arrangement.Center,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(text = title, style = MaterialTheme.typography.titleLarge, fontFamily = FontFamily.Cursive)
                        }
                    }
                }
            }
        }
        IconButton(
            onClick = { navController.navigate(Screen.MainMenu.route) },
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(16.dp)
        ) {
            Image(
                imageVector = Icons.Default.Home,
                contentDescription = "Acasă",
                modifier = Modifier.size(40.dp)
            )
        }
    }
}