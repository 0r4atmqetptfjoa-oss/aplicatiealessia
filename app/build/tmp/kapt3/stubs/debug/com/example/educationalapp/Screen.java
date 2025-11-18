package com.example.educationalapp;

import androidx.compose.runtime.Composable;
import androidx.compose.runtime.MutableState;
import androidx.navigation.NavHostController;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000T\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0013\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b6\u0018\u00002\u00020\u0001:\u0010\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016B\u000f\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006\u0082\u0001\u0010\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&\u00a8\u0006\'"}, d2 = {"Lcom/example/educationalapp/Screen;", "", "route", "", "(Ljava/lang/String;)V", "getRoute", "()Ljava/lang/String;", "AlphabetQuiz", "ColorMatch", "GamesMenu", "InstrumentsMenu", "MainMenu", "MemoryGame", "NumberQuiz", "ParentalGate", "Paywall", "Puzzle", "Settings", "ShapeMatch", "SongsMenu", "SortingGame", "SoundsMenu", "StoriesMenu", "Lcom/example/educationalapp/Screen$AlphabetQuiz;", "Lcom/example/educationalapp/Screen$ColorMatch;", "Lcom/example/educationalapp/Screen$GamesMenu;", "Lcom/example/educationalapp/Screen$InstrumentsMenu;", "Lcom/example/educationalapp/Screen$MainMenu;", "Lcom/example/educationalapp/Screen$MemoryGame;", "Lcom/example/educationalapp/Screen$NumberQuiz;", "Lcom/example/educationalapp/Screen$ParentalGate;", "Lcom/example/educationalapp/Screen$Paywall;", "Lcom/example/educationalapp/Screen$Puzzle;", "Lcom/example/educationalapp/Screen$Settings;", "Lcom/example/educationalapp/Screen$ShapeMatch;", "Lcom/example/educationalapp/Screen$SongsMenu;", "Lcom/example/educationalapp/Screen$SortingGame;", "Lcom/example/educationalapp/Screen$SoundsMenu;", "Lcom/example/educationalapp/Screen$StoriesMenu;", "app_debug"})
public abstract class Screen {
    @org.jetbrains.annotations.NotNull()
    private final java.lang.String route = null;
    
    private Screen(java.lang.String route) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getRoute() {
        return null;
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$AlphabetQuiz;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class AlphabetQuiz extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.AlphabetQuiz INSTANCE = null;
        
        private AlphabetQuiz() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$ColorMatch;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class ColorMatch extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.ColorMatch INSTANCE = null;
        
        private ColorMatch() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$GamesMenu;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class GamesMenu extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.GamesMenu INSTANCE = null;
        
        private GamesMenu() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$InstrumentsMenu;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class InstrumentsMenu extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.InstrumentsMenu INSTANCE = null;
        
        private InstrumentsMenu() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$MainMenu;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class MainMenu extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.MainMenu INSTANCE = null;
        
        private MainMenu() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$MemoryGame;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class MemoryGame extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.MemoryGame INSTANCE = null;
        
        private MemoryGame() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$NumberQuiz;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class NumberQuiz extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.NumberQuiz INSTANCE = null;
        
        private NumberQuiz() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$ParentalGate;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class ParentalGate extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.ParentalGate INSTANCE = null;
        
        private ParentalGate() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$Paywall;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class Paywall extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.Paywall INSTANCE = null;
        
        private Paywall() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$Puzzle;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class Puzzle extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.Puzzle INSTANCE = null;
        
        private Puzzle() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$Settings;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class Settings extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.Settings INSTANCE = null;
        
        private Settings() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$ShapeMatch;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class ShapeMatch extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.ShapeMatch INSTANCE = null;
        
        private ShapeMatch() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$SongsMenu;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class SongsMenu extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.SongsMenu INSTANCE = null;
        
        private SongsMenu() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$SortingGame;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class SortingGame extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.SortingGame INSTANCE = null;
        
        private SortingGame() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$SoundsMenu;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class SoundsMenu extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.SoundsMenu INSTANCE = null;
        
        private SoundsMenu() {
        }
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002\u00a8\u0006\u0003"}, d2 = {"Lcom/example/educationalapp/Screen$StoriesMenu;", "Lcom/example/educationalapp/Screen;", "()V", "app_debug"})
    public static final class StoriesMenu extends com.example.educationalapp.Screen {
        @org.jetbrains.annotations.NotNull()
        public static final com.example.educationalapp.Screen.StoriesMenu INSTANCE = null;
        
        private StoriesMenu() {
        }
    }
}