package com.example.educationalapp;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u0000J\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\f\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a\u001e\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00010\u0007H\u0007\u001a\b\u0010\b\u001a\u00020\u0003H\u0003\u001a5\u0010\t\u001a\u00020\u00032\u0006\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\u000b2\u0006\u0010\r\u001a\u00020\u000e2\f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00030\u0010H\u0003\u00a2\u0006\u0002\u0010\u0011\u001a\u001c\u0010\u0012\u001a\u00020\u00032\u0012\u0010\u0013\u001a\u000e\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u00160\u0014H\u0003\u001a&\u0010\u0017\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0018\u001a\u00020\u00012\f\u0010\u0019\u001a\b\u0012\u0004\u0012\u00020\u00030\u0010H\u0003\u001a \u0010\u001a\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u001b\u001a\u00020\u00012\u0006\u0010\u0018\u001a\u00020\u0001H\u0003\u001a\b\u0010\u001c\u001a\u00020\u001dH\u0002\u001a \u0010\u001e\u001a\u00020\u00152\u0006\u0010\u001f\u001a\u00020\u00152\u0006\u0010 \u001a\u00020\u00152\u0006\u0010!\u001a\u00020\u0015H\u0002\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T\u00a2\u0006\u0002\n\u0000\u00a8\u0006\""}, d2 = {"TOTAL_QUESTIONS", "", "AlphabetQuizScreen", "", "navController", "Landroidx/navigation/NavController;", "starState", "Landroidx/compose/runtime/MutableState;", "CorrectAnswerParticles", "OptionCard", "option", "", "selectedOption", "answerState", "Lcom/example/educationalapp/AnswerState;", "onClick", "Lkotlin/Function0;", "(CLjava/lang/Character;Lcom/example/educationalapp/AnswerState;Lkotlin/jvm/functions/Function0;)V", "Particle", "anim", "Landroidx/compose/animation/core/Animatable;", "", "Landroidx/compose/animation/core/AnimationVector1D;", "QuizEndDialog", "score", "onRestart", "QuizHeader", "questionIndex", "generateQuestion", "Lcom/example/educationalapp/QuizQuestion;", "lerp", "start", "stop", "fraction", "app_debug"})
public final class AlphabetQuizScreenKt {
    private static final int TOTAL_QUESTIONS = 10;
    
    @androidx.compose.runtime.Composable()
    public static final void AlphabetQuizScreen(@org.jetbrains.annotations.NotNull()
    androidx.navigation.NavController navController, @org.jetbrains.annotations.NotNull()
    androidx.compose.runtime.MutableState<java.lang.Integer> starState) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void QuizHeader(androidx.navigation.NavController navController, int questionIndex, int score) {
    }
    
    @kotlin.OptIn(markerClass = {androidx.compose.material3.ExperimentalMaterial3Api.class})
    @androidx.compose.runtime.Composable()
    private static final void OptionCard(char option, java.lang.Character selectedOption, com.example.educationalapp.AnswerState answerState, kotlin.jvm.functions.Function0<kotlin.Unit> onClick) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void Particle(androidx.compose.animation.core.Animatable<java.lang.Float, androidx.compose.animation.core.AnimationVector1D> anim) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void CorrectAnswerParticles() {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void QuizEndDialog(androidx.navigation.NavController navController, int score, kotlin.jvm.functions.Function0<kotlin.Unit> onRestart) {
    }
    
    private static final com.example.educationalapp.QuizQuestion generateQuestion() {
        return null;
    }
    
    private static final float lerp(float start, float stop, float fraction) {
        return 0.0F;
    }
}