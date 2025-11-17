package com.example.educationalapp

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * Lists all available mini‑games.  Games marked as free are always accessible,
 * while premium games require purchasing the full version.  When the user
 * attempts to launch a locked game without owning the full version, the
 * navigation is redirected to the paywall screen.
 */
data class GameItem(val name: String, val route: String, val isFree: Boolean)

@Composable
fun GamesMenuScreen(
    navController: NavController,
    starState: MutableState<Int>,
    hasFullVersion: MutableState<Boolean>
) {
    // Define the list of games and whether each is free
    val games = listOf(
        GameItem("Quiz Alfabet", Screen.AlphabetQuiz.route, true),
        GameItem("Quiz Numere", Screen.NumberQuiz.route, true),
        GameItem("Potrivire Culori", Screen.ColorMatch.route, true),
        GameItem("Potrivire Forme", Screen.ShapeMatch.route, true),
        GameItem("Puzzle Simplu", Screen.Puzzle.route, true),
        GameItem("Joc Memorie", Screen.MemoryGame.route, true),
        GameItem("Joc Sortare", Screen.SortingGame.route, true),
        GameItem("Joc Labirint", Screen.MazeGame.route, true),
        // Premium games
        GameItem("Quiz Matematic", Screen.MathQuiz.route, false),
        GameItem("Memorie Secvențe", Screen.SequenceMemory.route, false),
        GameItem("Carte Interactivă", Screen.StoryBook.route, false),
        GameItem("Desen și Colorează", Screen.Drawing.route, false),
        GameItem("Creează Avatar", Screen.AvatarCreator.route, false),
        GameItem("Album de Stickere", Screen.StickerBook.route, false),
        GameItem("Panou Sunete Animale", Screen.AnimalSoundBoard.route, false),
        GameItem("Joc Emoții", Screen.EmotionsGame.route, false),
        GameItem("Blocuri", Screen.BlockGame.route, false),
        GameItem("Gătit", Screen.CookingGame.route, false),
        GameItem("Obiecte ascunse", Screen.HiddenObjectsGame.route, false),
        GameItem("Joc Instrumente", Screen.InstrumentGuessGame.route, false),
        GameItem("Puzzle Jigsaw", Screen.JigsawPuzzle.route, false),
        GameItem("Sortarea Animalelor", Screen.AnimalSorting.route, false)
    )
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Meniu Jocuri", modifier = Modifier.padding(bottom = 16.dp))
        LazyColumn(modifier = Modifier.weight(1f)) {
            items(games) { game ->
                val unlocked = game.isFree || hasFullVersion.value
                Card(modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 4.dp)) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(12.dp),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text(text = game.name)
                        if (unlocked) {
                            Button(onClick = { navController.navigate(game.route) }) {
                                Text(text = "Joacă")
                            }
                        } else {
                            Button(onClick = { navController.navigate(Screen.Paywall.route) }) {
                                Text(text = "Deblochează")
                            }
                        }
                    }
                }
            }
        }
        Button(onClick = { navController.navigate(Screen.MainMenu.route) }, modifier = Modifier.padding(top = 16.dp)) {
            Text(text = "Înapoi la Meniu Principal")
        }
    }
}