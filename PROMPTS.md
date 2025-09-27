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


## Avatare Copii
- `avatar_fetita_1.png`, `avatar_baiat_1.png`, `avatar_fetita_2.png`, `avatar_baiat_2.png`
  *Stil:* jucărie 3D Pixar, prietenoasă, expresie veselă, fundal transparent, 1024x1024.

## Stickere Recompensă
- Nume format: `<instrument>-<icon>.png`, de ex: `piano-star.png`, `drums-note.png`, `xylophone-crown.png`, `organ-heart.png`.
  *Stil:* autocolant lucios, contur alb, umbră discretă, fundal transparent, 512x512.

## Teme sezoniere (fundaluri opționale)
- `bg_spring.png`, `bg_summer.png`, `bg_autumn.png`, `bg_winter.png` (16:9)
  *Stil:* parallax 2.5D Pixar. Pot fi folosite pe Home în locul placeholder-ului.

## Songs (segmente/stems) pentru Player Avansat
Pentru fiecare piesă, livrează **stems** scurte care se pot bucla fluid:
- Exemplu „Tema Alesia”:
  - `bg_intro.mp3` (~10s), `bg_main.mp3` (~40s loop-safe), `bg_outro.mp3` (~8s).
- Exemplu „Valsul Stelelor”:
  - `song1_intro.mp3` (~8s), `song1_A.mp3` (~32s loop-safe), `song1_B.mp3` (~32s loop-safe), `song1_outro.mp3` (~8s).

## Stories JSON
Format de bază:
```json
{
  "nodes": [
    {"id":"start","subtitle":"Text...","image":"final/story_start.png","audioId":"story_start","choices":[{"text":"Spre...","nextId":"castle"}]}
  ]
}
```


## Story Pack
- structura pachet `.alesia_story` (ZIP): `story.json` + (opțional) `images/*.png`, `audio/*.mp3`.
- Backlog: suport pentru import/export media (în afara bundle-ului).
