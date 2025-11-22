package com.example.educationalapp.features.mainmenu

import android.graphics.BitmapFactory
import androidx.annotation.DrawableRes
import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.constraintlayout.compose.ConstraintLayout
import androidx.navigation.NavController
import com.example.educationalapp.R
import com.example.educationalapp.Screen
import kotlin.math.roundToInt

data class MainMenuModule(
    val route: String,
    @DrawableRes val iconResNormal: Int,
    @DrawableRes val iconResPressed: Int,
    val title: String,
    val totalFrames: Int,
    val numCols: Int,
    val isAnimated: Boolean = false,
    val idleAnimSpeed: Int = 800, // Viteză animație idle FOARTE LENTĂ
    val pressedAnimSpeed: Int = 80   // Viteză animație la apăsare rapidă
)

@Composable
fun MainMenuScreen(
    navController: NavController,
    starCount: Int,
) {
    val animatedStars by animateIntAsState(targetValue = starCount, label = "animatedStars")

    val modules = listOf(
        MainMenuModule(Screen.GamesMenu.route, R.drawable.icon_button_jocuri_normal_f0001, R.drawable.icon_button_jocuri_pressed_f0001, stringResource(id = R.string.main_menu_button_games), 24, 4, isAnimated = true),
        MainMenuModule(Screen.InstrumentsMenu.route, R.drawable.icon_button_instrumente_normal_f0001, R.drawable.icon_button_instrumente_pressed_f0001, stringResource(id = R.string.main_menu_button_instruments), 24, 4, isAnimated = true),
        MainMenuModule(Screen.SongsMenu.route, R.drawable.icon_button_cantece_normal_f0001, R.drawable.icon_button_cantece_pressed_f0001, stringResource(id = R.string.main_menu_button_songs), 24, 4, isAnimated = true),
        MainMenuModule(Screen.SoundsMenu.route, R.drawable.icon_button_sunete_normal_f0001, R.drawable.icon_button_sunete_pressed_f0001, stringResource(id = R.string.main_menu_button_sounds), 24, 4, isAnimated = true),
        MainMenuModule(Screen.StoriesMenu.route, R.drawable.icon_button_povesti_normal_f0001, R.drawable.icon_button_povesti_pressed_f0001, stringResource(id = R.string.main_menu_button_stories), 24, 4, isAnimated = true),
    )

    Box(modifier = Modifier.fillMaxSize()) {
        AnimatedBackground()

        ConstraintLayout(modifier = Modifier.fillMaxSize().safeDrawingPadding()) {
            val (topBar, title, bottomBar) = createRefs()

            // Top Bar
            Row(
                modifier = Modifier.constrainAs(topBar) {
                    top.linkTo(parent.top)
                    start.linkTo(parent.start)
                    end.linkTo(parent.end)
                }.fillMaxWidth().padding(horizontal = 16.dp, vertical = 8.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(imageVector = Icons.Default.Star, contentDescription = stringResource(id = R.string.label_stars), modifier = Modifier.size(32.dp), colorFilter = ColorFilter.tint(Color.White))
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(text = "$animatedStars", style = MaterialTheme.typography.titleLarge.copy(color = Color.White))
                }
                IconButton(onClick = { navController.navigate(Screen.Paywall.route) }) {
                    Image(
                        imageVector = Icons.Default.Star, // Placeholder
                        contentDescription = stringResource(id = R.string.label_upgrade),
                        modifier = Modifier.size(40.dp),
                        colorFilter = ColorFilter.tint(Color.White)
                    )
                }
            }

            // Titlu
            SpriteSheetAnimation(
                modifier = Modifier.constrainAs(title) {
                    top.linkTo(topBar.bottom)
                    bottom.linkTo(bottomBar.top)
                    start.linkTo(parent.start)
                    end.linkTo(parent.end)
                }.height(180.dp) // Înălțime fixă, sigură
                 .aspectRatio(1.7f), // Raport de aspect pentru a păstra proporțiile
                drawableResId = R.drawable.title_titlu_f0001,
                totalFrames = 24,
                frameDurationMillis = 400, // Animație mult mai lentă
                numCols = 4
            )

            // Butoane de jos
            Row(
                modifier = Modifier.constrainAs(bottomBar) {
                    bottom.linkTo(parent.bottom, margin = 16.dp)
                    start.linkTo(parent.start)
                    end.linkTo(parent.end)
                }.fillMaxWidth(),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.Bottom
            ) {
                modules.forEach { module ->
                    ModuleButton(module = module, navController = navController)
                }
            }
        }
    }
}

@Composable
private fun RowScope.ModuleButton(module: MainMenuModule, navController: NavController) {
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    val scale by animateFloatAsState(if (isPressed) 0.95f else 1f, tween(100), label = "scale")

    Column(
        modifier = Modifier
            .weight(1f)
            .clickable(onClick = { navController.navigate(module.route) }, indication = null, interactionSource = interactionSource)
            .padding(vertical = 8.dp)
            .graphicsLayer { scaleX = scale; scaleY = scale },
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        SpriteSheetAnimation(
            modifier = Modifier.size(48.dp), // Dimensiune mult redusă
            drawableResId = if (isPressed) module.iconResPressed else module.iconResNormal,
            totalFrames = module.totalFrames,
            frameDurationMillis = if (isPressed) module.pressedAnimSpeed else module.idleAnimSpeed,
            numCols = module.numCols
        )
        Text(
            text = module.title,
            fontSize = 12.sp, // Font mai mic pentru a se potrivi
            textAlign = TextAlign.Center,
            fontFamily = FontFamily.Cursive,
            style = MaterialTheme.typography.bodyLarge.copy(color = Color.White)
        )
    }
}

@Composable
fun SpriteSheetAnimation(
    modifier: Modifier = Modifier,
    @DrawableRes drawableResId: Int,
    totalFrames: Int,
    frameDurationMillis: Int,
    numCols: Int
) {
    val context = LocalContext.current
    val imageBitmap = remember(drawableResId) {
        BitmapFactory.decodeResource(context.resources, drawableResId).asImageBitmap()
    }

    val numRows = (totalFrames + numCols - 1) / numCols
    val frameWidth = imageBitmap.width / numCols
    val frameHeight = imageBitmap.height / numRows

    val infiniteTransition = rememberInfiniteTransition(label = "sprite_animation_transition")
    val currentFrame by infiniteTransition.animateValue(
        initialValue = 0,
        targetValue = totalFrames,
        typeConverter = Int.VectorConverter,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = totalFrames * frameDurationMillis, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ), label = "sprite_frame"
    )

    Canvas(modifier = modifier) {
        val rowIndex = currentFrame / numCols
        val colIndex = currentFrame % numCols
        val srcOffsetX = colIndex * frameWidth
        val srcOffsetY = rowIndex * frameHeight
        drawImage(image = imageBitmap, srcOffset = IntOffset(srcOffsetX, srcOffsetY), srcSize = IntSize(frameWidth, frameHeight), dstSize = IntSize(size.width.roundToInt(), size.height.roundToInt()))
    }
}
