# EducationalApp

This repository contains a complete **Android** educational game application built from scratch using **Kotlin** and **Jetpack Compose**.  The project draws inspiration from the original Flutter app you referenced, but it has been redesigned to be lightweight, easy to understand and extend, and to run natively on Android devices.

> **Important upgrade**: The latest version of the app is now called **LUMEA ALESSIEI**.  The main menu features a vertical animated title that cycles through pastel colours.  Each main section button displays a hand‑painted icon (generated to evoke a 2‑year‑old’s fairy‑tale world) alongside its label.  A home button appears in the top bar on every screen except the main menu, allowing children to quickly return to the start.

## Features

The app includes a main menu and **sixteen** mini‑games and creative activities designed to entertain and educate children while keeping the codebase approachable.  Each mini‑game awards stars for correct answers, and the star count is displayed in the main menu.  In this upgraded version the star counter animates smoothly whenever your total increases, and many screens include animations (scaling, colour transitions, page turns) to provide positive feedback.  Several new modules go beyond quizzes and puzzles into expressive play and social‑emotional learning.

### Mini‑games and activities included

1. **Quiz Alfabet** – find the correct letter among three options.
2. **Quiz Numere** – find the correct number among three options.
3. **Potrivire Culori** – choose the coloured box that matches the displayed colour name.
4. **Potrivire Forme** – identify shapes (circle, square, triangle) drawn using Compose.
5. **Puzzle Simplu** – a 3×3 sliding puzzle; drag tiles by tapping to solve the grid.
6. **Joc de Memorie** – match pairs of emoji cards in a memory game.
7. **Sunete Animale** – match the animal emoji to its name.
8. **Instrument Xilofon** – tap colourful bars to play simple tones (using `ToneGenerator`).
9. **Joc Sortare** – click numbers in ascending order to clear the list.
10. **Joc Labirint** – move a hero through a small maze to the exit using on‑screen arrows.

11. **Quiz Matematic** – solve simple addition, subtraction and multiplication problems.  Like the number and alphabet quizzes, it offers three answer options and tracks your score.

12. **Memorie Secvențe** – remember and reproduce increasingly long sequences of colours.  The sequence is shown via animated colour highlights and grows longer with each success, encouraging progressive challenge.

13. **Carte Interactivă** – a short story told over multiple pages with animated transitions.  Children tap to turn pages and earn stars when they complete the story.
14. **Desen și Colorează** – a drawing canvas with a palette of colours.  Children can freely draw and clear the canvas; after they explore the tools they are rewarded with stars.
15. **Creează Avatar** – design your own cartoon face by choosing hair colour, eye style and mouth shape.  Saving your first avatar awards three stars.  The face drawing updates smoothly using Compose Canvas and animated transitions.
16. **Album de Stickere** – collect a set of fun emoji stickers.  Stickers unlock automatically when you earn enough stars; locked stickers appear greyed out with a lock icon.
17. **Panou Sunete Animale** – a sound board of animal buttons.  Tap a button to play the corresponding animal sound; after exploring five different sounds you earn a star.  (The project includes placeholder `.wav` files; replace them in `res/raw` with real animal sounds.)
18. **Joc Emoții** – practise recognising basic emotions.  The game names an emotion (fericit, trist, surprins, furios, speriat) and shows three faces; choose the correct face to earn points and stars.

These additions respond to what parents and children find engaging in popular toddler apps.  Reviews of top toddler apps highlight features like **sing‑alongs, art exercises and a “feelings photo booth” that lets kids explore expressions**【607905815169123†L373-L380】.  Simple games that involve **balloon‑popping, playing virtual instruments, jack‑in‑the‑box animations and animal sounds** are also praised for their interactivity【607905815169123†L397-L401】.  Another highly rated app lets kids **drag characters into everyday scenes and tap items to learn new words**【607905815169123†L442-L451】.  Inspired by these trends, the upgraded version of our app adds creative outlets (drawing and avatar design), a sticker collection system for long‑term motivation, a sound board for auditory exploration, and an emotions game that encourages social‑emotional learning.

Each mini‑game is self‑contained in its own Composable file under `app/src/main/java/com/example/educationalapp`.  The navigation between screens is managed with `NavHost` in `AppNavigation.kt`, and the global star counter is maintained via a `MutableState` in `MainActivity`.  The new games demonstrate the use of Compose animations (`animateIntAsState`, `Animatable`) to animate the star count and highlight sequence colours.

## How to build and run

> **Note**: This project is meant as a starting point.  It compiles on a standard Android development environment with Kotlin 1.9 and Android Gradle Plugin 8.1.  If you wish to run or extend it, follow these steps:

1. **Install Android Studio** (Giraffe or later) with the required SDKs (API 33 or newer) and Compose support.
2. Clone or extract this repository to your machine.
3. Open the project in Android Studio.  The IDE will synchronise Gradle dependencies (`navigation-compose`, `material3`, etc.).
4. Connect an Android device or launch an emulator.
5. Build and run the `app` module.  The main menu appears on launch.  Use the buttons to navigate between mini‑games.

## Extending the app

The project is intentionally modular.  You can add new mini‑games by:

1. Creating a new Composable function and corresponding screen route in `AppNavigation.kt`.
2. Implementing the game logic inside that Composable.
3. Adding a button in `MainMenuScreen.kt` that navigates to your new route.

The current mini‑games illustrate a variety of Compose patterns: lists and grids, custom drawing with `Canvas`, interactive gestures, simple animations, and tone generation.  Use them as templates to implement more complex games.

## Design considerations

When developing educational games for children, keep the following guidelines in mind:

* **Simple and engaging UI** – use bright colours and playful graphics, and avoid clutter.  Ensure navigation is intuitive and reachable by small hands.  Use positive feedback (stars, badges) to reward correct actions【446890643193138†L88-L94】.
* **Age‑appropriate content** – tailor the difficulty and themes to the target age group and provide different levels if necessary【446890643193138†L96-L101】.
* **Balance learning and fun** – integrate educational elements seamlessly into gameplay so that learning feels like part of the game【446890643193138†L72-L80】.
* **Iterative testing and improvement** – prototype and test with real users (children and parents) to gather feedback and refine the experience【446890643193138†L132-L136】.

The latest upgrade reflects findings from research on educational games and from evaluations of popular toddler apps.  Gamification elements like feedback, points and badges motivate learners and should be combined with progressing challenge levels【612315182622252†L114-L138】【612315182622252†L230-L238】.  Apps favoured by parents often blend games with **songs, art activities and social‑emotional exercises**【607905815169123†L373-L380】【607905815169123†L397-L401】.  By adding drawing, avatar creation, sticker collecting, a sound board and an emotions game, the project broadens its appeal beyond simple quizzes and puzzles while adhering to age‑appropriate design.

In addition, research into gamification emphasises the importance of **feedback, points and badges** to motivate learners【612315182622252†L114-L138】 and recommends adjusting challenge levels to keep players engaged【612315182622252†L230-L238】.  The star system and progressive difficulty in the sequence memory game are designed with these principles in mind.

The current project provides a foundation adhering to these principles.  Feel free to modify the visuals (colours, fonts, icons) and add audio or haptic feedback to enhance the user experience.