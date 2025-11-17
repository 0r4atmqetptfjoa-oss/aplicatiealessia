package com.example.educationalapp;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u0000\u001a\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\b\u0002\u001a&\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u00052\u0006\u0010\u0007\u001a\u00020\u0006H\u0007\u00a8\u0006\b"}, d2 = {"SongPlayerScreen", "", "navController", "Landroidx/navigation/NavController;", "starState", "Landroidx/compose/runtime/MutableState;", "", "songId", "app_debug"})
public final class SongPlayerScreenKt {
    
    /**
     * Screen for playing a selected song.  Uses MediaPlayer to play an audio
     * resource stored in res/raw.  When the song completes, the player awards
     * one star.
     *
     * @param songId Index of the song selected in the SongsMenuScreen.
     */
    @androidx.compose.runtime.Composable()
    public static final void SongPlayerScreen(@org.jetbrains.annotations.NotNull()
    androidx.navigation.NavController navController, @org.jetbrains.annotations.NotNull()
    androidx.compose.runtime.MutableState<java.lang.Integer> starState, int songId) {
    }
}