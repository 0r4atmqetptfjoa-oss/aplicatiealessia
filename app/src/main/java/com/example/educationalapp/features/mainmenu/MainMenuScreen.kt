package com.example.educationalapp.features.mainmenu

import android.content.res.Resources
import android.graphics.BitmapFactory
import androidx.annotation.DrawableRes
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.constraintlayout.compose.ConstraintLayout
import androidx.constraintlayout.compose.Dimension
import androidx.navigation.NavController
import coil.compose.AsyncImage
import com.example.educationalapp.R
import com.example.educationalapp.Screen
import com.example.educationalapp.ui.components.SpriteAnimation

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
    val context = LocalContext.current
    val resources = context.resources

    val modules = listOf(
        MainMenuModule(Screen.GamesMenu.route, R.drawable.jocuri_sheet, stringResource(id = R.string.main_menu_button_games), 5, 24, 24),
        MainMenuModule(Screen.InstrumentsMenu.route, R.drawable.instrumente_sheet, stringResource(id = R.string.main_menu_button_instruments), 5, 24, 24),
        MainMenuModule(Screen.SongsMenu.route, R.drawable.cantece_sheet, stringResource(id = R.string.main_menu_button_songs), 5, 24, 24),
        MainMenuModule(Screen.SoundsMenu.route, R.drawable.sunete_sheet, stringResource(id = R.string.main_menu_button_sounds), 5, 24, 24),
        MainMenuModule(Screen.StoriesMenu.route, R.drawable.povesti_sheet, stringResource(id = R.string.main_menu_button_stories), 5, 24, 24),
    )

    Box(modifier = Modifier.fillMaxSize()) {
        AsyncImage(
            model = R.drawable.background_meniu_principal,
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )

        ConstraintLayout(modifier = Modifier.fillMaxSize().safeDrawingPadding()) {
            val (starsRef, upgradeRef, titleRef, buttonsRef, settingsRef) = createRefs()
            val topBarrier = createBottomBarrier(starsRef, upgradeRef)

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
                    style = MaterialTheme.typography.titleLarge.copy(color = Color.White)
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

            val (titleSheet, titleModifier) = rememberBestTitleSheet()
            
            SpriteAnimation(
                sheet = titleSheet,
                frameCount = 60,
                columns = 8,
                fps = 30,
                loop = true,
                isPlaying = true,
                modifier = titleModifier.constrainAs(titleRef) {
                    top.linkTo(topBarrier, margin = 8.dp)
                    start.linkTo(parent.start)
                    end.linkTo(parent.end)
                }
            )

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
                    ModuleButton(module = module, navController = navController, resources = resources)
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
private fun RowScope.ModuleButton(module: MainMenuModule, navController: NavController, resources: Resources) {
    var isPlaying by remember { mutableStateOf(false) }
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()

    val buttonSheet = remember(module.sheetRes) { 
        loadOptimizedBitmap(resources, module.sheetRes)
    }

    val scale by animateFloatAsState(if (isPressed) 0.9f else 1f, label = "scale")

    Column(
        modifier = Modifier
            .weight(1f)
            .clickable(
                indication = null,
                interactionSource = interactionSource
            ) {
                if (!isPlaying) isPlaying = true
            }
            .graphicsLayer { 
                scaleX = scale
                scaleY = scale
            },
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
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
        
        Spacer(modifier = Modifier.height(4.dp))
        
        Text(
            text = module.title,
            fontSize = 12.sp,
            textAlign = TextAlign.Center,
            fontFamily = FontFamily.Cursive,
            style = MaterialTheme.typography.bodyLarge.copy(
                color = Color.White,
                shadow = androidx.compose.ui.graphics.Shadow(
                    color = Color.Black,
                    blurRadius = 4f
                )
            )
        )
    }
}

/**
 * Selects the best title sprite sheet based on the available screen width to ensure
 * the animation is always crisp and never upscaled.
 *
 * @return A pair containing the loaded [ImageBitmap] for the best sheet and a [Modifier]
 *         to apply to the SpriteAnimation, which sets the correct size and aspect ratio.
 */
@Composable
private fun rememberBestTitleSheet(): Pair<ImageBitmap, Modifier> {
    val context = LocalContext.current
    val resources = context.resources
    val density = LocalDensity.current
    val screenWidthDp = LocalConfiguration.current.screenWidthDp.dp

    // Use 70% of screen width as the target display size for the title.
    val targetWidthDp = screenWidthDp * 0.7f
    val targetWidthPx = with(density) { targetWidthDp.toPx() }

    // Frame pixel widths for each available sheet, from smallest to largest.
    val sheets = listOf(
        240 to R.drawable.titlu_sheet,
        360 to R.drawable.titlu_sheet_150p,
        480 to R.drawable.titlu_sheet_200p,
        720 to R.drawable.titlu_sheet_300p,
        960 to R.drawable.titlu_sheet_400p,
    )

    // Find the smallest sheet that can be downscaled to our target width.
    // i.e., the first sheet where its frame width is >= targetWidthPx.
    val bestSheetRes = sheets.firstOrNull { (frameWidth, _) ->
        frameWidth >= targetWidthPx
    }?.second ?: R.drawable.titlu_sheet_400p // Fallback to the largest sheet

    val titleSheet = remember(bestSheetRes) {
        loadOptimizedBitmap(resources, bestSheetRes)
    }

    // The natural aspect ratio of a frame is (1920/8) / (1080 / ceil(60/8)) = 240 / 135 = 16/9
    val frameAspectRatio = 16f / 9f
    val modifier = Modifier
        .fillMaxWidth(0.7f)
        .aspectRatio(frameAspectRatio)

    return titleSheet to modifier
}

fun loadOptimizedBitmap(res: Resources, resId: Int, maxTextureSize: Int = 4096): ImageBitmap {
    val options = BitmapFactory.Options().apply {
        inJustDecodeBounds = true
    }
    BitmapFactory.decodeResource(res, resId, options)

    var inSampleSize = 1
    val width = options.outWidth
    val height = options.outHeight

    // Reduce sample size until the image dimensions are below the max texture size.
    while (width / inSampleSize > maxTextureSize || height / inSampleSize > maxTextureSize) {
        inSampleSize *= 2
    }

    options.inJustDecodeBounds = false
    options.inSampleSize = inSampleSize

    val bitmap = BitmapFactory.decodeResource(res, resId, options)
    return bitmap.asImageBitmap()
}
