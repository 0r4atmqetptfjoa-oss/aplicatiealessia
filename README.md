# Alesia - Aplicație Educațională pentru Copii

Bun venit la proiectul **Alesia**! Acesta este scheletul complet funcțional al aplicației, construit pe o arhitectură modernă cu Flutter și Flame, gata pentru a fi populat cu resurse artistice.

## Viziune

Alesia este o aplicație premium, cu un design inspirat de stilul artistic Pixar, menită să ofere copiilor o experiență de învățare și joacă magică, sigură și interactivă.

## Cum se adaugă Resursele Vizuale

Acest proiect folosește imagini, sunete și animații **placeholder**. Pentru a adăuga resursele finale, urmează acești pași:

1. **Generează Resursele:** Folosește uneltele AI preferate pentru a genera toate resursele, conform descrierilor detaliate din fișierul `PROMPTS.md`.
2. **Plasează Fișierele:**
   - Imaginile (`.png`) se adaugă în folderul `assets/images/final/`.
   - Animațiile Rive (`.riv`) se adaugă în `assets/rive/`.
   - Fișierele audio (`.mp3`, `.wav`) se adaugă într-un folder nou `assets/audio/final/`.
3. **Actualizează Codul:** Caută în proiect comentariile `// TODO (Răzvan):`. Fiecare comentariu îți va indica exact ce cale de fișier trebuie să actualizezi.

## Rulare rapidă

```bash
flutter pub get
flutter run
```

> **Notă:** Fișierele `.riv` și `.mp3` din acest pachet sunt *placeholdere* goale; e normal ca unele animații/audio să nu pornească până nu sunt înlocuite cu resurse reale.


## Faza 2 (audio & gameplay)
- Note reale generate cu **flutter_soloud** (tonuri sintetizate, fără fișiere audio).
- Modul *Secvență Ritmică* pe toate instrumentele (Simon-like) cu HUD.
- Particule „confetti” la reușită și efecte de tremur la greșeli.
- Integrare **Rive** (flame_rive) pentru „Zâna Melodia” în jocuri (placeholder `.riv`).
