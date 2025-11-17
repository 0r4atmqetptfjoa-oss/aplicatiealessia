package com.example.educationalapp

import android.media.ToneGenerator
import android.media.AudioManager
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import androidx.compose.foundation.layout.Box

/**
 * Displays a grid of sound items for a given category.  When an item is
 * selected its corresponding tone is played using ToneGenerator.  After
 * exploring five items the child receives a star.  Categories include
 * birds, vehicles, farm, jungle and maritime; unrecognised categories
 * default to an empty list.  To add new categories provide an entry in
 * the 'itemsForCategory' map.
 */
data class CategoryItem(val name: String, val emoji: String, val toneType: Int)

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun SoundCategoryScreen(navController: NavController, starState: MutableState<Int>, category: String) {
    // Map categories to their list of sound items.  Tone types are chosen from
    // ToneGenerator constants to provide unique sounds.
    val itemsForCategory: Map<String, List<CategoryItem>> = mapOf(
        "birds" to listOf(
            CategoryItem("Vrăbiuță", "🐦", ToneGenerator.TONE_CDMA_HIGH_L),
            CategoryItem("Bufniță", "🦉", ToneGenerator.TONE_CDMA_MED_L),
            CategoryItem("Papagal", "🦜", ToneGenerator.TONE_CDMA_ABBR_ALERT)
        ),
        "vehicles" to listOf(
            CategoryItem("Mașină", "🚗", ToneGenerator.TONE_CDMA_NETWORK_BUSY),
            CategoryItem("Tren", "🚂", ToneGenerator.TONE_SUP_RINGTONE),
            CategoryItem("Ambulanță", "🚑", ToneGenerator.TONE_CDMA_HIGH_SS)
        ),
        "farm" to listOf(
            CategoryItem("Vacă", "🐮", ToneGenerator.TONE_CDMA_LOW_L),
            CategoryItem("Cal", "🐴", ToneGenerator.TONE_SUP_CONGESTION),
            CategoryItem("Oaie", "🐑", ToneGenerator.TONE_CDMA_MED_SS)
        ),
        "jungle" to listOf(
            CategoryItem("Leu", "🦁", ToneGenerator.TONE_CDMA_HIGH_SS),
            CategoryItem("Maimuță", "🐒", ToneGenerator.TONE_CDMA_MED_L),
            CategoryItem("Elefant", "🐘", ToneGenerator.TONE_SUP_PIP)
        ),
        "maritime" to listOf(
            CategoryItem("Pește", "🐟", ToneGenerator.TONE_CDMA_LOW_SS),
            CategoryItem("Balena", "🐋", ToneGenerator.TONE_CDMA_MED_SS),
            CategoryItem("Delfin", "🐬", ToneGenerator.TONE_CDMA_MED_L)
        )
    )
    val items = itemsForCategory[category] ?: emptyList()
    // track number of plays to award stars after exploring multiple sounds
    var plays by remember { mutableStateOf(0) }
    val feedback = remember { mutableStateOf("") }
    // ToneGenerator should be released when Composable leaves composition
    val toneGenerator = remember { ToneGenerator(AudioManager.STREAM_MUSIC, 100) }
    DisposableEffect(Unit) {
        onDispose { toneGenerator.release() }
    }
    fun playTone(item: CategoryItem) {
        toneGenerator.startTone(item.toneType, 300)
        plays++
        if (plays >= 5) {
            starState.value += 1
            feedback.value = "Bravo! Ai explorat 5 sunete și ai câștigat o stea."
            plays = 0
        }
    }
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        val capitalized = category.replaceFirstChar { if (it.isLowerCase()) it.titlecase() else it.toString() }
        Text(text = "Categorie: $capitalized", modifier = Modifier.padding(bottom = 16.dp))
        if (items.isNotEmpty()) {
            LazyVerticalGrid(columns = GridCells.Fixed(2), modifier = Modifier.weight(1f)) {
                items(items) { item ->
                    Card(modifier = Modifier.padding(8.dp).fillMaxWidth().aspectRatio(1f)) {
                        Box(
                            modifier = Modifier.fillMaxSize(),
                            contentAlignment = Alignment.Center
                        ) {
                            Button(onClick = { playTone(item) }) {
                                Text(text = "${item.emoji}\n${item.name}")
                            }
                        }
                    }
                }
            }
        } else {
            Text(text = "Nu există sunete pentru această categorie.")
        }
        if (feedback.value.isNotEmpty()) {
            Text(text = feedback.value, modifier = Modifier.padding(vertical = 8.dp))
        }
        Button(onClick = { navController.navigate(Screen.SoundsMenu.route) }) {
            Text(text = "Înapoi la Meniu Sunete")
        }
    }
}