package com.example.educationalapp;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u0002\n\u0002\b\u0006\b\u0007\u0018\u00002\u00020\u0001B\u0007\b\u0007\u00a2\u0006\u0002\u0010\u0002J\u000e\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\nJ\u0006\u0010\u001a\u001a\u00020\u0018J\u0006\u0010\u001b\u001a\u00020\u0018J\u0006\u0010\u001c\u001a\u00020\u0018J\u0006\u0010\u001d\u001a\u00020\u0018R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0014\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0014\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0014\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\n0\u0004X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0017\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00050\f8F\u00a2\u0006\u0006\u001a\u0004\b\r\u0010\u000eR\u0017\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00050\f8F\u00a2\u0006\u0006\u001a\u0004\b\u0010\u0010\u000eR\u0017\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00050\f8F\u00a2\u0006\u0006\u001a\u0004\b\u0012\u0010\u000eR\u0017\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00050\f8F\u00a2\u0006\u0006\u001a\u0004\b\u0014\u0010\u000eR\u0017\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\n0\f8F\u00a2\u0006\u0006\u001a\u0004\b\u0016\u0010\u000e\u00a8\u0006\u001e"}, d2 = {"Lcom/example/educationalapp/MainViewModel;", "Landroidx/lifecycle/ViewModel;", "()V", "_hardModeEnabled", "Lkotlinx/coroutines/flow/MutableStateFlow;", "", "_hasFullVersion", "_musicEnabled", "_soundEnabled", "_starCount", "", "hardModeEnabled", "Lkotlinx/coroutines/flow/StateFlow;", "getHardModeEnabled", "()Lkotlinx/coroutines/flow/StateFlow;", "hasFullVersion", "getHasFullVersion", "musicEnabled", "getMusicEnabled", "soundEnabled", "getSoundEnabled", "starCount", "getStarCount", "setStarCount", "", "count", "toggleFullVersion", "toggleHardMode", "toggleMusic", "toggleSound", "app_debug"})
@dagger.hilt.android.lifecycle.HiltViewModel()
public final class MainViewModel extends androidx.lifecycle.ViewModel {
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.lang.Integer> _starCount = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.lang.Boolean> _hasFullVersion = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.lang.Boolean> _soundEnabled = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.lang.Boolean> _musicEnabled = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.lang.Boolean> _hardModeEnabled = null;
    
    @javax.inject.Inject()
    public MainViewModel() {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.lang.Integer> getStarCount() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.lang.Boolean> getHasFullVersion() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.lang.Boolean> getSoundEnabled() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.lang.Boolean> getMusicEnabled() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.lang.Boolean> getHardModeEnabled() {
        return null;
    }
    
    public final void setStarCount(int count) {
    }
    
    public final void toggleFullVersion() {
    }
    
    public final void toggleSound() {
    }
    
    public final void toggleMusic() {
    }
    
    public final void toggleHardMode() {
    }
}