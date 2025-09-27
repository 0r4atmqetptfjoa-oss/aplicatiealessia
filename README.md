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

## Rulare rapidă

```bash
flutter pub get
flutter run
```


## FAZA 2 – Extinderi (incluse în acest proiect)
- **Note reale (wiring)**: serviciul `NotePlayer` caută fișiere în `assets/audio/final/notes/` (ex: `C4.mp3`). Dacă nu există, redă placeholder.
- **Secvențe ritmice**: `RhythmCoach` evidențiază pad-ul țintă la tempo (bpm) și validează apăsările în fereastra de timp.
- **Recompense**: sistem de combo + particule; best combo vizibil pe ecran.
- **Rive Overlay**: `FairyOverlay` afișează „Zâna Melodia” (sau placeholder) și schimbă animațiile în funcție de combo.


## FAZA 3 (extins)
- Progres & Stickere (persistente cu SharedPreferences)
- Dificultate dinamică în jocul de ritm
- Metronom vizual + tick audio (BPM ajustabil)
- Record & Playback (compoziții simple)
- Ambianță / muzică de fundal (simulată periodic; înlocuiește cu fișiere finale)


## Ce include FAZA 4
- **Profile copii** (multi-profil) cu avatar & nume.
- **Control parental (PIN)** cu gate pentru secțiuni sensibile (Analitice).
- **Analitice on-device** (evenimente cheie, numărate local).
- **Misiuni/Questuri** cu progres, revendicare și stickere-recompensă.
- **Teme sezoniere** (primăvară/vară/toamnă/iarnă) care schimbă paleta UI.


## Ce include FAZA 5
- **PIN părinte** pentru acces la Zona Părinți.
- **Time tracking** zilnic (banner vizibil, limită informativă).
- **Playlist Songs** cu dirijor Rive.
- **Stories interactive** (tap-to-branch) cu subtitrări mari.
- **Backup local** (export/import `.alesia`).


## Ce include FAZA 6
- **Player „Songs” avansat**: timeline cu slider, marcaje (A/B loop), vizualizator „reactiv” (BPM-based).
- **Stories JSON Editor**: import/export/validare JSON + redare în player.
- **Telemetrie cu grafice**: bar chart pe instrument + filtrare pe profil activ; timp total azi.
- **Testare ghidată (AB test)**: asignare A/B on-device pentru efecte (ex. particule, vizualizator), cu metriși locali.

### Note tehnice
- Seeking audio: UI permite scrub, însă integrarea seek-ului real necesită suport direct în pluginul audio (TODO).
- Toate efectele vizuale respectă politica de **placeholder** și pot fi înlocuite cu Rive/imagini finale.


## Ce include FAZA 7
- **Analyzer audio (FFT) cu fallback**: serviciu generic + widget RealtimeSpectrum. Când motorul audio expune FFT/PCM, conectează-l aici.
- **Story Pack**: export/import `.alesia_story` (manifest JSON cu graful poveștii și mapări de asset-uri).
- **Dashboard pe profil**: grafic comparativ săptămână-curentă vs săptămâna-anterioară.
- **A/B „Sticky Coach Hints”**: mesaj persistent (sau nu) deasupra jocului, controlat de `ABTestService`.


## Ce include FAZA 9
- **Waterfall shader-based**: colorizare GPU (ShaderMask cu paletă configurabilă) + blur peste FFT waterfall (grayscale).
- **Preview Pachet**: mini-joc „alege thumbnail corect” pentru verificarea legăturilor nod ↔ resurse.
- **Heatmap 7×24**: raport pe 7 rânduri (zile) × 24 coloane (ore), cu filtre pe perioadă și instrument.
- **Experiment Manager**: resetare asignări A/B + rapoarte locale (song_play / coach_success).


## Ce include FAZA 10
- **Editor Vizual de Povești**: pan/zoom, drag&drop noduri, conectare cu „Connect mode”, auto-layout (BFS), editare rapidă a nodurilor (subtitlu/audio), ștergere sigură.
- **Export PNG**: canvas-ul grafic se exportă ca imagine în Documents (nume `StoryGraph_<timestamp>.png`).
- **Validator Structural**: detectează targete inexistente, noduri inaccesibile din `start`, absența nodurilor terminale.
- **Persistență layout**: pozițiile nodurilor sunt salvate prin `StoryLayoutService` (SharedPreferences).
- **Integrare UI**: Tab nou în Zona Părinți: **„Povești (Editor Vizual)”** + rută `/povesti-editor-vizual`.
