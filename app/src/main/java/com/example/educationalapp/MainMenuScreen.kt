package com.example.educationalapp

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import androidx.compose.animation.core.animateColor
import androidx.compose.animation.core.animateIntAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.ui.Alignment

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
    val animatedStars by animateIntAsState(targetValue = starState.value)
    val profiles = listOf("Profil 1", "Profil 2", "Profil 3")
    val currentProfile = profiles.getOrElse(selectedProfileIndex.value) { profiles[0] }
    // Define pastel colours for animated title
    val titleColors = listOf(
        Color(0xFFFFC1E3), // pastel pink
        Color(0xFFB3E5FC), // pastel blue
        Color(0xFFFFF9C4), // pastel yellow
        Color(0xFFE1BEE7)  // pastel lavender
    )
    val infiniteTransition = rememberInfiniteTransition()
    val animatedColor by infiniteTransition.animateColor(
        initialValue = titleColors.first(),
        targetValue = titleColors.last(),
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 4000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        )
    )

    Box(modifier = Modifier.fillMaxSize()) {
        // Place a background image behind content
        Image(
            painter = painterResource(id = R.drawable.lumea_background),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 24.dp)
                .padding(top = 32.dp, bottom = 24.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // Display the app title vertically with animated colour
            val title = "LUMEA ALESSIEI"
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.padding(bottom = 16.dp)
            ) {
                title.forEach { ch ->
                    if (ch == ' ') {
                        Spacer(modifier = Modifier.height(12.dp))
                    } else {
                        Text(
                            text = ch.toString(),
                            style = MaterialTheme.typography.displayLarge.copy(
                                fontFamily = FontFamily.Cursive,
                                fontSize = 48.sp,
                                color = animatedColor
                            )
                        )
                    }
                }
            }
            // Show profile greeting and star count using cursive font
            Text(
                text = "Bine ai venit, $currentProfile!",
                style = MaterialTheme.typography.bodyLarge.copy(fontFamily = FontFamily.Cursive),
                modifier = Modifier.padding(bottom = 4.dp)
            )
            Text(
                text = "Stele: $animatedStars",
                style = MaterialTheme.typography.bodyLarge.copy(fontFamily = FontFamily.Cursive),
                modifier = Modifier.padding(bottom = 16.dp)
            )
            // Define common modifier for buttons
            val buttonModifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 4.dp)
            // Buttons for each main section with pastel colours and cursive labels
            Button(
                onClick = { navController.navigate(Screen.GamesMenu.route) },
                modifier = buttonModifier,
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFE8B5E3))
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(
                        painter = painterResource(id = R.drawable.ic_games),
                        contentDescription = null,
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(text = "Jocuri", fontFamily = FontFamily.Cursive)
                }
            }
            Button(
                onClick = { navController.navigate(Screen.InstrumentsMenu.route) },
                modifier = buttonModifier,
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFB0D9FF))
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(
                        painter = painterResource(id = R.drawable.ic_instruments),
                        contentDescription = null,
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(text = "Instrumente", fontFamily = FontFamily.Cursive)
                }
            }
            Button(
                onClick = { navController.navigate(Screen.SongsMenu.route) },
                modifier = buttonModifier,
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFFFE082))
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(
                        painter = painterResource(id = R.drawable.ic_songs),
                        contentDescription = null,
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(text = "Melodii", fontFamily = FontFamily.Cursive)
                }
            }
            Button(
                onClick = { navController.navigate(Screen.SoundsMenu.route) },
                modifier = buttonModifier,
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFC8E6C9))
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(
                        painter = painterResource(id = R.drawable.ic_sounds),
                        contentDescription = null,
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(text = "Sunete", fontFamily = FontFamily.Cursive)
                }
            }
            Button(
                onClick = { navController.navigate(Screen.StoriesMenu.route) },
                modifier = buttonModifier,
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFFFCDD2))
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(
                        painter = painterResource(id = R.drawable.ic_stories),
                        contentDescription = null,
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(text = "Povești", fontFamily = FontFamily.Cursive)
                }
            }
            Button(
                onClick = { navController.navigate(Screen.ProfilesMenu.route) },
                modifier = buttonModifier,
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFD1C4E9))
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(
                        painter = painterResource(id = R.drawable.ic_profiles),
                        contentDescription = null,
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(text = "Profiluri", fontFamily = FontFamily.Cursive)
                }
            }
            Button(
                onClick = { navController.navigate(Screen.ParentalGate.route) },
                modifier = buttonModifier,
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFFFE0B2))
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(
                        painter = painterResource(id = R.drawable.ic_parental),
                        contentDescription = null,
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(text = "Poarta Părinte", fontFamily = FontFamily.Cursive)
                }
            }
            Button(
                onClick = { navController.navigate(Screen.Paywall.route) },
                modifier = buttonModifier,
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFB2EBF2))
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(
                        painter = painterResource(id = R.drawable.ic_upgrade),
                        contentDescription = null,
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(text = "Upgrade", fontFamily = FontFamily.Cursive)
                }
            }
            Button(
                onClick = { navController.navigate(Screen.Settings.route) },
                modifier = buttonModifier,
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFFFCCBC))
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(
                        painter = painterResource(id = R.drawable.ic_settings),
                        contentDescription = null,
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(text = "Setări", fontFamily = FontFamily.Cursive)
                }
            }
        }
    }
}