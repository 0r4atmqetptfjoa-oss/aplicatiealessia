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

## Cum se adaugă Resursele Vizuale și Audio

Acest proiect folosește imagini, sunete și animații **placeholder**. Pentru a adăuga resursele finale, urmează acești pași:

1. **Generează Resursele:** Folosește uneltele AI preferate pentru a genera toate resursele, conform descrierilor detaliate din fișierul `PROMPTS.md`.
2. **Plasează Fișierele:**
   - Imaginile (`.png`) în `assets/images/final/`.
   - Animațiile Rive (`.riv`) în `assets/rive/`.
   - **Sunetele instrumentelor** în:
     - Pian: `assets/audio/final/piano/C4.mp3` ... `B4.mp3`
     - Xilofon: `assets/audio/final/xylophone/1.mp3` ... `8.mp3`
     - Tobe: `assets/audio/final/drums/kick.mp3`, `snare.mp3`, `hihat_closed.mp3`, `hihat_open.mp3`
     - Orgă: `assets/audio/final/organ/S1.mp3` ... `S5.mp3`
3. **Actualizează Codul:** Caută comentariile `// TODO (Răzvan):` pentru locurile unde trebuie înlocuite căile asset-elor.

> Notă: Dacă fișierele audio lipsesc, jocurile rulează în continuare, redând un sunet placeholder (sau tăcere), astfel încât integrarea artistică să poată fi făcută incremental.


## Ce include FAZA 4
- **Profile copii** (selectare/gestionare).
- **Control parental** cu PIN și **Panou Părinți** (analitice on-device, setări, teme sezoniere).
- **Questuri pe nivele** cu progres persistent.
- **UI cu teme sezoniere** (auto sau override din panou).

### Cum accesezi
- Din **Home**: butoanele **Profil**, **Părinți**, **Questuri**, **Recompense**.
- **Părinți** cere PIN (default `1234`, modificabil din panou).


## Ce include FAZA 7
- **Analyzer audio real (FFT)** folosind `flutter_soloud` → `AudioData` (linear: FFT+wave), smoothing și vizualizări: **benzi** + **particule** sincron.
- **Story Packages**: export/import `.alesia_story` (JSON + manifest) din Zona Părinți.
- **Profil Dashboard**: grafic comparativ săptămână curentă vs. anterioară.
- **Experimente UI (A/B)**: „Coach Hints” (sticky vs dismissable) + player Songs (classic vs compact).
