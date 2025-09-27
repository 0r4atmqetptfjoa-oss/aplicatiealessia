# Alesia - Aplicație Educațională pentru Copii

Bun venit la proiectul "Alesia"! Acesta este scheletul complet funcțional al aplicației, construit pe o arhitectură modernă cu Flutter și Flame, gata pentru a fi populat cu resurse artistice.

## Viziune

Alesia este o aplicație premium, cu un design inspirat de stilul artistic Pixar, menită să ofere copiilor o experiență de învățare și joacă magică, sigură și interactivă.

## Cum se rulează local
1. Instalează [Flutter](https://flutter.dev) (3.24+).
2. În terminal:
   ```bash
   flutter pub get
   flutter run
   ```

## Cum se adaugă Resursele Vizuale

Acest proiect folosește imagini, sunete și animații **placeholder**. Pentru a adăuga resursele finale, urmează acești pași:

1.  **Generează Resursele:** Folosește uneltele AI preferate pentru a genera toate resursele, conform descrierilor detaliate din fișierul `PROMPTS.md`.
2.  **Plasează Fișierele:**
    * Imaginile (`.png`) se adaugă în folderul `assets/images/final/`.
    * Animațiile Rive (`.riv`) se adaugă în `assets/rive/`.
    * Fișierele audio (`.mp3`, `.wav`) se adaugă într-un folder nou `assets/audio/final/` (sau pot înlocui placeholder-ul).
3.  **Actualizează Codul:** Caută în proiect comentariile `// TODO (Răzvan):`. Fiecare comentariu îți va indica exact ce cale de fișier trebuie să actualizezi.
