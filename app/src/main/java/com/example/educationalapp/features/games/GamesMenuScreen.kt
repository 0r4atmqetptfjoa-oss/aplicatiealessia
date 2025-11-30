package com.example.educationalapp.features.games

import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.itemsIndexed
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.imageResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import androidx.navigation.compose.rememberNavController
import com.example.educationalapp.R
import com.example.educationalapp.Screen
import com.example.educationalapp.ui.components.SpriteAnimation

/**
 * Represents a simple data model for games displayed in the games menu. Each entry
 * has a user‑friendly name and a navigation route defined in [Screen].
 */
data class Game(val name: String, val route: String)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GamesMenuScreen(navController: NavController) {
    // Define the list of games to show in the menu.  This list has been expanded
    // to include new games such as sorting, block matching, hidden objects and
    // shadow matching.  If a route is empty the navigation is disabled.
    val games = remember {
        listOf(
            Game("Culori", Screen.ColorMatch.route),
            Game("Forme", Screen.ShapeMatch.route),
            Game("Alfabet", Screen.AlphabetQuiz.route),
            Game("Numere", Screen.MathGame.route),
            Game("Sortare", Screen.SortingGame.route),
            Game("Puzzle", Screen.Puzzle.route),
            Game("Memorie", Screen.MemoryGame.route),
            // Sequence memory game: repeat the colours in the shown order
            Game("Secvențe", Screen.SequenceMemoryGame.route),
            Game("Blocuri", Screen.BlocksGame.route),
            Game("Gătit", Screen.CookingGame.route),
            Game("Labirint", Screen.MazeGame.route),
            Game("Ascunse", Screen.HiddenObjectsGame.route),
            Game("Umbre", Screen.ShadowMatchGame.route),
            Game("Animale", Screen.AnimalSortingGame.route),
            Game("Instrumente", Screen.InstrumentsGame.route),
            // New coding game teaches sequencing and problem solving
            Game("Codare", Screen.CodingGame.route)
        )
    }

    // Sprite sheet used for game icons.  Each frame of the sheet is used as a
    // static icon for a game entry.
    val sheet: ImageBitmap = ImageBitmap.imageResource(id = R.drawable.jocuri_sheet)

    Box(modifier = Modifier.fillMaxSize()) {
        // Background image for the games menu
        Image(
            painter = painterResource(id = R.drawable.background_meniu_principal),
            contentDescription = null,
            modifier = Modifier.fillMaxSize(),
            contentScale = ContentScale.Crop
        )

        Scaffold(
            containerColor = Color.Transparent,
            topBar = {
                TopAppBar(
                    title = {
                        Text(
                            stringResource(id = R.string.main_menu_button_games),
                            style = MaterialTheme.typography.headlineSmall
                        )
                    },
                    navigationIcon = {
                        IconButton(onClick = { navController.popBackStack() }) {
                            Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                        }
                    },
                    colors = TopAppBarDefaults.topAppBarColors(
                        containerColor = Color.Transparent,
                        titleContentColor = Color.White,
                        navigationIconContentColor = Color.White
                    )
                )
            }
        ) { paddingValues ->
            LazyVerticalGrid(
                columns = GridCells.Adaptive(minSize = 112.dp),
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues),
                horizontalArrangement = Arrangement.spacedBy(16.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp),
                contentPadding = PaddingValues(start = 16.dp, end = 16.dp, top = 8.dp, bottom = 16.dp)
            ) {
                itemsIndexed(games) { index, game ->
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier.clickable(
                            interactionSource = remember { MutableInteractionSource() },
                            indication = null
                        ) {
                            if (game.route.isNotEmpty()) {
                                navController.navigate(game.route)
                            }
                        }
                    ) {
                        SpriteAnimation(
                            sheet = sheet,
                            frameCount = 24, // Use 24 frames consistent with main menu
                            columns = 5,
                            frameIndex = index % 24, // Use index modulo frame count to avoid overflow
                            modifier = Modifier.size(80.dp)
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        Text(
                            text = game.name,
                            color = Color.White,
                            textAlign = TextAlign.Center,
                            style = MaterialTheme.typography.bodyLarge
                        )
                    }
                }
            }
        }
    }
}

@Preview(showBackground = true, device = "spec:width=1280dp,height=800dp,dpi=240")
@Composable
fun GamesMenuScreenPreview() {
    GamesMenuScreen(rememberNavController())
}