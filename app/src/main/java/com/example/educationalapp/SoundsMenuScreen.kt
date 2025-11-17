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
 * Menu listing the available sound categories.  Each category navigates to a
 * dedicated sound board showing multiple sounds.  Categories are inspired by
 * common toddler themes (birds, vehicles, farm, jungle and maritime).  If
 * additional categories are desired, simply add them to this list along with
 * their corresponding route parameter.  This screen awards no stars; stars
 * are earned within the category screens.
 */
data class SoundCategory(val displayName: String, val routeParam: String)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SoundsMenuScreen(navController: NavController, starState: MutableState<Int>) {
    // Define the sound categories and route parameters
    val categories = listOf(
        SoundCategory("Păsări", "birds"),
        SoundCategory("Vehicule", "vehicles"),
        SoundCategory("Fermă", "farm"),
        SoundCategory("Junglă", "jungle"),
        SoundCategory("Maritim", "maritime")
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
                text = "Meniu Sunete",
                style = MaterialTheme.typography.displayMedium,
                fontFamily = FontFamily.Cursive,
                modifier = Modifier.padding(bottom = 16.dp).align(Alignment.CenterHorizontally)
            )
            LazyColumn(modifier = Modifier.weight(1f)) {
                items(categories) { category ->
                    Card(
                        onClick = { navController.navigate("sound_category/${category.routeParam}") },
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
                            Text(text = category.displayName, style = MaterialTheme.typography.titleLarge, fontFamily = FontFamily.Cursive)
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