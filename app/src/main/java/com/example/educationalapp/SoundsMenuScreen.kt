package com.example.educationalapp

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.ui.Modifier
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
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Meniu Sunete", modifier = Modifier.padding(bottom = 16.dp))
        categories.forEach { category ->
            Button(
                onClick = {
                    navController.navigate("sound_category/${category.routeParam}")
                },
                modifier = Modifier
                    .fillMaxSize()
                    .padding(vertical = 4.dp)
            ) {
                Text(text = category.displayName)
            }
        }
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }, modifier = Modifier.padding(top = 16.dp)) {
            Text(text = "Înapoi la Meniu Principal")
        }
    }
}