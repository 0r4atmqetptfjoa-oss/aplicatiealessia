# Alesia: Lista de Prompturi pentru Generarea Resurselor (Stil Pixar 2.5D)

## Meniul Principal (HomeScreen)
### Fundal Parallax (3 imagini 16:9, PNG)
- **`parallax_back.png`**: "Un cer de amurg, cu nori pufoși și culori calde de portocaliu și violet, stil Pixar."
- **`parallax_middle.png`** (fundal transparent): "Silueta unui castel de basm pe un deal îndepărtat, stil Pixar."
- **`parallax_front.png`** (fundal transparent): "Un deal verde, luxuriant, cu câțiva copaci prietenoși și flori colorate în prim-plan, stil Pixar."

### Butoane Tematice (5 sprite-uri 1x1, PNG transparent)
*Prompt General:* "Generează un sprite individual, 3D, stil jucărie de plastic lucios Pixar, cu colțuri rotunjite și reflexii calde:"
1.  **`harp.png`**: O harpă de aur.
2.  **`music_box.png`**: O cutiuță muzicală roșie cu o balerină aurie.
3.  **`story_book.png`**: O carte de povești groasă, cu o copertă fantezistă.
4.  **`play_cube.png`**: Un cub de joacă colorat cu litera 'A' vizibilă.
5.  **`seashell.png`**: O scoică portocalie sidefată.

## Modulul Instrumente
### Fundaluri (4 imagini 16:9, PNG)
1.  **`fundal_pian.png` / `fundal_xilofon.png`**: "O podea de lemn curată și un perete în degrade de culori calde, cu un efect subtil de lumină bokeh în spate, stil scenă de studio Pixar."
2.  **`fundal_tobe.png`**: "O cameră de joacă vibrantă și colorată, cu un covor pufos pe jos, stil Pixar."
3.  **`fundal_orga.png`**: "Un peisaj subacvatic magic, cu raze de lumină, corali colorați și peștișori, stil Pixar."

### Componente Instrumente (PNG-uri transparente, individuale)
1.  **Pian (7 fișiere):** `clapa_rosie.png`, `clapa_portocalie.png`, etc. - "O singură clapă de pian 3D, stil jucărie de plastic lucios și rotunjit, în culoarea specificată."
2.  **Tobe (4 fișiere):** `toba_rosie.png`, etc. - "Un singur pad de tobă 3D, stil jucărie rotundă și moale din plastic mat, în culoarea specificată."
3.  **Xilofon (8 fișiere):** `bara_1.png`, etc. - "O singură bară de xilofon 3D, stil lemn lăcuit în culori pastelate, cu o strălucire caldă."
4.  **Orgă (5 fișiere):** `scoica_1.png`, etc. - "O singură clapă 3D în formă de scoică sidefată, în culori pastelate acvatice."

## Modulul Cântece
- **`fundal_scena.png`**: "O scenă de teatru de păpuși magică, cu podea de lemn și cortină de catifea roșie, stil Pixar."
- **`zana_melodia.riv`**: "Personaj 2D, 'Zâna Melodia', stil Pixar, pentru Rive. Mașină de stări cu animații: `idle` (plutire lentă), `dance_slow`, `dance_fast`, `ending_pose` (reverență)."

## Modulul Sunete
- **`harta_interactiva.png`**: "O hartă de explorat dintr-un joc pentru copii, cu 3 zone: fermă, junglă, oraș, stil Pixar."
- **Iconițe (6 PNG-uri transparente):** `vaca.png`, `leu.png`, `masina.png`, `pisica.png`, `maimuta.png`, `ambulanta.png` - "Iconiță 3D, stil jucărie Pixar, a animalului/obiectului specificat."


## Audio (Note Reale)
Generează sample-uri .mp3 (mono, 44.1kHz, ~0.3–0.6s, fără reverb) pentru notele:
`C4, D4, E4, F4, G4, A4, B4` (naming exact ca în listă).

*Prompt sugerat (sinteză caldă, jucăușă, stil jucărie muzicală Pixar):*
> "Generate a clean, bright, child-friendly toy piano tone for the note {NOTE_NAME} (C4/A4 etc.), 0.5 seconds, soft attack, gentle decay, harmonics slightly rounded, no background noise, mono 44.1kHz."

Plasează fișierele în: `assets/audio/final/notes/` și lasă extensia `.mp3`.


## Avatare Copii
- `avatar_1.png` ... `avatar_6.png`: "Cap portret copil stil Pixar, zâmbitor, culori calde; fundal simplu, PNG transparent, 512x512."

## Stickere pentru Questuri
- `sticker_star.png`, `sticker_crown.png`, `sticker_note.png`, `sticker_sparkle.png`: "Sticker 3D lucios, stil jucărie Pixar, cu margine albă pentru decupaj."


## Dirijor (Rive)
- `zana_melodia.riv`: animații suplimentare: `cue_intro`, `cue_transition`, `cue_finale`.


## Playlist JSON
- `assets/songs/playlist.json`: listă de piese cu câmpurile: `id`, `title`, `durationSec`, `bpm`, `markers: [{label, timeSec}]`.

## Stories JSON
- `assets/stories/sample_story.json`: listă de noduri `{id, subtitle, audioId, choices:[{text, nextId}]}`.  
  Exportă/importă din editorul integrat (Zona Părinți → Stories JSON).

## Conductor / Vizualizator
- `conductor.riv` (opțional, pentru viitor): animații `idle`, `cue`, `fanfare`. Integrare facilă în ecranul Songs (înlocuiește vizualizatorul).


## Story Pack (.alesia_story)
- Pachet ZIP care conține `manifest.json` (graful poveștii + mapările de asset-uri).
- În această fază, binarele nu sunt incluse; `manifest.json` map-ează ID-uri la fișiere locale. (Extensie viitoare: includerea fișierelor în pachet.)
- Denumiri recomandate pentru audio narator: `story_<nodeId>.mp3`. Imagini: `story_<nodeId>.png`.


## Mini-joc validare poveste
- Pentru nodurile care cer imagini/audio, asigură-te că fișierele respectă convenția `story_<id>.png` / `story_<id>.mp3`.
- Pentru thumbnails mai lizibile, exportă PNG-urile la minimum 512px pe latura mică.


## Editor Vizual Povești (Notă pentru Artist)
- Nu sunt necesare resurse noi. Dacă dorești, poți crea un set de 4 fundaluri subtile (SVG/PNG) pentru canvas (grilă moale, puncte, hârtie).
- Culorile nodurilor pot fi variate pe stări (start/terminal/selectat) — momentan folosim Material default.
