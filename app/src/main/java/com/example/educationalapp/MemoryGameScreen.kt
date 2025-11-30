package com.example.educationalapp

import androidx.compose.animation.core.*
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
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.example.educationalapp.CompletionDialog
import androidx.compose.foundation.Image
import androidx.compose.ui.res.painterResource

@Composable
fun MemoryGameScreen(
    navController: NavController, 
    onGameWon: (stars: Int) -> Unit,
    viewModel: MemoryGameViewModel = hiltViewModel()
) {
    val cards by remember { mutableStateOf(viewModel.cards) }
    val moves by remember { mutableStateOf(viewModel.moves) }
    val isGameOver by remember { mutableStateOf(viewModel.isGameOver) }

    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.background_meniu_principal),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )

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
                    MemoryCardView(card = card, onClick = { viewModel.onCardClicked(card.id, onGameWon) })
                }
            }
        }

        if (isGameOver) {
            CompletionDialog(navController = navController, title = "Felicitări!", message = "Ai găsit toate perechile!", onRestart = viewModel::resetGame)
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