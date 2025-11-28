package com.example.educationalapp

sealed class Screen(val route: String) {
    object MainMenu : Screen("main_menu")
    object GamesMenu : Screen("games")
    object InstrumentsMenu : Screen("instruments")
    object SongsMenu : Screen("songs")
    object SoundsMenu : Screen("sounds")
    object StoriesMenu : Screen("stories")
    object Paywall : Screen("paywall")
    object SettingsScreen : Screen("settings")

    // Game routes
    object AlphabetQuiz : Screen("alphabet_quiz")
    object MathGame : Screen("math_game")
    object ColorMatch : Screen("color_match")
    object ShapeMatch : Screen("shape_match")
    object Puzzle : Screen("puzzle")
    object MemoryGame : Screen("memory_game")
    object AnimalSortingGame : Screen("animal_sorting_game")
    object CookingGame : Screen("cooking_game")
    object InstrumentsGame : Screen("instruments_game")
    object BlocksGame : Screen("blocks_game")
    object MazeGame : Screen("maze_game")

    // Story routes
    object StoryBook : Screen("story_book")

    // Other routes
    object ParentalGate : Screen("parental_gate")
}
