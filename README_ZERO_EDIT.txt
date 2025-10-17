APLICATIE ALESSIA — ZERO-EDIT PACK
==================================
Acest pachet elimina dependintele de `flutter_gen` si `firebase_options.dart`.
Nu trebuie sa editezi NIMIC.

PASII:
1) Dezarhiveaza ZIP-ul in radacina proiectului (acelasi folder cu `pubspec.yaml`) si permite overwrite pentru fisierele existente.
2) Ruleaza:
   flutter clean
   flutter pub get
   flutter run

Ce se schimba:
- Folosim `lib/l10n/app_localizations.dart` (implementare simpla) in loc de `package:flutter_gen/...`.
- `main.dart` NU mai initializeaza Firebase (poti adauga ulterior la nevoie).
- `ParentalGate` foloseste `Listener` in loc de `onPointerDown` pe `GestureDetector`.
