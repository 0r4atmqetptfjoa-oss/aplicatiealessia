package com.example.educationalapp

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.navigation.compose.rememberNavController
import com.example.educationalapp.ui.theme.EducationalAppTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            EducationalAppTheme {
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
                    EducationalApp()
                }
            }
        }
    }
}

@Composable
fun EducationalApp() {
    val starState = remember { mutableStateOf(0) }
    val hasFullVersion = remember { mutableStateOf(false) }
    val soundEnabled = remember { mutableStateOf(true) }
    val musicEnabled = remember { mutableStateOf(true) }
    val hardModeEnabled = remember { mutableStateOf(false) }
    val navController = rememberNavController()
    AppNavigation(
        navController = navController,
        starState = starState,
        hasFullVersion = hasFullVersion,
        soundEnabled = soundEnabled,
        musicEnabled = musicEnabled,
        hardModeEnabled = hardModeEnabled
    )
}