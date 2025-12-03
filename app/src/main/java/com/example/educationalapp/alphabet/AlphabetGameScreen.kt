package com.example.educationalapp.alphabet

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.Crossfade
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.*
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.example.educationalapp.ui.theme.EducationalAppTheme
import kotlinx.coroutines.launch

@Composable
fun AlphabetGameScreen(
    viewModel: AlphabetGameViewModel = hiltViewModel(),
    onBackToMenu: () -> Unit
) {
    val uiState by viewModel.uiState.collectAsState()

    Box(modifier = Modifier.fillMaxSize()) {
        AlphabetParallaxBackground()
        
        AlphabetGameContent(
            uiState = uiState,
            onOptionSelected = { viewModel.selectAnswer(it) },
            onReplay = { viewModel.resetGame() },
            onBackToMenu = onBackToMenu
        )
    }
}

@Composable
private fun AlphabetGameContent(
    uiState: AlphabetGameUiState,
    onOptionSelected: (Char) -> Unit,
    onReplay: () -> Unit,
    onBackToMenu: () -> Unit
) {

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        GameHeader(uiState.questionIndex, uiState.totalQuestions, uiState.score, uiState.stars)

        Spacer(modifier = Modifier.height(24.dp))
        QuestionDisplay(uiState.currentQuestion, uiState.isAnswerCorrect)
        Spacer(modifier = Modifier.weight(1f))
        OptionsRow(
            options = uiState.options,
            correctAnswer = uiState.currentQuestion.letter,
            isAnswerCorrect = uiState.isAnswerCorrect,
            isInputLocked = uiState.isInputLocked,
            onOptionSelected = onOptionSelected
        )
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(bottom = 16.dp, end = 16.dp)
    ) {
        Mascot(
            isAnswerCorrect = uiState.isAnswerCorrect,
            modifier = Modifier.align(Alignment.BottomEnd)
        )
    }

    AnimatedVisibility(
        visible = uiState.isAnswerCorrect == true,
        enter = fadeIn(animationSpec = tween(300)),
        exit = fadeOut(animationSpec = tween(500))
    ) {
        ConfettiOverlay()
    }

    if (uiState.isFinished) {
        GameCompletionDialog(
            score = uiState.score,
            stars = uiState.stars,
            onReplay = onReplay,
            onBackToMenu = onBackToMenu
        )
    }
}

@Composable
private fun GameHeader(questionIndex: Int, totalQuestions: Int, score: Int, stars: Int) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Text(
            text = "Întrebarea ${questionIndex + 1} / $totalQuestions",
            style = MaterialTheme.typography.titleMedium,
            color = Color.White
        )
        Text(
            text = "Scor: $score",
            style = MaterialTheme.typography.headlineSmall,
            fontWeight = FontWeight.Bold,
            color = Color.White
        )
        Row(
            horizontalArrangement = Arrangement.spacedBy(4.dp),
            modifier = Modifier.padding(top = 8.dp)
        ) {
            repeat(stars) {
                Image(
                    painter = painterResource(id = AlphabetUi.Icons.star),
                    contentDescription = "Star",
                    modifier = Modifier.size(32.dp)
                )
            }
        }
    }
}

@Composable
private fun QuestionDisplay(question: AlphabetItem, isAnswerCorrect: Boolean?) {
    val scale by animateFloatAsState(
        targetValue = if (isAnswerCorrect == true) 1.05f else 1.0f,
        animationSpec = spring(
            dampingRatio = Spring.DampingRatioMediumBouncy,
            stiffness = Spring.StiffnessLow
        ), label = "CardPulse"
    )

    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier.scale(scale)
    ) {
        Box(contentAlignment = Alignment.Center) {
            Image(
                painter = painterResource(id = AlphabetUi.Cards.main),
                contentDescription = "Letter Card",
                modifier = Modifier.size(180.dp)
            )
            Text(
                text = question.letter.toString(),
                fontSize = 80.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary
            )
        }
        Spacer(modifier = Modifier.height(16.dp))
        Image(
            painter = painterResource(id = question.imageRes),
            contentDescription = question.word,
            modifier = Modifier
                .height(140.dp)
                .aspectRatio(1.5f),
            contentScale = ContentScale.Fit
        )
    }
}

@Composable
private fun OptionsRow(
    options: List<Char>,
    correctAnswer: Char,
    isAnswerCorrect: Boolean?,
    isInputLocked: Boolean,
    onOptionSelected: (Char) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 8.dp),
        horizontalArrangement = Arrangement.SpaceEvenly,
        verticalAlignment = Alignment.CenterVertically
    ) {
        options.forEach { option ->
            OptionButton(
                option = option,
                isCorrectChoice = option == correctAnswer,
                isAnswered = isAnswerCorrect != null,
                isInputLocked = isInputLocked,
                onSelected = { onOptionSelected(option) }
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun OptionButton(
    option: Char,
    isCorrectChoice: Boolean,
    isAnswered: Boolean,
    isInputLocked: Boolean,
    onSelected: () -> Unit
) {
    val coroutineScope = rememberCoroutineScope()
    val offsetX = remember { Animatable(0f) }
    var wasWronglySelected by remember { mutableStateOf(false) }

    val backgroundColor by animateColorAsState(
        targetValue = when {
            isAnswered && isCorrectChoice -> Color(0xFF66BB6A) // Green
            wasWronglySelected -> Color(0xFFEF5350) // Red
            else -> MaterialTheme.colorScheme.surfaceVariant
        },
        label = "ButtonColor"
    )

    LaunchedEffect(isAnswered, isCorrectChoice) {
        if (isAnswered && !isCorrectChoice && !wasWronglySelected) {
             // Mark this button as the one that was wrongly selected, if it was
        } else if (isAnswered && !isCorrectChoice) {
             // This logic is simplified: the shake now happens on the selected wrong button
        }
    }

    LaunchedEffect(wasWronglySelected) {
        if(wasWronglySelected) {
            coroutineScope.launch {
                offsetX.animateTo(0f, animationSpec = keyframes {
                    durationMillis = 500
                    -10f at 50
                    10f at 150
                    -10f at 250
                    10f at 350
                    0f at 450
                })
                wasWronglySelected = false // Reset after shake
            }
        }
    }

    Surface(
        onClick = {
            if (!isInputLocked) {
                if (!isCorrectChoice) wasWronglySelected = true
                onSelected()
            }
        },
        modifier = Modifier
            .size(90.dp)
            .offset(x = offsetX.value.dp),
        shape = RoundedCornerShape(24.dp),
        color = backgroundColor,
        shadowElevation = 4.dp
    ) {
        Box(contentAlignment = Alignment.Center) {
            Text(
                text = option.toString(),
                fontSize = 40.sp,
                fontWeight = FontWeight.Bold,
                color = if (isAnswered && isCorrectChoice || wasWronglySelected) Color.White else MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}


@Composable
private fun Mascot(isAnswerCorrect: Boolean?, modifier: Modifier = Modifier) {
    val mascotRes = when (isAnswerCorrect) {
        true -> AlphabetUi.Mascot.happy
        false -> AlphabetUi.Mascot.surprised
        else -> AlphabetUi.Mascot.thinking
    }

    Crossfade(targetState = mascotRes, animationSpec = tween(500), label = "MascotCrossfade", modifier = modifier) { resId ->
        Image(
            painter = painterResource(id = resId),
            contentDescription = "Mascot",
            modifier = Modifier.size(120.dp)
        )
    }
}

@Composable
private fun ConfettiOverlay() {
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        Image(
            painter = painterResource(id = AlphabetUi.Effects.confetti),
            contentDescription = "Confetti",
            modifier = Modifier.fillMaxSize(),
            contentScale = ContentScale.Crop
        )
    }
}

@Composable
private fun GameCompletionDialog(
    score: Int,
    stars: Int,
    onReplay: () -> Unit,
    onBackToMenu: () -> Unit
) {
    AlertDialog(
        onDismissRequest = { /* Do nothing, force a choice */ },
        title = { Text("Bravo!", fontWeight = FontWeight.Bold) },
        text = {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Text("Ai terminat jocul!", textAlign = TextAlign.Center)
                Spacer(modifier = Modifier.height(16.dp))
                Text("Scor final: $score", style = MaterialTheme.typography.headlineMedium)
                Spacer(modifier = Modifier.height(8.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                    repeat(stars) {
                        Image(
                            painter = painterResource(id = AlphabetUi.Icons.star),
                            contentDescription = null,
                            modifier = Modifier.size(40.dp)
                        )
                    }
                }
            }
        },
        confirmButton = {
            Button(onClick = onReplay) {
                Text("Joacă din nou")
            }
        },
        dismissButton = {
            TextButton(onClick = onBackToMenu) {
                Text("Înapoi la meniu")
            }
        }
    )
}

@Composable
private fun AlphabetParallaxBackground() {
    val infiniteTransition = rememberInfiniteTransition(label = "Parallax")
    val parallaxOffset by infiniteTransition.animateFloat(
        initialValue = -1f,
        targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 40000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "ParallaxOffset"
    )

    val screenWidth = LocalConfiguration.current.screenWidthDp
    val maxTranslation = screenWidth * 0.1f

    Box(modifier = Modifier.fillMaxSize()) {
        ParallaxLayer(
            drawableRes = AlphabetUi.Backgrounds.sky,
            translation = parallaxOffset * maxTranslation * 0.2f
        )
        ParallaxLayer(
            drawableRes = AlphabetUi.Backgrounds.city,
            translation = parallaxOffset * maxTranslation * 0.4f
        )
        ParallaxLayer(
            drawableRes = AlphabetUi.Backgrounds.foreground,
            translation = parallaxOffset * maxTranslation * 0.8f
        )
    }
}

@Composable
private fun ParallaxLayer(drawableRes: Int, translation: Float) {
    Image(
        painter = painterResource(id = drawableRes),
        contentDescription = null,
        modifier = Modifier
            .fillMaxSize()
            .graphicsLayer { translationX = translation },
        contentScale = ContentScale.Crop
    )
}

@Preview
@Composable
private fun AlphabetGameScreenPreview() {
    val previewState = AlphabetGameUiState(
        currentQuestion = AlphabetAssets.items[0],
        options = listOf('A', 'X', 'Y'),
        questionIndex = 0,
        totalQuestions = 10,
        score = 0,
        stars = 0
    )
    EducationalAppTheme {
        Box(modifier = Modifier.fillMaxSize()) {
            AlphabetParallaxBackground()
            AlphabetGameContent(
                uiState = previewState,
                onOptionSelected = {},
                onReplay = {},
                onBackToMenu = {}
            )
        }
    }
}
