package com.example.educationalapp

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.*
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.example.educationalapp.QuizAnswerState
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.random.Random

private const val TOTAL_COLOR_QUESTIONS = 10

data class NamedColor(val name: String, val color: Color)
data class ColorQuizQuestion(val color: NamedColor, val options: List<NamedColor>)

@Composable
fun ColorMatchScreen(navController: NavController, starState: MutableState<Int>) {
    val colors = remember {
        listOf(
            NamedColor("Roșu", Color(0xFFE74C3C)),
            NamedColor("Verde", Color(0xFF2ECC71)),
            NamedColor("Albastru", Color(0xFF3498DB)),
            NamedColor("Galben", Color(0xFFF1C40F)),
            NamedColor("Mov", Color(0xFF9B59B6)),
            NamedColor("Portocaliu", Color(0xFFE67E22)),
            NamedColor("Roz", Color(0xFFF5A9BC)),
        )
    }

    var score by remember { mutableStateOf(0) }
    var questionIndex by remember { mutableStateOf(0) }
    var currentQuestion by remember { mutableStateOf(generateColorQuestion(colors)) }
    var selectedOption by remember { mutableStateOf<NamedColor?>(null) }
    var answerState by remember { mutableStateOf(QuizAnswerState.UNANSWERED) }
    val coroutineScope = rememberCoroutineScope()

    fun nextQuestion() {
        if (questionIndex < TOTAL_COLOR_QUESTIONS - 1) {
            questionIndex++
            currentQuestion = generateColorQuestion(colors)
            answerState = QuizAnswerState.UNANSWERED
            selectedOption = null
        } else {
            questionIndex++ // To trigger the dialog
        }
    }

    fun handleAnswer(option: NamedColor) {
        if (answerState != QuizAnswerState.UNANSWERED) return

        selectedOption = option
        if (option.name == currentQuestion.color.name) {
            answerState = QuizAnswerState.CORRECT
            score += 10
            starState.value += 1
        } else {
            answerState = QuizAnswerState.INCORRECT
            score = (score - 5).coerceAtLeast(0)
        }

        coroutineScope.launch {
            delay(1500)
            nextQuestion()
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        Image(
            painter = painterResource(id = R.drawable.generic_background_mainmenu_morning_f0001),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )

        if (questionIndex >= TOTAL_COLOR_QUESTIONS) {
            ColorQuizEndDialog(navController, score) {
                score = 0
                questionIndex = 0
                currentQuestion = generateColorQuestion(colors)
                answerState = QuizAnswerState.UNANSWERED
                selectedOption = null
            }
        }

        AnimatedVisibility(visible = questionIndex < TOTAL_COLOR_QUESTIONS, enter = fadeIn(), exit = fadeOut()) {
            Column(
                modifier = Modifier.fillMaxSize().padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                ColorQuizHeader(navController, questionIndex, score)
                Spacer(modifier = Modifier.height(32.dp))

                Text(
                    text = "Atinge culoarea: ${currentQuestion.color.name}",
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
                        ColorOptionCard(option, selectedOption, answerState) { handleAnswer(option) }
                    }
                }
            }
        }
    }
}

@Composable
private fun ColorQuizHeader(navController: NavController, questionIndex: Int, score: Int) {
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
            progress = (questionIndex) / TOTAL_COLOR_QUESTIONS.toFloat(),
            modifier = Modifier.fillMaxWidth().height(8.dp)
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ColorOptionCard(option: NamedColor, selectedOption: NamedColor?, answerState: QuizAnswerState, onClick: () -> Unit) {
    val isSelected = option == selectedOption
    val shakeController = remember { Animatable(0f) }

    LaunchedEffect(answerState, isSelected) {
        if (isSelected && answerState == QuizAnswerState.INCORRECT) {
            shakeController.animateTo(
                targetValue = 1f,
                animationSpec = keyframes {
                    durationMillis = 500
                    -10f at 50; 10f at 100; -10f at 150; 10f at 200; -5f at 250; 5f at 300; 0f at 350
                }
            ).let { shakeController.snapTo(0f) }
        }
    }

    val borderColor by animateColorAsState(
        targetValue = when {
            !isSelected -> Color.Transparent
            answerState == QuizAnswerState.CORRECT -> Color.White
            answerState == QuizAnswerState.INCORRECT -> Color(0xFFD32F2F)
            else -> Color.Transparent
        }, label = "borderColor"
    )

    Card(
        onClick = onClick,
        modifier = Modifier.size(100.dp).graphicsLayer { translationX = shakeController.value * 20f },
        shape = CircleShape,
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp),
        border = BorderStroke(4.dp, borderColor),
        colors = CardDefaults.cardColors(containerColor = option.color)
    ) {
        Box(contentAlignment = Alignment.Center, modifier = Modifier.fillMaxSize()) {
            if (isSelected && answerState == QuizAnswerState.CORRECT) {
                ColorCorrectAnswerParticles()
            }
        }
    }
}

@Composable
private fun ColorCorrectAnswerParticles() {
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
                 ColorParticle(anim)
            }
        }
    }
}

@Composable
private fun ColorParticle(anim: Animatable<Float, AnimationVector1D>) {
    val x = remember { Random.nextFloat() * 300f - 150f }
    val y = remember { Random.nextFloat() * -300f - 100f }

    val currentAlpha = (1f - anim.value).coerceIn(0f, 1f)
    val currentScale = lerp(0.5f, 2.0f, anim.value)

    Icon(
        imageVector = Icons.Default.Star,
        contentDescription = null,
        tint = Color.White.copy(alpha = 0.8f),
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
private fun ColorQuizEndDialog(navController: NavController, score: Int, onRestart: () -> Unit) {
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

private fun generateColorQuestion(colors: List<NamedColor>): ColorQuizQuestion {
    val correctColor = colors.random()
    val options = mutableSetOf(correctColor)
    while (options.size < 3) {
        options.add(colors.random())
    }
    return ColorQuizQuestion(correctColor, options.shuffled())
}

private fun lerp(start: Float, stop: Float, fraction: Float): Float {
    return start + fraction * (stop - start)
}
