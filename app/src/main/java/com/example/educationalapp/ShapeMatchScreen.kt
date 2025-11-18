package com.example.educationalapp

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.*
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.example.educationalapp.data.NamedShape
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.random.Random

private const val TOTAL_SHAPE_QUESTIONS = 10

data class ShapeQuizQuestion(val shape: NamedShape, val options: List<NamedShape>)

@Composable
fun ShapeMatchScreen(navController: NavController, starState: MutableState<Int>) {
    val shapes = remember {
        listOf(
            NamedShape("Inimă", Icons.Default.Favorite, Color(0xFFE74C3C)),
            NamedShape("Stea", Icons.Default.Star, Color(0xFFF1C40F)),
            NamedShape("Info", Icons.Default.Info, Color(0xFF2ECC71)), // Placeholder
        )
    }

    var score by remember { mutableStateOf(0) }
    var questionIndex by remember { mutableStateOf(0) }
    var currentQuestion by remember { mutableStateOf(generateShapeQuestion(shapes)) }
    var selectedOption by remember { mutableStateOf<NamedShape?>(null) }
    var answerState by remember { mutableStateOf(AnswerState.UNANSWERED) }
    val coroutineScope = rememberCoroutineScope()

    fun nextQuestion() {
        if (questionIndex < TOTAL_SHAPE_QUESTIONS - 1) {
            questionIndex++
            currentQuestion = generateShapeQuestion(shapes)
            answerState = AnswerState.UNANSWERED
            selectedOption = null
        } else {
            questionIndex++ // To trigger the dialog
        }
    }

    fun handleAnswer(option: NamedShape) {
        if (answerState != AnswerState.UNANSWERED) return

        selectedOption = option
        if (option.name == currentQuestion.shape.name) {
            answerState = AnswerState.CORRECT
            score += 10
            starState.value += 1
        } else {
            answerState = AnswerState.INCORRECT
            score = (score - 5).coerceAtLeast(0)
        }

        coroutineScope.launch {
            delay(1500)
            nextQuestion()
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.lumea_background),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )

        if (questionIndex >= TOTAL_SHAPE_QUESTIONS) {
            ShapeQuizEndDialog(navController, score) {
                score = 0
                questionIndex = 0
                currentQuestion = generateShapeQuestion(shapes)
                answerState = AnswerState.UNANSWERED
                selectedOption = null
            }
        }

        AnimatedVisibility(visible = questionIndex < TOTAL_SHAPE_QUESTIONS, enter = fadeIn(), exit = fadeOut()) {
            Column(
                modifier = Modifier.fillMaxSize().padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                ShapeQuizHeader(navController, questionIndex, score)
                Spacer(modifier = Modifier.height(32.dp))

                Text(
                    text = "Atinge forma: ${currentQuestion.shape.name}",
                    style = MaterialTheme.typography.displayMedium.copy(
                        fontFamily = FontFamily.Cursive,
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    )
                )

                Spacer(modifier = Modifier.height(32.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    currentQuestion.options.forEach { option ->
                        ShapeOptionCard(option, selectedOption, answerState) { handleAnswer(option) }
                    }
                }
            }
        }
    }
}

@Composable
private fun ShapeQuizHeader(navController: NavController, questionIndex: Int, score: Int) {
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
        Spacer(modifier = Modifier.height(16.dp))
        LinearProgressIndicator(
            progress = (questionIndex) / TOTAL_SHAPE_QUESTIONS.toFloat(),
            modifier = Modifier.fillMaxWidth().height(8.dp)
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ShapeOptionCard(option: NamedShape, selectedOption: NamedShape?, answerState: AnswerState, onClick: () -> Unit) {
    val isSelected = option == selectedOption
    val shakeController = remember { Animatable(0f) }

    LaunchedEffect(answerState, isSelected) {
        if (isSelected && answerState == AnswerState.INCORRECT) {
            shakeController.animateTo(
                targetValue = 1f,
                animationSpec = keyframes {
                    durationMillis = 500
                    -10f at 50; 10f at 100; -10f at 150; 10f at 200; -5f at 250; 5f at 300; 0f at 350
                }
            ).let { shakeController.snapTo(0f) }
        }
    }

    val cardColor by animateColorAsState(
        targetValue = when {
            !isSelected -> MaterialTheme.colorScheme.surface
            answerState == AnswerState.CORRECT -> Color(0xFF81C784) // Green
            answerState == AnswerState.INCORRECT -> Color(0xFFE57373) // Red
            else -> MaterialTheme.colorScheme.surface
        }, label = "cardColor"
    )

    Card(
        onClick = onClick,
        modifier = Modifier.size(100.dp).graphicsLayer { translationX = shakeController.value * 20f },
        shape = RoundedCornerShape(16.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp),
        colors = CardDefaults.cardColors(containerColor = cardColor)
    ) {
        Box(contentAlignment = Alignment.Center, modifier = Modifier.fillMaxSize()) {
            Icon(
                imageVector = option.icon,
                contentDescription = option.name,
                modifier = Modifier.size(60.dp),
                tint = option.color
            )
            if (isSelected && answerState == AnswerState.CORRECT) {
                ShapeCorrectAnswerParticles()
            }
        }
    }
}

@Composable
private fun ShapeCorrectAnswerParticles() {
    val particles = remember { List(15) { Animatable(0f) } }

    LaunchedEffect(Unit) {
        particles.forEachIndexed { index, animatable ->
            launch {
                delay(index * 20L)
                animatable.animateTo(
                    targetValue = 1f,
                    animationSpec = tween(durationMillis = 1000, easing = LinearOutSlowInEasing)
                )
            }
        }
    }

    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
        particles.forEach { anim ->
            if (anim.value > 0f && anim.value < 1f) {
                ShapeParticle(anim)
            }
        }
    }
}

@Composable
private fun ShapeParticle(anim: Animatable<Float, AnimationVector1D>) {
    val x = remember { Random.nextFloat() * 300f - 150f }
    val y = remember { Random.nextFloat() * -300f - 100f }

    val currentAlpha = (1f - anim.value).coerceIn(0f, 1f)
    val currentScale = lerp(0.5f, 2.0f, anim.value)

    Icon(
        imageVector = Icons.Default.Star,
        contentDescription = null,
        tint = Color.Yellow,
        modifier = Modifier
            .graphicsLayer {
                translationX = x
                translationY = y * anim.value
                scaleX = currentScale
                scaleY = currentScale
                alpha = currentAlpha
            }
    )
}

@Composable
private fun ShapeQuizEndDialog(navController: NavController, score: Int, onRestart: () -> Unit) {
    AlertDialog(
        onDismissRequest = { navController.navigate(Screen.MainMenu.route) },
        title = { Text(text = "Joc Terminat!", textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth()) },
        text = { Text(text = "Felicitări! Scorul tău este $score.", textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth()) },
        confirmButton = {
            Button(onClick = onRestart) {
                Text("Joacă din nou")
            }
        },
        dismissButton = {
            Button(onClick = { navController.navigate(Screen.MainMenu.route) }) {
                Text("Meniu Principal")
            }
        }
    )
}

private fun generateShapeQuestion(shapes: List<NamedShape>): ShapeQuizQuestion {
    val correctShape = shapes.random()
    val options = mutableSetOf(correctShape)
    while (options.size < 3) {
        options.add(shapes.random())
    }
    return ShapeQuizQuestion(correctShape, options.shuffled())
}
