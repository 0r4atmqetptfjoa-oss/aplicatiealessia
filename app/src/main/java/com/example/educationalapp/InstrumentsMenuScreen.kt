package com.example.educationalapp

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

/**
 * Lists available instruments.  Each button navigates to a specific instrument
 * screen.  The xylophone uses the existing InstrumentScreen from the original
 * app; piano and drums are new simple implementations.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun InstrumentsMenuScreen(navController: NavController, starState: MutableState<Int>) {
    val instruments = listOf(
        "Pian" to Screen.Piano.route,
        "Tobe" to Screen.Drums.route,
        "Xilofon" to Screen.Instrument.route
    )

    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.lumea_background),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
            Text(
                text = "Meniu Instrumente",
                style = MaterialTheme.typography.displayMedium,
                fontFamily = FontFamily.Cursive,
                modifier = Modifier.padding(bottom = 16.dp).align(Alignment.CenterHorizontally)
            )
            LazyColumn(modifier = Modifier.weight(1f)) {
                items(instruments) { instrument ->
                    Card(
                        onClick = { navController.navigate(instrument.second) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 4.dp),
                        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(16.dp),
                            horizontalArrangement = Arrangement.Center,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(text = instrument.first, style = MaterialTheme.typography.titleLarge, fontFamily = FontFamily.Cursive)
                        }
                    }
                }
            }
        }
        IconButton(
            onClick = { navController.navigate(Screen.MainMenu.route) },
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(16.dp)
        ) {
            Image(
                imageVector = Icons.Default.Home,
                contentDescription = "Acasă",
                modifier = Modifier.size(40.dp)
            )
        }
    }
}