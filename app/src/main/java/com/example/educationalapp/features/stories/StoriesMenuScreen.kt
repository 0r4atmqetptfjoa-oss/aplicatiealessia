package com.example.educationalapp.features.stories

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
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import androidx.navigation.compose.rememberNavController
import coil.compose.AsyncImage
import com.example.educationalapp.R
import com.example.educationalapp.Screen
import com.example.educationalapp.features.mainmenu.loadOptimizedBitmap
import com.example.educationalapp.ui.components.SpriteAnimation

data class Story(val name: String, val route: String)

@Composable
fun StoriesMenuScreen(navController: NavController) {
    val context = LocalContext.current
    val resources = context.resources

    val stories = remember {
        listOf(
            Story("Povestea 1", Screen.StoryBook.route), // TODO: Update with specific story route
            Story("Povestea 2", ""), // TODO: Add route
            Story("Povestea 3", ""), // TODO: Add route
            Story("Povestea 4", ""), // TODO: Add route
        )
    }

    val sheet = remember {
        loadOptimizedBitmap(resources, R.drawable.povesti_sheet)
    }

    Box(modifier = Modifier.fillMaxSize()) {
        AsyncImage(
            model = R.drawable.background_meniu_principal,
            contentDescription = null,
            modifier = Modifier.fillMaxSize(),
            contentScale = ContentScale.Crop
        )

        Scaffold(
            containerColor = Color.Transparent,
            topBar = {
                TopAppBar(
                    title = { Text(stringResource(id = R.string.main_menu_button_stories)) },
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
                modifier = Modifier.fillMaxSize().padding(paddingValues).padding(16.dp),
                horizontalArrangement = Arrangement.spacedBy(16.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp),
                contentPadding = PaddingValues(16.dp)
            ) {
                itemsIndexed(stories) { index, story ->
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier.clickable(
                            interactionSource = remember { MutableInteractionSource() },
                            indication = null
                        ) {
                            if (story.route.isNotEmpty()) {
                                navController.navigate(story.route)
                            }
                        }
                    ) {
                        SpriteAnimation(
                            sheet = sheet,
                            frameCount = 24, // Assuming 24 frames from MainMenuScreen
                            columns = 5,     // Assuming 5 columns from MainMenuScreen
                            frameIndex = index, // Use index to show a static frame
                            modifier = Modifier.size(96.dp)
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        Text(
                            text = story.name,
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
fun StoriesMenuScreenPreview() {
    StoriesMenuScreen(rememberNavController())
}
