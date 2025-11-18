package com.example.educationalapp;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u0000D\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a\b\u0010\u0002\u001a\u00020\u0003H\u0003\u001a5\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u00012\b\u0010\u0006\u001a\u0004\u0018\u00010\u00012\u0006\u0010\u0007\u001a\u00020\b2\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00030\nH\u0003\u00a2\u0006\u0002\u0010\u000b\u001a\u001c\u0010\f\u001a\u00020\u00032\u0012\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u00100\u000eH\u0003\u001a&\u0010\u0011\u001a\u00020\u00032\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00012\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00030\nH\u0003\u001a \u0010\u0016\u001a\u00020\u00032\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0017\u001a\u00020\u00012\u0006\u0010\u0014\u001a\u00020\u0001H\u0003\u001a\u001e\u0010\u0018\u001a\u00020\u00032\u0006\u0010\u0012\u001a\u00020\u00132\f\u0010\u0019\u001a\b\u0012\u0004\u0012\u00020\u00010\u001aH\u0007\u001a\b\u0010\u001b\u001a\u00020\u001cH\u0002\u001a \u0010\u001d\u001a\u00020\u000f2\u0006\u0010\u001e\u001a\u00020\u000f2\u0006\u0010\u001f\u001a\u00020\u000f2\u0006\u0010 \u001a\u00020\u000fH\u0002\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T\u00a2\u0006\u0002\n\u0000\u00a8\u0006!"}, d2 = {"TOTAL_NUMBER_QUESTIONS", "", "NumberCorrectAnswerParticles", "", "NumberOptionCard", "option", "selectedOption", "answerState", "Lcom/example/educationalapp/AnswerState;", "onClick", "Lkotlin/Function0;", "(ILjava/lang/Integer;Lcom/example/educationalapp/AnswerState;Lkotlin/jvm/functions/Function0;)V", "NumberParticle", "anim", "Landroidx/compose/animation/core/Animatable;", "", "Landroidx/compose/animation/core/AnimationVector1D;", "NumberQuizEndDialog", "navController", "Landroidx/navigation/NavController;", "score", "onRestart", "NumberQuizHeader", "questionIndex", "NumberQuizScreen", "starState", "Landroidx/compose/runtime/MutableState;", "generateNumberQuestion", "Lcom/example/educationalapp/NumberQuizQuestion;", "lerp", "start", "stop", "fraction", "app_debug"})
public final class NumberQuizScreenKt {
    private static final int TOTAL_NUMBER_QUESTIONS = 10;
    
    @androidx.compose.runtime.Composable()
    public static final void NumberQuizScreen(@org.jetbrains.annotations.NotNull()
    androidx.navigation.NavController navController, @org.jetbrains.annotations.NotNull()
    androidx.compose.runtime.MutableState<java.lang.Integer> starState) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void NumberQuizHeader(androidx.navigation.NavController navController, int questionIndex, int score) {
    }
    
    @kotlin.OptIn(markerClass = {androidx.compose.material3.ExperimentalMaterial3Api.class})
    @androidx.compose.runtime.Composable()
    private static final void NumberOptionCard(int option, java.lang.Integer selectedOption, com.example.educationalapp.AnswerState answerState, kotlin.jvm.functions.Function0<kotlin.Unit> onClick) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void NumberCorrectAnswerParticles() {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void NumberParticle(androidx.compose.animation.core.Animatable<java.lang.Float, androidx.compose.animation.core.AnimationVector1D> anim) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void NumberQuizEndDialog(androidx.navigation.NavController navController, int score, kotlin.jvm.functions.Function0<kotlin.Unit> onRestart) {
    }
    
    private static final com.example.educationalapp.NumberQuizQuestion generateNumberQuestion() {
        return null;
    }
    
    private static final float lerp(float start, float stop, float fraction) {
        return 0.0F;
    }
}