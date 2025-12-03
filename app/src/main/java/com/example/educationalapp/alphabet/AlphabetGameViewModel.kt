package com.example.educationalapp.alphabet

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

data class AlphabetGameUiState(
    val currentQuestion: AlphabetItem,
    val options: List<Char>,
    val questionIndex: Int = 0,
    val totalQuestions: Int,
    val score: Int = 0,
    val stars: Int = 0,
    val isAnswerCorrect: Boolean? = null, // null = unanswered, true = correct, false = wrong
    val isFinished: Boolean = false,
    val isInputLocked: Boolean = false,
    // Internal state to avoid repeating questions
    internal val answeredQuestions: List<AlphabetItem> = emptyList()
)

@HiltViewModel
class AlphabetGameViewModel @Inject constructor() : ViewModel() {

    private val _uiState = MutableStateFlow(createInitialState())
    val uiState: StateFlow<AlphabetGameUiState> = _uiState.asStateFlow()

    private val totalQuestions = 10

    init {
        resetGame()
    }

    fun selectAnswer(selectedOption: Char) {
        val currentState = _uiState.value
        if (currentState.isInputLocked || currentState.isFinished) return

        val isCorrect = selectedOption == currentState.currentQuestion.letter
        
        _uiState.update {
            it.copy(
                isAnswerCorrect = isCorrect,
                isInputLocked = true,
                score = if (isCorrect) it.score + 10 else it.score,
                stars = if (isCorrect) (it.stars + 1).coerceAtMost(5) else it.stars
            )
        }

        viewModelScope.launch {
            delay(1500L) // Wait for animations/feedback to be seen
            proceedToNextStep()
        }
    }

    fun resetGame() {
        _uiState.value = generateNextQuestionState(
            currentIndex = 0,
            currentScore = 0,
            currentStars = 0,
            previousQuestions = emptyList()
        )
    }

    private fun proceedToNextStep() {
        val currentState = _uiState.value

        if (currentState.questionIndex + 1 < totalQuestions) {
            _uiState.value = generateNextQuestionState(
                currentIndex = currentState.questionIndex + 1,
                currentScore = currentState.score,
                currentStars = currentState.stars,
                previousQuestions = currentState.answeredQuestions
            )
        } else {
            _uiState.update { it.copy(isFinished = true, isInputLocked = false) }
        }
    }

    private fun generateNextQuestionState(
        currentIndex: Int,
        currentScore: Int,
        currentStars: Int,
        previousQuestions: List<AlphabetItem>
    ): AlphabetGameUiState {
        // Find a new question that hasn't been asked before
        val newQuestion = AlphabetAssets.items
            .filterNot { it in previousQuestions }
            .random()

        val correctAnswer = newQuestion.letter
        val allLetters = ('A'..'Z').toList()

        // Generate two unique, incorrect options
        val incorrectOptions = allLetters
            .filter { it != correctAnswer }
            .shuffled()
            .take(2)

        val options = (incorrectOptions + correctAnswer).shuffled()

        return AlphabetGameUiState(
            currentQuestion = newQuestion,
            options = options,
            questionIndex = currentIndex,
            totalQuestions = totalQuestions,
            score = currentScore,
            stars = currentStars,
            isAnswerCorrect = null,
            isFinished = false,
            isInputLocked = false,
            answeredQuestions = previousQuestions + newQuestion
        )
    }

    // Helper to create a dummy initial state before the first real question is generated.
    private fun createInitialState(): AlphabetGameUiState {
        return AlphabetGameUiState(
            currentQuestion = AlphabetAssets.items.first(),
            options = listOf('A', 'B', 'C'),
            totalQuestions = totalQuestions
        )
    }
}
