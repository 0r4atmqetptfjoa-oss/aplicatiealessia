package com.example.educationalapp.features.mainmenu

import androidx.annotation.DrawableRes
import androidx.compose.animation.core.*
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.Shadow
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.constraintlayout.compose.ConstraintLayout
import androidx.constraintlayout.compose.Dimension
import androidx.navigation.NavController
import com.example.educationalapp.Screen
import com.example.educationalapp.ui.components.SpriteAnimation
import com.example.educationalapp.ui.components.rememberSheet
import com.example.educationalapp.ui.theme.KidFontFamily
import kotlinx.coroutines.delay

data class MainMenuModule(
    val route: String,
    @DrawableRes val sheetRes: Int,
    val title: String,
    val columns: Int,
    val frameCount: Int,
    val fps: Int
)

@Composable
fun MainMenuScreen(
    navController: NavController,
    starCount: Int,
) {
    val animatedStars by animateFloatAsState(targetValue = starCount.toFloat(), label = "animatedStars")

    val titleSheet = rememberSheet(com.example.educationalapp.R.drawable.titlu_sheet, maxTextureSize = 2048)
    val backgroundBitmap = rememberSheet(com.example.educationalapp.R.drawable.background_meniu_principal, maxTextureSize = 2048)

    val modules = listOf(
        MainMenuModule(Screen.GamesMenu.route, com.example.educationalapp.R.drawable.jocuri_sheet, stringResource(id = com.example.educationalapp.R.string.main_menu_button_games), 5, 25, 24),
        MainMenuModule(Screen.InstrumentsMenu.route, com.example.educationalapp.R.drawable.instrumente_sheet, stringResource(id = com.example.educationalapp.R.string.main_menu_button_instruments), 5, 25, 24),
        MainMenuModule(Screen.SongsMenu.route, com.example.educationalapp.R.drawable.cantece_sheet, stringResource(id = com.example.educationalapp.R.string.main_menu_button_songs), 5, 25, 24),
        MainMenuModule(Screen.SoundsMenu.route, com.example.educationalapp.R.drawable.sunete_sheet, stringResource(id = com.example.educationalapp.R.string.main_menu_button_sounds), 5, 25, 24),
        MainMenuModule(Screen.StoriesMenu.route, com.example.educationalapp.R.drawable.povesti_sheet, stringResource(id = com.example.educationalapp.R.string.main_menu_button_stories), 5, 25, 24),
    )

    var isTitlePlaying by remember { mutableStateOf(false) }
    var idleTrigger by remember { mutableStateOf(0) }

    LaunchedEffect(idleTrigger) {
        delay(5000) // 5-second idle delay
        isTitlePlaying = true
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .pointerInput(Unit) {
                detectTapGestures(onPress = {
                    isTitlePlaying = false
                    idleTrigger++
                })
            }
    ) {
        if (backgroundBitmap != null) {
            Image(
                bitmap = backgroundBitmap,
                contentDescription = null,
                contentScale = ContentScale.Crop,
                modifier = Modifier.fillMaxSize()
            )
        } else {
            Spacer(Modifier.fillMaxSize().graphicsLayer(alpha = 0f)) // Placeholder
        }

        ConstraintLayout(modifier = Modifier.fillMaxSize().safeDrawingPadding()) {
            val (starsRef, upgradeRef, titleRef, buttonsRef, settingsRef) = createRefs()

            Row(
                modifier = Modifier.constrainAs(starsRef) {
                    top.linkTo(parent.top, margin = 16.dp)
                    start.linkTo(parent.start, margin = 16.dp)
                },
                verticalAlignment = Alignment.CenterVertically
            ) {
                Image(
                    imageVector = Icons.Default.Star,
                    contentDescription = "Stele",
                    modifier = Modifier.size(32.dp),
                    colorFilter = ColorFilter.tint(Color.White)
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = "${animatedStars.toInt()}",
                    style = androidx.compose.material3.MaterialTheme.typography.titleLarge.copy(color = Color.White)
                )
            }

            IconButton(
                onClick = { navController.navigate(Screen.Paywall.route) },
                modifier = Modifier.constrainAs(upgradeRef) {
                    top.linkTo(parent.top, margin = 16.dp)
                    end.linkTo(parent.end, margin = 16.dp)
                }
            ) {
                Image(
                    imageVector = Icons.Default.Star,
                    contentDescription = "Cumpără",
                    modifier = Modifier.size(48.dp),
                    colorFilter = ColorFilter.tint(Color.White)
                )
            }

            if (titleSheet != null) {
                val infiniteTransition = rememberInfiniteTransition(label = "titleBounce")
                val bounceScale by infiniteTransition.animateFloat(
                    initialValue = 0.98f,
                    targetValue = 1.02f,
                    animationSpec = infiniteRepeatable(
                        animation = tween(durationMillis = 2200, easing = FastOutSlowInEasing),
                        repeatMode = RepeatMode.Reverse
                    ),
                    label = "titleBounceScale"
                )

                SpriteAnimation(
                    sheet = titleSheet,
                    frameCount = 60,
                    columns = 8,
                    fps = 24,
                    loop = true,
                    isPlaying = true,
                    modifier = Modifier
                        .constrainAs(titleRef) {
                            top.linkTo(parent.top, margin = 64.dp)
                            start.linkTo(parent.start)
                            end.linkTo(parent.end)
                        }
                        .fillMaxWidth(0.85f)
                        .aspectRatio(16f / 9f)
                        .graphicsLayer {
                            scaleX = bounceScale
                            scaleY = bounceScale
                        }
                )
            }

            Row(
                modifier = Modifier.constrainAs(buttonsRef) {
                    bottom.linkTo(parent.bottom, margin = 48.dp)
                    start.linkTo(parent.start)
                    end.linkTo(parent.end)
                    width = Dimension.fillToConstraints
                }.padding(horizontal = 16.dp),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.Bottom
            ) {
                modules.forEach { module ->
                    ModuleButton(module = module, navController = navController)
                }
            }

            IconButton(
                onClick = {
                     navController.navigate(Screen.SettingsScreen.route)
                },
                modifier = Modifier.constrainAs(settingsRef) {
                    bottom.linkTo(parent.bottom, margin = 16.dp)
                    end.linkTo(parent.end, margin = 16.dp)
                }
            ) {
                Image(
                    imageVector = Icons.Default.Settings,
                    contentDescription = "Setări",
                    modifier = Modifier.size(42.dp),
                    colorFilter = ColorFilter.tint(Color.White)
                )
            }
        }
    }
}

@Composable
private fun RowScope.ModuleButton(module: MainMenuModule, navController: NavController) {
    var isPlaying by remember { mutableStateOf(false) }
    val buttonSheet = rememberSheet(module.sheetRes, maxTextureSize = 2048)
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()

    val pressScale by animateFloatAsState(
        targetValue = if (isPressed || isPlaying) 1.0f else 0.95f,
        animationSpec = tween(durationMillis = 150, easing = FastOutSlowInEasing),
        label = "buttonPressScale"
    )

    Column(
        modifier = Modifier
            .weight(1f)
            .graphicsLayer {
                scaleX = pressScale
                scaleY = pressScale
            }
            .clickable(
                interactionSource = interactionSource,
                indication = null
            ) {
                if (!isPlaying) {
                    isPlaying = true
                }
            },
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        if (buttonSheet != null) {
            SpriteAnimation(
                modifier = Modifier.size(96.dp),
                sheet = buttonSheet,
                columns = module.columns,
                frameCount = module.frameCount,
                fps = module.fps,
                loop = false,
                isPlaying = isPlaying,
                onAnimationFinished = {
                    isPlaying = false
                    navController.navigate(module.route)
                }
            )
        } else {
            Spacer(Modifier.size(96.dp)) // Placeholder to maintain layout
        }

        Spacer(modifier = Modifier.height(4.dp))

        Text(
            text = module.title,
            style = TextStyle(
                fontFamily = KidFontFamily,
                fontSize = 16.sp,
                letterSpacing = 0.4.sp,
                color = Color.White,
                shadow = Shadow(
                    color = Color(0x80000000),
                    offset = Offset(1f, 1.5f),
                    blurRadius = 3f
                )
            )
        )
    }
}