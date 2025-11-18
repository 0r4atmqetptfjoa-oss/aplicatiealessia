package com.example.educationalapp

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.hiltViewModel
import androidx.navigation.compose.rememberNavController
import com.example.educationalapp.ui.theme.EducationalAppTheme
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val viewModel: MainViewModel = hiltViewModel()
            EducationalAppTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    EducationalApp(viewModel)
                }
            }
        }
    }
}

@Composable
fun EducationalApp(viewModel: MainViewModel) {
    val navController = rememberNavController()
    val starCount by viewModel.starCount.collectAsState()
    val hasFullVersion by viewModel.hasFullVersion.collectAsState()
    val soundEnabled by viewModel.soundEnabled.collectAsState()
    val musicEnabled by viewModel.musicEnabled.collectAsState()
    val hardModeEnabled by viewModel.hardModeEnabled.collectAsState()

    // Bridge flows into MutableState for existing Navigation API
    val starState = remember { mutableStateOf(starCount) }
    starState.value = starCount
    val fullVersionState = remember { mutableStateOf(hasFullVersion) }
    fullVersionState.value = hasFullVersion
    val soundEnabledState = remember { mutableStateOf(soundEnabled) }
    soundEnabledState.value = soundEnabled
    val musicEnabledState = remember { mutableStateOf(musicEnabled) }
    musicEnabledState.value = musicEnabled
    val hardModeState = remember { mutableStateOf(hardModeEnabled) }
    hardModeState.value = hardModeEnabled

    AppNavigation(
        navController = navController,
        starState = starState,
        hasFullVersion = fullVersionState,
        soundEnabled = soundEnabledState,
        musicEnabled = musicEnabledState,
        hardModeEnabled = hardModeState
    )
}
