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

### Sunete (calitate 48kHz, 24-bit, mono)
- **Pian:** `C4.mp3` ... `B4.mp3` – "Note de pian jucăuș, atac moale, sustain scurt, caracter cald, fără zgomot de mecanică."
- **Xilofon:** `1.mp3` ... `8.mp3` – "Bări de xilofon din lemn lăcuit, atac clar, decay natural, fără reverberații exagerate."
- **Tobe:** `kick.mp3`, `snare.mp3`, `hihat_closed.mp3`, `hihat_open.mp3` – "Sunete curate, prietenoase pentru copii, fără agresivitate, mix balansat."
- **Orgă:** `S1.mp3` ... `S5.mp3` – "Tonuri calde, ușoare, cu un vibrato discret, stil orgă jucărie."
> Export: normalizați la -3 LUFS, fade-in/out de 5ms pentru a evita click-uri.

## Modulul Cântece
- **`fundal_scena.png`**: "O scenă de teatru de păpuși magică, cu podea de lemn și cortină de catifea roșie, stil Pixar."
- **`zana_melodia.riv`**: "Personaj 2D, 'Zâna Melodia', stil Pixar, pentru Rive. Mașină de stări cu animații: `idle` (plutire lentă), `dance_slow`, `dance_fast`, `ending_pose` (reverență)."

## Modulul Sunete
- **`harta_interactiva.png`**: "O hartă de explorat dintr-un joc pentru copii, cu 3 zone: fermă, junglă, oraș, stil Pixar."
- **Iconițe (6 PNG-uri transparente):** `vaca.png`, `leu.png`, `masina.png`, `pisica.png`, `maimuta.png`, `ambulanta.png` - "Iconiță 3D, stil jucărie Pixar, a animalului/obiectului specificat."


## Stickere (colecție)
- `sticker_01.png` ... `sticker_12.png`: "Pictograme adorabile, 3D, stil jucărie Pixar (muzică, note, inimioare, stele, animale muzicale), fundal transparent, margine ușor luminoasă."

## Audio suplimentar
- `tick.mp3`: metronom click moale, 0.05–0.1s, fără reverb.
- `bg_music.mp3`: buclă muzicală lină, 60–90 BPM, instrumente calde, volum redus, fără părți bruște.


## Profile Copii (Avataruri)
- `avatar_boy.png`, `avatar_girl.png`, `avatar_baby.png`, `avatar_robot.png`: "Avatar 3D stil jucărie Pixar, fundal transparent, expresie veselă."

## Iconografie Panou Părinți
- `icon_parents.png`: "Pictogramă stil UI, părinți stilizați, linie curată, prietenoasă."

## Stickere suplimentare (recompense)
- `sticker_star.png`, `sticker_note.png`, `sticker_heart.png`, `sticker_shell.png`, `sticker_sparkle.png`, `sticker_flower.png`, `sticker_smile.png`, `sticker_crown.png`

## Elemente Sezoniere (teme)
- `home_winter_overlay.png`, `home_halloween_overlay.png`, `home_holidays_overlay.png`: "Layer ușor, motive sezoniere (fulgi, dovleci, luminițe) pe fundal transparent."


## Story Package
- La export se creează `story.json` (+ `manifest.json`). Pentru pachetele create în afara aplicației, includeți în ZIP:
  - `story.json` (schema în `StoryService`)
  - Imagini `story_*.png` 16:9 (min 1920x1080, stil Pixar)
  - Audio `story_*.mp3` (narator + FX opționale)
