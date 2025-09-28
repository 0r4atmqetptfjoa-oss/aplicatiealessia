# Alesia — build cu Rive binding + preloader + metronom în overlay
- `ZanaMelodiaOverlay` comută între PNG și Rive automat și leagă animații după nume (`idle`, `dance_slow`, `dance_fast`, `ending_pose`).
- `AudioService.preload()` în `main.dart` preîncarcă sunetele (dacă există).
- Toggle metronom atât în `RhythmOverlay`, cât și în `ZanaMelodiaOverlay`.
