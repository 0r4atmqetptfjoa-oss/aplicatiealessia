package com.example.educationalapp

import androidx.compose.animation.core.*
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.* // Import all default icons
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.example.educationalapp.CompletionDialog
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

data class MemoryCard(val id: Int, val icon: ImageVector, var isFaceUp: Boolean = false, var isMatched: Boolean = false)

@Composable
fun MemoryGameScreen(navController: NavController, onGameWon: (stars: Int) -> Unit) {
    val icons = remember {
        listOf(
            Icons.Default.Favorite,
            Icons.Default.Star,
            Icons.Default.Info,
            Icons.Default.CheckCircle,
            Icons.Default.ThumbUp,
            Icons.Default.Build
        )
    }
    var cards by remember { mutableStateOf(createShuffledCards(icons)) }
    var selectedCards by remember { mutableStateOf<List<Int>>(emptyList()) }
    var moves by remember { mutableStateOf(0) }
    var isGameOver by remember { mutableStateOf(false) }
    val coroutineScope = rememberCoroutineScope()

    fun resetGame() {
        cards = createShuffledCards(icons)
        selectedCards = emptyList()
        moves = 0
        isGameOver = false
    }

    fun onCardClicked(cardId: Int) {
        if (selectedCards.size == 2 || cards.find { it.id == cardId }?.isFaceUp == true) return

        val newCards = cards.map {
            if (it.id == cardId) it.copy(isFaceUp = true) else it
        }
        cards = newCards
        selectedCards = selectedCards + cardId

        if (selectedCards.size == 2) {
            moves++
            val (firstCardId, secondCardId) = selectedCards
            val firstCard = cards.find { it.id == firstCardId }!!
            val secondCard = cards.find { it.id == secondCardId }!!

            if (firstCard.icon == secondCard.icon) {
                val matchedCards = cards.map {
                    if (it.id == firstCardId || it.id == secondCardId) it.copy(isMatched = true) else it
                }
                cards = matchedCards
                selectedCards = emptyList()

                if (cards.all { it.isMatched }) {
                    onGameWon(cards.size / 2) // Award stars
                    isGameOver = true
                }
            } else {
                coroutineScope.launch {
                    delay(1000)
                    val flippedBackCards = cards.map {
                        if (it.id == firstCardId || it.id == secondCardId) it.copy(isFaceUp = false) else it
                    }
                    cards = flippedBackCards
                    selectedCards = emptyList()
                }
            }
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        Image(painter = painterResource(id = R.drawable.generic_background_mainmenu_morning_f0001), contentDescription = null, contentScale = ContentScale.Crop, modifier = Modifier.fillMaxSize())

        Column(
            modifier = Modifier.fillMaxSize().padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            MemoryGameHeader(navController, moves)
            Spacer(modifier = Modifier.height(16.dp))
            LazyVerticalGrid(
                columns = GridCells.Fixed(3),
                verticalArrangement = Arrangement.spacedBy(8.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(cards) { card ->
                    MemoryCardView(card = card, onClick = { onCardClicked(card.id) })
                }
            }
        }

        if (isGameOver) {
            CompletionDialog(navController = navController, title = "Felicitări!", message = "Ai găsit toate perechile!", onRestart = ::resetGame)
        }
    }
}

@Composable
private fun MemoryGameHeader(navController: NavController, moves: Int) {
     Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        IconButton(onClick = { navController.navigate(Screen.MainMenu.route) }) {
            Icon(Icons.Default.Home, contentDescription = "Acasă", tint = Color.White, modifier = Modifier.size(40.dp))
        }
        Text(text = "Mutări: $moves", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Color.White)
    }
}

@Composable
private fun MemoryCardView(card: MemoryCard, onClick: () -> Unit) {
    val rotation by animateFloatAsState(
        targetValue = if (card.isFaceUp) 180f else 0f,
        animationSpec = tween(500),
        label = "rotation"
    )

    Card(
        modifier = Modifier
            .size(100.dp)
            .graphicsLayer {
                rotationY = rotation
                cameraDistance = 8 * density
            }
            .clickable(onClick = onClick, indication = null, interactionSource = remember { MutableInteractionSource() }),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(8.dp)
    ) {
        Box(modifier = Modifier.fillMaxSize()) {
            if (rotation < 90f) {
                // Card back
                Box(modifier = Modifier.fillMaxSize().background(MaterialTheme.colorScheme.primary))
            } else {
                // Card front
                Icon(
                    imageVector = card.icon,
                    contentDescription = null,
                    modifier = Modifier.fillMaxSize().padding(8.dp).graphicsLayer { rotationY = 180f }, // Counter-rotate the icon
                    tint = Color.White
                )
            }
        }
    }
}

private fun createShuffledCards(icons: List<ImageVector>): List<MemoryCard> {
    val gameIcons = (icons + icons).shuffled()
    return gameIcons.mapIndexed { index, icon -> MemoryCard(id = index, icon = icon) }
}
