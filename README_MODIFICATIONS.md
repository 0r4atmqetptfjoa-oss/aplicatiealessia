# Modificări și actualizări propuse

Acest pachet conține fișiere modificate și noi pentru aplicația **Lumea Alessiei** pentru a integra jocurile și conținutul extins. Sunt incluse doar fișierele care au fost actualizate sau adăugate, menținând aceeași structură de directoare ca în proiectul original.

## Rezumat modificări

- **Rute noi pentru jocuri**: `lib/src/core/router/app_router.dart` a fost actualizat pentru a include rute dedicate pentru toate jocurile listate în `assets/data/games.json`.
- **Ecrane de joc**: au fost adăugate fișiere placeholder pentru noile jocuri (Memory, Shapes, Colors, Math Quiz, Puzzle 2, Instruments, Sorting Animals, Cooking, Maze, Hidden Objects, Blocks), fiecare cu un widget simplu care afișează „Under Construction”.
- **Meniul de cântece**: `lib/src/features/songs/songs_menu_screen.dart` returnează acum titlul melodiilor direct din JSON, fără a depinde de localizări inexistente pentru cântecele noi.
- **Meniul de povești**: `lib/src/features/stories/stories_menu_screen.dart` afișează titlurile poveștilor exact așa cum apar în `stories.json`.
- **Player-ul de povești**: `lib/src/features/stories/story_player_screen.dart` a fost modificat pentru a încărca videoclipurile din `assets/video/stories/<id>.mp4`.
- **Fișierul `pubspec.yaml`** include acum noile directoare `assets/audio/songs/`, `assets/video/cantece/` și `assets/video/stories/` pentru a asigura includerea fișierelor audio/video ale melodiilor și poveștilor.
- **Fișiere JSON actualizate**: `assets/data/games.json`, `songs.json` și `stories.json` sunt incluse pentru referință.

## Cum se utilizează
Înlocuiți fișierele din proiectul original cu cele din acest pachet în aceleași locații. Dacă proiectul folosește alte structuri de directoare sau fișiere suplimentare, asigurați-vă că păstrați aceste modificări în concordanță. După copiere, actualizați animațiile Rive, fișierele audio/video reale și localizările conform cerințelor aplicației.

Aceste modificări permit aplicației să afișeze corect toate jocurile, poveștile și melodiile din fișierele de date și să prevină erorile „Page not found”.
