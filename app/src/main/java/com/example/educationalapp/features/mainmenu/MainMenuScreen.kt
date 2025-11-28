package com.example.educationalapp.features.mainmenu

import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.annotation.DrawableRes
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
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
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.imageResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.constraintlayout.compose.ConstraintLayout
import androidx.navigation.NavController
import com.example.educationalapp.R
import com.example.educationalapp.Screen
import com.example.educationalapp.ui.components.SpriteAnimation

data class MainMenuModule(
    val route: String,
    @DrawableRes val sheetRes: Int,
    val title: String,
    val frameWidth: Int,
    val frameHeight: Int,
    val frameCount: Int,
    val fps: Int
)

@Composable
fun MainMenuScreen(
    navController: NavController,
    starCount: Int,
) {
    val animatedStars by animateFloatAsState(targetValue = starCount.toFloat(), label = "animatedStars")

    val modules = listOf(
        MainMenuModule(Screen.GamesMenu.route, R.drawable.jocuri_sheet, stringResource(id = R.string.main_menu_button_games), 512, 512, 24, 30),
        MainMenuModule(Screen.InstrumentsMenu.route, R.drawable.instrumente_sheet, stringResource(id = R.string.main_menu_button_instruments), 512, 512, 24, 30),
        MainMenuModule(Screen.SongsMenu.route, R.drawable.cantece_sheet, stringResource(id = R.string.main_menu_button_songs), 512, 512, 24, 30),
        MainMenuModule(Screen.SoundsMenu.route, R.drawable.sunete_sheet, stringResource(id = R.string.main_menu_button_sounds), 512, 512, 24, 30),
        MainMenuModule(Screen.StoriesMenu.route, R.drawable.povesti_sheet, stringResource(id = R.string.main_menu_button_stories), 512, 512, 24, 30),
    )

    Box(modifier = Modifier.fillMaxSize()) {
        Image(painter = painterResource(id = R.drawable.background_meniu_principal), contentDescription = null, contentScale = ContentScale.Crop, modifier = Modifier.fillMaxSize())

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
                    Text(text = "${animatedStars.toInt()}", style = MaterialTheme.typography.titleLarge.copy(color = Color.White))
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
            val titleSheet = loadResizedBitmap(
                res = LocalContext.current.resources,
                resId = R.drawable.titlu_sheet,
                reqWidth = 1280,
                reqHeight = 720
            )
            SpriteAnimation(
                modifier = Modifier.constrainAs(title) {
                    top.linkTo(topBar.bottom)
                    bottom.linkTo(bottomBar.top)
                    start.linkTo(parent.start)
                    end.linkTo(parent.end)
                }.height(180.dp).aspectRatio(1.77f),
                sheet = titleSheet,
                frameWidth = 1280,
                frameHeight = 720,
                frameCount = 60,
                fps = 30
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
    val buttonSheet = ImageBitmap.imageResource(id = module.sheetRes)

    Column(
        modifier = Modifier
            .weight(1f)
            .clickable(onClick = { navController.navigate(module.route) }, indication = null, interactionSource = interactionSource)
            .padding(vertical = 8.dp)
            .graphicsLayer { scaleX = scale; scaleY = scale },
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        SpriteAnimation(
            modifier = Modifier.size(48.dp),
            sheet = buttonSheet,
            frameWidth = module.frameWidth,
            frameHeight = module.frameHeight,
            frameCount = module.frameCount,
            fps = module.fps
        )
        Text(
            text = module.title,
            fontSize = 12.sp,
            textAlign = TextAlign.Center,
            fontFamily = FontFamily.Cursive,
            style = MaterialTheme.typography.bodyLarge.copy(color = Color.White)
        )
    }
}

fun loadResizedBitmap(res: Resources, resId: Int, reqWidth: Int, reqHeight: Int): ImageBitmap {
    val options = BitmapFactory.Options().apply {
        inJustDecodeBounds = true
    }
    BitmapFactory.decodeResource(res, resId, options)

    // Calculate inSampleSize
    options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight)

    // Decode bitmap with inSampleSize set
    options.inJustDecodeBounds = false
    // Enable mutable to allow hardware acceleration compatibility checks if needed
    options.inMutable = true
    
    val bitmap = BitmapFactory.decodeResource(res, resId, options)
    return bitmap.asImageBitmap()
}

fun calculateInSampleSize(options: BitmapFactory.Options, reqWidth: Int, reqHeight: Int): Int {
    val (height: Int, width: Int) = options.outHeight to options.outWidth
    var inSampleSize = 1

    if (height > reqHeight || width > reqWidth) {
        val halfHeight: Int = height / 2
        val halfWidth: Int = width / 2

        while ((halfHeight / inSampleSize) >= reqHeight && (halfWidth / inSampleSize) >= reqWidth) {
            inSampleSize *= 2
        }
    }
    return inSampleSize
}
