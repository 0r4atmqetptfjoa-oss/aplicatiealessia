# Alesia — Aplicație Educațională pentru Copii

Proiect Flutter complet, cu **Flame**, **go_router**, **SoLoud**, **Rive** (fallback pe PNG), **flutter_animate** și **Editor Vizual de Povești**.

## Rulare
```bash
flutter pub get
flutter run
```

## Rive
Dacă adaugi `assets/rive/zana_melodia.riv`, poți înlocui placeholder-ul din `ZanaMelodiaOverlay` cu `RiveAnimation.asset(...)`.

## Editor Vizual de Povești
- Rutează la: `/povesti-editor-vizual` (apare și în meniul „Jocuri”).
- Funții: selectare multiplă (dreptunghi), mutare în grup, ștergere, **undo/redo**, **auto-layout**, **validator** (cicluri, noduri inaccesibile, ținte lipsă, lipsă terminale), **export/import layout JSON**, **export snapshot** (graph+layout) în Documents.

## TODO (Răzvan)
Caută comentariile `// TODO (Răzvan): ...` pentru a înlocui placeholderele cu resursele finale.
