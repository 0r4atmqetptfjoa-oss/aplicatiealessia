package com.example.educationalapp

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Cake
import androidx.compose.material.icons.filled.Category
import androidx.compose.material.icons.filled.ColorLens
import androidx.compose.material.icons.filled.Extension
import androidx.compose.material.icons.filled.FormatListNumbered
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.Pets
import androidx.compose.material.icons.filled.Pin
import androidx.compose.material.icons.filled.Place
import androidx.compose.material.icons.filled.Sort
import androidx.compose.material.icons.filled.TextFields
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * A massively upgraded games menu screen designed for a premium experience.
 * The screen now displays games in a responsive grid with icons and subtle
 * animations. Locked games are overlaid with a semi‑transparent layer and a
 * lock icon prompting the user to upgrade. Micro‑interactions provide
 * immediate feedback when tapping on a card.
 */
@Composable
fun GamesMenuScreen(
    navController: NavController,
    starState: MutableState<Int>,
    hasFullVersion: MutableState<Boolean>
) {
    // Extended GameEntry with an icon to visually represent the game
    data class GameEntry(
        val title: String,
        val route: String,
        val isFree: Boolean,
        val icon: ImageVector
    )
    // Build a list of available games. Icons are from the Material Icons set.
    val games = listOf(
        GameEntry("Quiz Alfabet", Screen.AlphabetQuiz.route, true, Icons.Default.TextFields),
        GameEntry("Joc Matematică", Screen.MathGame.route, true, Icons.Default.FormatListNumbered),
        GameEntry("Potrivire Culori", Screen.ColorMatch.route, true, Icons.Default.ColorLens),
        GameEntry("Potrivire Forme", Screen.ShapeMatch.route, true, Icons.Default.Category),
        GameEntry("Puzzle Simplu", Screen.Puzzle.route, true, Icons.Default.Extension),
        GameEntry("Joc Memorie", Screen.MemoryGame.route, true, Icons.Default.Memory),
        GameEntry("Sortare Animale", Screen.AnimalSortingGame.route, true, Icons.Default.Pets),
        GameEntry("Joc de Gătit", Screen.CookingGame.route, false, Icons.Default.Cake),
        GameEntry("Joc Instrumente", Screen.InstrumentsGame.route, false, Icons.Default.Sort), // Placeholder icon
        GameEntry("Joc Blocuri", Screen.BlocksGame.route, false, Icons.Default.Place), // Placeholder icon
        GameEntry("Joc Labirint", Screen.MazeGame.route, false, Icons.Default.Pin) // Placeholder icon
    )
    Box(modifier = Modifier.fillMaxSize()) {
        // Background image covering the entire screen
        Image(
            painter = painterResource(id = R.drawable.lumea_background),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
            // Title of the screen
            Text(
                text = "Meniu Jocuri",
                style = MaterialTheme.typography.displayMedium,
                fontFamily = FontFamily.Cursive,
                modifier = Modifier
                    .padding(bottom = 16.dp)
                    .align(Alignment.CenterHorizontally)
            )
            // Grid displaying the games
            LazyVerticalGrid(
                columns = GridCells.Fixed(2),
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(12.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                items(games.size) { index ->
                    val game = games[index]
                    val unlocked = game.isFree || hasFullVersion.value
                    val interactionSource = remember { MutableInteractionSource() }
                    val isPressed by interactionSource.collectIsPressedAsState()
                    val scale by animateFloatAsState(
                        targetValue = if (isPressed) 0.95f else 1f,
                        animationSpec = tween(durationMillis = 150),
                        label = "pressScale"
                    )
                    var visible by remember { mutableStateOf(false) }
                    LaunchedEffect(Unit) { visible = true }
                    AnimatedVisibility(
                        visible = visible,
                        enter = slideInVertically(initialOffsetY = { it / 2 }) + fadeIn(),
                        exit = slideOutVertically() + fadeOut()
                    ) {
                        Card(
                            onClick = {
                                if (unlocked) {
                                    navController.navigate(game.route)
                                } else {
                                    navController.navigate(Screen.Paywall.route)
                                }
                            },
                            modifier = Modifier
                                .fillMaxWidth()
                                .aspectRatio(1f)
                                .graphicsLayer {
                                    scaleX = scale
                                    scaleY = scale
                                },
                            elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
                            interactionSource = interactionSource
                        ) {
                            Box(
                                modifier = Modifier
                                    .fillMaxSize()
                                    .padding(12.dp),
                                contentAlignment = Alignment.Center
                            ) {
                                Column(
                                    modifier = Modifier.fillMaxSize(),
                                    horizontalAlignment = Alignment.CenterHorizontally,
                                    verticalArrangement = Arrangement.Center
                                ) {
                                    Icon(
                                        imageVector = game.icon,
                                        contentDescription = null,
                                        modifier = Modifier.size(48.dp)
                                    )
                                    Spacer(modifier = Modifier.height(8.dp))
                                    Text(
                                        text = game.title,
                                        style = MaterialTheme.typography.titleMedium,
                                        fontFamily = FontFamily.Cursive,
                                        modifier = Modifier.align(Alignment.CenterHorizontally)
                                    )
                                }
                                if (!unlocked) {
                                    Box(
                                        modifier = Modifier
                                            .fillMaxSize()
                                            .background(Color.Black.copy(alpha = 0.5f)),
                                        contentAlignment = Alignment.Center
                                    ) {
                                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                            Icon(
                                                imageVector = Icons.Default.Lock,
                                                contentDescription = "Blocată",
                                                modifier = Modifier.size(32.dp)
                                            )
                                            Spacer(modifier = Modifier.height(4.dp))
                                            Text(
                                                text = "Deblochează",
                                                style = MaterialTheme.typography.labelLarge,
                                                color = Color.White
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        // Home/back button
        IconButton(
            onClick = { navController.navigate(Screen.MainMenu.route) },
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(16.dp)
        ) {
            Icon(
                imageVector = Icons.Default.Home,
                contentDescription = "Acasă",
                modifier = Modifier.size(40.dp)
            )
        }
    }
}