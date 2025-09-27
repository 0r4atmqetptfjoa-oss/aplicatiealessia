# Alesia - Aplicație Educațională pentru Copii

Bun venit la proiectul "Alesia"! Acesta este scheletul complet funcțional al aplicației, construit pe o arhitectură modernă cu Flutter și Flame, gata pentru a fi populat cu resurse artistice.

## Viziune

Alesia este o aplicație premium, cu un design inspirat de stilul artistic Pixar, menită să ofere copiilor o experiență de învățare și joacă magică, sigură și interactivă.

## Cum se adaugă Resursele Vizuale

Acest proiect folosește imagini, sunete și animații **placeholder**. Pentru a adăuga resursele finale, urmează acești pași:

1.  **Generează Resursele:** Folosește uneltele AI preferate pentru a genera toate resursele, conform descrierilor detaliate din fișierul `PROMPTS.md`.
2.  **Plasează Fișierele:**
    * Imaginile (`.png`) se adaugă în folderul `assets/images/final/`.
    * Animațiile Rive (`.riv`) se adaugă în `assets/rive/`.
    * Fișierele audio (`.mp3`, `.wav`) se adaugă într-un folder nou `assets/audio/final/`.
3.  **Actualizează Codul:** Caută în proiect comentariile `// TODO (Răzvan):`. Fiecare comentariu îți va indica exact ce cale de fișier trebuie să actualizezi.


## Ce include FAZA 4
- **Profile** multiple pentru copii (nume, culoare, avatar).
- **Control Parental** cu PIN (implicit 1234), setări accesibile din Home (buton lacăt).
- **Analytics on-device** (evenimente locale, vizualizare și ștergere).
- **Mini-questuri** pe instrumente (prima reușită, streak 3, streak 5) – cu recompense.
- **Teme sezoniere** care schimbă paleta UI (primăvară/vară/toamnă/iarnă).

## Ce include FAZA 6
- **Player „Songs” avansat** cu segmente (Intro/Main/Outro), crossfade, timeline cu marcaje și vizualizator pseudo‑FFT.
- **Stories – Editor JSON**: import/export `.json`, previzualizare imediată.
- **Telemetrie**: grafice simple în Analiză.
- **A/B Test on‑device**: varianta de bounce în Home (A/B) setabilă din Zona Părinți.


## Ce include FAZA 7
- **Analyzer audio (FFT-like, placeholder)** + **vizualizator în timp real** cu benzi colorate.  
  _TODO_: conectează un PCM tap din `flutter_soloud` pentru FFT real.
- **Story Pack (.alesia_story)**: export/import JSON de poveste; pregătit pentru extensie cu media.
- **Dashboard pe profil**: grafic bară săptămâna curentă vs. precedentă pentru fiecare instrument.
- **Sticky Coach Hints (A/B)**: infrastructură în `RhythmOverlay` cu experiment `CoachHints`.
