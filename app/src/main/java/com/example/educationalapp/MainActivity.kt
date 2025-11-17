package com.example.educationalapp

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.navigation.compose.rememberNavController
import com.example.educationalapp.ui.theme.EducationalAppTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            EducationalAppTheme {
                // A surface container using the 'background' color from the theme
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
                    EducationalApp()
                }
            }
        }
    }
}

@Composable
fun EducationalApp() {
    // Global state accessible across screens
    val starState = rememberSaveable { mutableStateOf(0) }
    val hasFullVersion = rememberSaveable { mutableStateOf(false) }
    val soundEnabled = rememberSaveable { mutableStateOf(true) }
    val musicEnabled = rememberSaveable { mutableStateOf(true) }
    val hardModeEnabled = rememberSaveable { mutableStateOf(false) }
    val selectedProfileIndex = rememberSaveable { mutableStateOf(0) }
    val navController = rememberNavController()
    AppNavigation(
        navController = navController,
        starState = starState,
        hasFullVersion = hasFullVersion,
        soundEnabled = soundEnabled,
        musicEnabled = musicEnabled,
        hardModeEnabled = hardModeEnabled,
        selectedProfileIndex = selectedProfileIndex
    )
}