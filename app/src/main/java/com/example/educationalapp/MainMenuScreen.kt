package com.example.educationalapp

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.*
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.graphics.BlendMode
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.scale
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.lerp
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import androidx.navigation.compose.currentBackStackEntryAsState
import com.example.educationalapp.designsystem.Spacing
import kotlinx.coroutines.delay

// Custom shimmer modifier
fun Modifier.shimmerEffect(durationMillis: Int = 2000): Modifier = composed {
    val infiniteTransition = rememberInfiniteTransition(label = "shimmer")

    val offset by infiniteTransition.animateFloat(
        initialValue = -2f,
        targetValue = 2f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "shimmer_offset"
    )

    drawWithCache {
        onDrawWithContent {
            drawContent()
            val shimmerBrush = Brush.linearGradient(
                colors = listOf(
                    Color.White.copy(alpha = 0.0f),
                    Color.White.copy(alpha = 0.8f),
                    Color.White.copy(alpha = 0.0f),
                ),
                start = androidx.compose.ui.geometry.Offset(size.width * (offset - 1), 0f),
                end = androidx.compose.ui.geometry.Offset(size.width * offset, size.height)
            )
            drawRect(
                brush = shimmerBrush,
                blendMode = BlendMode.SrcAtop
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainMenuScreen(
    navController: NavController,
    starCount: Int,
) {
    val animatedStars by animateIntAsState(targetValue = starCount, label = "animatedStars")

    // Title pulse animation
    val infiniteTransition = rememberInfiniteTransition(label = "titlePulse")
    val titleScale by infiniteTransition.animateFloat(
        initialValue = 1f,
        targetValue = 1.05f,
        animationSpec = infiniteRepeatable(
            animation = tween(2000, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ), label = "titleScale"
    )

    val modules = listOf(
        Triple(Screen.GamesMenu.route, R.drawable.ic_games, "Jocuri"),
        Triple(Screen.InstrumentsMenu.route, R.drawable.ic_instruments, "Instrumente"),
        Triple(Screen.SongsMenu.route, R.drawable.ic_songs, "Melodii"),
        Triple(Screen.SoundsMenu.route, R.drawable.ic_sounds, "Sunete"),
        Triple(Screen.StoriesMenu.route, R.drawable.ic_stories, "Povești"),
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
                .padding(vertical = Spacing.large),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Title
            Text(
                text = "LUMEA ALESSIEI",
                style = MaterialTheme.typography.displayLarge.copy(
                    fontFamily = FontFamily.Cursive,
                    fontSize = 52.sp,
                    color = Color(0xFFE1BEE7) // Pastel Lavender
                ),
                modifier = Modifier
                    .padding(top = Spacing.extraLarge)
                    .graphicsLayer {
                        scaleX = titleScale
                        scaleY = titleScale
                    }
                    .shimmerEffect(),
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(Spacing.extraLarge))

            // Modules
            AnimatedLazyRow(modules, navController)
        }

        // Top Right buttons (Upgrade and Stars)
        Row(
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(Spacing.large),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Image(imageVector = Icons.Default.Star, contentDescription = "Stele", modifier = Modifier.size(32.dp))
                Spacer(modifier = Modifier.width(Spacing.small))
                Text(text = "$animatedStars", style = MaterialTheme.typography.titleLarge)
            }
            Spacer(modifier = Modifier.width(Spacing.medium))
            IconButton(onClick = { navController.navigate(Screen.Paywall.route) }) {
                Image(
                    painter = painterResource(id = R.drawable.ic_upgrade),
                    contentDescription = "Upgrade",
                    modifier = Modifier.size(40.dp)
                )
            }
        }


        // Settings button
        IconButton(
            onClick = { navController.navigate(Screen.Settings.route) },
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(Spacing.large)
        ) {
            Image(
                painter = painterResource(id = R.drawable.ic_settings),
                contentDescription = "Setări",
                modifier = Modifier.size(40.dp)
            )
        }

        // Home button (conditionally displayed)
        val navBackStackEntry by navController.currentBackStackEntryAsState()
        val currentRoute = navBackStackEntry?.destination?.route
        if (currentRoute != Screen.MainMenu.route) {
            IconButton(
                onClick = { navController.navigate(Screen.MainMenu.route) },
                modifier = Modifier
                    .align(Alignment.TopStart)
                    .padding(Spacing.large)
            ) {
                Image(
                    imageVector = Icons.Default.Home,
                    contentDescription = "Acasă",
                    modifier = Modifier.size(40.dp)
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AnimatedLazyRow(modules: List<Triple<String, Int, String>>, navController: NavController) {
    var isVisible by remember { mutableStateOf(false) }
    LaunchedEffect(Unit) {
        isVisible = true
    }

    LazyRow(
        modifier = Modifier.fillMaxWidth(),
        contentPadding = PaddingValues(horizontal = Spacing.large),
        horizontalArrangement = Arrangement.spacedBy(Spacing.large),
        verticalAlignment = Alignment.CenterVertically
    ) {
        itemsIndexed(modules) { index, module ->
            val interactionSource = remember { MutableInteractionSource() }
            val isPressed by interactionSource.collectIsPressedAsState()
            val scale by animateFloatAsState(if (isPressed) 0.95f else 1f, label = "scale")

            var itemVisible by remember { mutableStateOf(false) }
            LaunchedEffect(Unit) {
                delay(index * 100L) // Staggered delay
                itemVisible = true
            }

            AnimatedVisibility(
                visible = itemVisible,
                enter = slideInVertically { it } + fadeIn(),
                exit = slideOutVertically() + fadeOut()
            ) {
                 Card(
                    onClick = { navController.navigate(module.first) },
                    modifier = Modifier
                        .size(130.dp, 110.dp)
                        .graphicsLayer { 
                            scaleX = scale
                            scaleY = scale
                        },
                    elevation = CardDefaults.cardElevation(defaultElevation = Spacing.medium),
                    interactionSource = interactionSource
                ) {
                    Column(
                        modifier = Modifier.fillMaxSize(),
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                        Image(
                            painter = painterResource(id = module.second),
                            contentDescription = null,
                            modifier = Modifier.size(52.dp)
                        )
                        Spacer(modifier = Modifier.height(Spacing.medium))
                        Text(text = module.third, fontFamily = FontFamily.Cursive, style = MaterialTheme.typography.labelLarge, textAlign = TextAlign.Center)
                    }
                }
            }
        }
    }
}
