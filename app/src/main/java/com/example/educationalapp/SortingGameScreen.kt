package com.example.educationalapp

import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import kotlin.math.roundToInt
import kotlin.random.Random

enum class ItemCategory { FARM, JUNGLE }
data class SortableItem(val id: Int, val icon: ImageVector, val category: ItemCategory)
data class TargetBox(val category: ItemCategory, var bounds: androidx.compose.ui.geometry.Rect)

@Composable
fun SortingGameScreen(navController: NavController, starState: MutableState<Int>) {
    val itemsToSort = remember {
        generateItems().shuffled()
    }
    var draggedItem by remember { mutableStateOf<SortableItem?>(null) }
    var itemPositions by remember { mutableStateOf(mapOf<Int, Offset>()) }
    var score by remember { mutableStateOf(0) }
    var sortedItems by remember { mutableStateOf(emptySet<Int>()) }

    val targetBoxes = remember {
        mutableStateMapOf(
            ItemCategory.FARM to TargetBox(ItemCategory.FARM, androidx.compose.ui.geometry.Rect.Zero),
            ItemCategory.JUNGLE to TargetBox(ItemCategory.JUNGLE, androidx.compose.ui.geometry.Rect.Zero)
        )
    }
    
    fun resetGame() {
        sortedItems = emptySet()
        score = 0
        // You might want to re-shuffle items as well
    }

    fun handleDrop(item: SortableItem, position: Offset) {
        val target = targetBoxes.values.find { it.bounds.contains(position) }
        if (target != null && target.category == item.category) {
            sortedItems = sortedItems + item.id
            score += 10
            starState.value += 1
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        Image(painter = painterResource(id = R.drawable.lumea_background), contentDescription = null, contentScale = ContentScale.Crop, modifier = Modifier.fillMaxSize())

        Column(
            modifier = Modifier.fillMaxSize().padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            SortingGameHeader(navController, score, itemsToSort.size, sortedItems.size)

            // Drop Targets
            Row(
                modifier = Modifier.fillMaxWidth().weight(1f),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.CenterVertically
            ) {
                DropTarget(category = ItemCategory.FARM, onBoundsChanged = { targetBoxes[ItemCategory.FARM] = targetBoxes[ItemCategory.FARM]!!.copy(bounds = it) })
                DropTarget(category = ItemCategory.JUNGLE, onBoundsChanged = { targetBoxes[ItemCategory.JUNGLE] = targetBoxes[ItemCategory.JUNGLE]!!.copy(bounds = it) })
            }

            // Draggable Items
            Row(
                modifier = Modifier.fillMaxWidth().padding(bottom = 32.dp),
                horizontalArrangement = Arrangement.Center
            ) {
                itemsToSort.forEach {
                    if (it.id !in sortedItems) {
                        DraggableItem(
                            item = it,
                            position = itemPositions[it.id] ?: Offset.Zero,
                            onDragStart = { draggedItem = it },
                            onDragEnd = { handleDrop(it, itemPositions[it.id]!!) },
                            onPositionChange = { id, offset -> itemPositions = itemPositions + (id to offset) }
                        )
                    }
                }
            }
        }

        if (sortedItems.size == itemsToSort.size) {
            CompletionDialog(navController, "Felicitări!", "Ai sortat toate animalele!", ::resetGame)
        }
    }
}

@Composable
fun SortingGameHeader(navController: NavController, score: Int, total: Int, sorted: Int) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = { navController.navigate(Screen.MainMenu.route) }) {
                Icon(Icons.Default.Home, contentDescription = "Acasă", tint = Color.White, modifier = Modifier.size(40.dp))
            }
            Text(text = "Scor: $score", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Color.White)
        }
        Spacer(modifier = Modifier.height(8.dp))
        LinearProgressIndicator(progress = sorted / total.toFloat(), modifier = Modifier.fillMaxWidth().height(8.dp))
    }
}


@Composable
fun DraggableItem(item: SortableItem, position: Offset, onDragStart: () -> Unit, onDragEnd: () -> Unit, onPositionChange: (Int, Offset) -> Unit) {
    var offset by remember { mutableStateOf(Offset.Zero) }

    Icon(imageVector = item.icon, contentDescription = null, modifier = Modifier
        .size(80.dp)
        .offset { IntOffset(offset.x.roundToInt(), offset.y.roundToInt()) }
        .pointerInput(Unit) {
            detectDragGestures(
                onDragStart = { 
                    onDragStart()
                },
                onDragEnd = { 
                    onDragEnd()
                    offset = Offset.Zero // Reset position after drop
                },
                onDrag = { change, dragAmount ->
                    change.consume()
                    offset += dragAmount
                    onPositionChange(item.id, offset)
                }
            )
        }
        .padding(8.dp),
        tint = Color.White
    )
}

@Composable
fun DropTarget(category: ItemCategory, onBoundsChanged: (androidx.compose.ui.geometry.Rect) -> Unit) {
    Box(
        modifier = Modifier
            .size(150.dp)
            .onGloballyPositioned { onBoundsChanged(it.boundsInWindow()) }
            .border(2.dp, Color.White, RoundedCornerShape(16.dp)),
        contentAlignment = Alignment.Center
    ) {
        Text(text = category.name, color = Color.White, fontWeight = FontWeight.Bold, fontSize = 24.sp)
    }
}

private fun generateItems(): List<SortableItem> {
    return listOf(
        SortableItem(1, Icons.Default.ThumbUp, ItemCategory.FARM), // Placeholder
        SortableItem(2, Icons.Default.Info, ItemCategory.JUNGLE), // Placeholder
        SortableItem(3, Icons.Default.CheckCircle, ItemCategory.FARM), // Placeholder
        SortableItem(4, Icons.Default.Favorite, ItemCategory.JUNGLE), // Placeholder
        SortableItem(5, Icons.Default.Build, ItemCategory.FARM) // Placeholder
    )
}
