package com.example.educationalapp

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateIntAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController

@Composable
fun MainMenuScreen(
    navController: NavController,
    starState: MutableState<Int>,
    hasFullVersion: MutableState<Boolean>,
    soundEnabled: MutableState<Boolean>,
    musicEnabled: MutableState<Boolean>,
    hardModeEnabled: MutableState<Boolean>,
    selectedProfileIndex: MutableState<Int>
) {
    val animatedStars by animateIntAsState(targetValue = starState.value, label = "")
    val profiles = listOf("Profil 1", "Profil 2", "Profil 3")
    val currentProfile = profiles.getOrElse(selectedProfileIndex.value) { profiles[0] }
    val titleColors = listOf(
        Color(0xFFFFC1E3), // pastel pink
        Color(0xFFB3E5FC), // pastel blue
        Color(0xFFFFF9C4), // pastel yellow
        Color(0xFFE1BEE7)  // pastel lavender
    )
    val infiniteTransition = rememberInfiniteTransition(label = "")
    val animatedColor by animateColorAsState(
        targetValue = titleColors.random(),
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 4000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ), label = ""
    )

    val modules = listOf(
        Triple(Screen.GamesMenu.route, R.drawable.ic_games, "Jocuri"),
        Triple(Screen.InstrumentsMenu.route, R.drawable.ic_instruments, "Instrumente"),
        Triple(Screen.SongsMenu.route, R.drawable.ic_songs, "Melodii"),
        Triple(Screen.SoundsMenu.route, R.drawable.ic_sounds, "Sunete"),
        Triple(Screen.StoriesMenu.route, R.drawable.ic_stories, "Povești"),
        Triple(Screen.ProfilesMenu.route, R.drawable.ic_profiles, "Profiluri"),
        Triple(Screen.ParentalGate.route, R.drawable.ic_parental, "Poarta Părinte"),
        Triple(Screen.Paywall.route, R.drawable.ic_upgrade, "Upgrade")
    )

    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.lumea_background),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Title
            Text(
                text = "LUMEA ALESSIEI",
                style = MaterialTheme.typography.displayLarge.copy(
                    fontFamily = FontFamily.Cursive,
                    fontSize = 48.sp,
                    color = animatedColor
                ),
                modifier = Modifier.padding(top = 32.dp)
            )

            Spacer(modifier = Modifier.height(32.dp))

            // Modules
            LazyRow(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                items(modules) { module ->
                    Button(
                        onClick = { navController.navigate(module.first) },
                        modifier = Modifier.size(120.dp, 100.dp)
                    ) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            Image(
                                painter = painterResource(id = module.second),
                                contentDescription = null,
                                modifier = Modifier.size(48.dp)
                            )
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(text = module.third, fontFamily = FontFamily.Cursive)
                        }
                    }
                }
            }
        }

        // Settings button
        Button(
            onClick = { navController.navigate(Screen.Settings.route) },
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(16.dp)
        ) {
            Image(
                painter = painterResource(id = R.drawable.ic_settings),
                contentDescription = "Setări",
                modifier = Modifier.size(32.dp)
            )
        }

        // Home button (conditionally displayed)
        val navBackStackEntry by navController.currentBackStackEntryAsState()
        val currentRoute = navBackStackEntry?.destination?.route
        if (currentRoute != Screen.MainMenu.route) {
            Button(
                onClick = { navController.navigate(Screen.MainMenu.route) },
                modifier = Modifier
                    .align(Alignment.TopStart)
                    .padding(16.dp)
            ) {
                Image(
                    painter = painterResource(id = R.drawable.ic_home),
                    contentDescription = "Acasă",
                    modifier = Modifier.size(32.dp)
                )
            }
        }
    }
}