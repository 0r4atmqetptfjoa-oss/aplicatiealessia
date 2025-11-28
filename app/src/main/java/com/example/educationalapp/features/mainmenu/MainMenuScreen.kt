package com.example.educationalapp.features.mainmenu

import android.content.res.Resources
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

// Structura actualizată pentru a include coloanele
data class MainMenuModule(
    val route: String,
    @DrawableRes val sheetRes: Int,
    val title: String,
    val columns: Int, // Câte coloane are imaginea (ex: 5)
    val frameCount: Int,
    val fps: Int
)

@Composable
fun MainMenuScreen(
    navController: NavController,
    starCount: Int,
) {
    val animatedStars by animateFloatAsState(targetValue = starCount.toFloat(), label = "animatedStars")

    // Configurare module conform fișierelor JSON trimise (5 coloane, 24 cadre)
    val modules = listOf(
        MainMenuModule(Screen.GamesMenu.route, R.drawable.jocuri_sheet, stringResource(id = R.string.main_menu_button_games), 5, 24, 24),
        MainMenuModule(Screen.InstrumentsMenu.route, R.drawable.instrumente_sheet, stringResource(id = R.string.main_menu_button_instruments), 5, 24, 24),
        MainMenuModule(Screen.SongsMenu.route, R.drawable.cantece_sheet, stringResource(id = R.string.main_menu_button_songs), 5, 24, 24),
        MainMenuModule(Screen.SoundsMenu.route, R.drawable.sunete_sheet, stringResource(id = R.string.main_menu_button_sounds), 5, 24, 24),
        MainMenuModule(Screen.StoriesMenu.route, R.drawable.povesti_sheet, stringResource(id = R.string.main_menu_button_stories), 5, 24, 24),
    )

    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.background_meniu_principal),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )

        ConstraintLayout(modifier = Modifier.fillMaxSize().safeDrawingPadding()) {
            val (topBar, titleRef, bottomBar) = createRefs()

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
                        imageVector = Icons.Default.Star, // Placeholder Upgrade
                        contentDescription = stringResource(id = R.string.label_upgrade),
                        modifier = Modifier.size(40.dp),
                        colorFilter = ColorFilter.tint(Color.White)
                    )
                }
            }

            // --- TITLU ANIMAT ---
            // Încarcăm titlul optimizat pentru a nu depăși memoria, dar păstrând proporțiile
            val titleSheet = loadOptimizedBitmap(
                res = LocalContext.current.resources,
                resId = R.drawable.titlu_sheet
            )
            
            SpriteAnimation(
                modifier = Modifier.constrainAs(titleRef) {
                    top.linkTo(topBar.bottom, margin = 10.dp)
                    start.linkTo(parent.start)
                    end.linkTo(parent.end)
                    // Dimensiune titlu pe ecran
                }.fillMaxWidth(0.7f).aspectRatio(2f), // Ajustează aspect ratio după nevoie
                sheet = titleSheet,
                columns = 8,   // Titlul are 8 coloane conform JSON
                frameCount = 60,
                fps = 30
            )

            // --- BUTOANE MENIU ---
            // Aranjament pe două rânduri sau Grid
            Row(
                modifier = Modifier.constrainAs(bottomBar) {
                    bottom.linkTo(parent.bottom, margin = 32.dp)
                    start.linkTo(parent.start)
                    end.linkTo(parent.end)
                }.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.Bottom
            ) {
                // Afișăm doar primele 3 pentru spațiu, sau poți folosi un LazyVerticalGrid dacă sunt multe
                // Aici le punem într-un rând cu scroll orizontal sau wrap dacă e nevoie.
                // Pentru simplitate, afișăm toate într-un rând cu weight
                
                // NOTĂ: Dacă sunt 5 butoane mari, ar fi mai bine pe 2 rânduri, 
                // dar aici le punem într-un rând cu overlap sau scroll.
                // Varianta simplă: Row cu weight.
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
    
    // Efect de "bounce" la apăsare
    val scale by animateFloatAsState(if (isPressed) 0.85f else 1f, tween(100), label = "scale")
    
    val buttonSheet = ImageBitmap.imageResource(id = module.sheetRes)

    Column(
        modifier = Modifier
            .weight(1f)
            .clickable(
                onClick = { navController.navigate(module.route) },
                indication = null,
                interactionSource = interactionSource
            )
            .graphicsLayer { 
                scaleX = scale
                scaleY = scale
            },
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        // Buton MARE (110dp) și animat continuu
        SpriteAnimation(
            modifier = Modifier.size(110.dp), // Dimensiune mult mai mare
            sheet = buttonSheet,
            columns = module.columns,
            frameCount = module.frameCount,
            fps = module.fps,
            loop = true // Animație continuă
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = module.title,
            fontSize = 14.sp,
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
 * Încarcă un bitmap optimizat pentru Sprite Sheet.
 * Dacă imaginea e mai mare de 4096px (limita OpenGL), o micșorează proporțional.
 */
fun loadOptimizedBitmap(res: Resources, resId: Int): ImageBitmap {
    val options = BitmapFactory.Options().apply {
        inJustDecodeBounds = true
    }
    BitmapFactory.decodeResource(res, resId, options)

    // Limita sigură pentru texturi este 4096 sau 2048 pe telefoane vechi.
    // Titlul original are probabil ~10,000px lățime (8 x 1280). Trebuie redus.
    val maxTextureSize = 2048 // Folosim o valoare sigură
    var inSampleSize = 1

    if (options.outWidth > maxTextureSize || options.outHeight > maxTextureSize) {
        val halfWidth = options.outWidth / 2
        val halfHeight = options.outHeight / 2
        while ((halfWidth / inSampleSize) >= maxTextureSize && (halfHeight / inSampleSize) >= maxTextureSize) {
            inSampleSize *= 2
        }
    }

    options.inJustDecodeBounds = false
    options.inSampleSize = inSampleSize
    options.inMutable = true

    val bitmap = BitmapFactory.decodeResource(res, resId, options)
    return bitmap.asImageBitmap()
}
