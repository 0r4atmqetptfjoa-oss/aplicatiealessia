package com.example.educationalapp;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u00002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0007\u001a*\u0010\u0000\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00010\u0006H\u0003\u001a\u0018\u0010\u0007\u001a\u00020\u00012\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u0004H\u0003\u001a3\u0010\u000b\u001a\u00020\u00012\u0006\u0010\b\u001a\u00020\t2!\u0010\f\u001a\u001d\u0012\u0013\u0012\u00110\u0004\u00a2\u0006\f\b\r\u0012\b\b\u000e\u0012\u0004\b\b(\u000f\u0012\u0004\u0012\u00020\u00010\u0006H\u0007\u001a\u0016\u0010\u0010\u001a\u00020\u00112\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003H\u0002\u001a\u000e\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003H\u0002\u001a\u0018\u0010\u0013\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u00042\u0006\u0010\u0015\u001a\u00020\u0004H\u0002\u001a\u0016\u0010\u0016\u001a\u00020\u00112\f\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003H\u0002\u00a8\u0006\u0018"}, d2 = {"PuzzleGrid", "", "tiles", "", "", "onTileClick", "Lkotlin/Function1;", "PuzzleHeader", "navController", "Landroidx/navigation/NavController;", "moves", "PuzzleScreen", "onGameWon", "Lkotlin/ParameterName;", "name", "stars", "checkIfSolved", "", "generateSolvablePuzzle", "isAdjacent", "index1", "index2", "isSolvable", "puzzle", "app_debug"})
public final class PuzzleScreenKt {
    
    @androidx.compose.runtime.Composable()
    public static final void PuzzleScreen(@org.jetbrains.annotations.NotNull()
    androidx.navigation.NavController navController, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super java.lang.Integer, kotlin.Unit> onGameWon) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void PuzzleHeader(androidx.navigation.NavController navController, int moves) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void PuzzleGrid(java.util.List<java.lang.Integer> tiles, kotlin.jvm.functions.Function1<? super java.lang.Integer, kotlin.Unit> onTileClick) {
    }
    
    private static final java.util.List<java.lang.Integer> generateSolvablePuzzle() {
        return null;
    }
    
    private static final boolean isSolvable(java.util.List<java.lang.Integer> puzzle) {
        return false;
    }
    
    private static final boolean isAdjacent(int index1, int index2) {
        return false;
    }
    
    private static final boolean checkIfSolved(java.util.List<java.lang.Integer> tiles) {
        return false;
    }
}