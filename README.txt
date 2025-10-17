APLICATIE ALESSIA — QUICK FIX PACK
==================================

Ce rezolva:
- Eroarea `flutter_gen` (gen l10n): adaugam l10n.yaml si ARB-uri minime + instructiuni de generare.
- Lipsa `firebase_options.dart`: punem guard in main.dart ca sa poti porni app-ul fara Firebase, pana rulezi `flutterfire configure`.
- `onPointerDown` pe GestureDetector: inlocuit cu `Listener`.

Pasii (Windows PowerShell):
1) DESCHIDE in radacina proiectului tau (acelasi folder cu `pubspec.yaml`) si dezarhiveaza continutul ZIP-ului (cu overwrite):
   - lib\main.dart
   - lib\src\features\parental_gate\parental_gate_screen.dart
   - l10n.yaml
   - lib\l10n\app_en.arb
   - lib\l10n\app_ro.arb
   - pubspec_additions.yaml (doar pentru copy-paste manual in `pubspec.yaml`)

2) Deschide `pubspec.yaml` si:
   - Adauga la dependencies:
       flutter_localizations:
         sdk: flutter
   - Asigura-te ca ai:
       flutter:
         generate: true
   (Poti copia din `pubspec_additions.yaml`)

3) Ruleaza:
   flutter clean
   flutter pub get
   flutter gen-l10n

4) (Optional, recomandat) Configureaza Firebase:
   dart pub global activate flutterfire_cli
   flutterfire configure
   # dupa generare, poti de-comenta blocul din main.dart marcat TODO(restore).

5) Ruleaza:
   flutter run

Daca dupa pasii de mai sus primesti "asset not found", verifica caile din `pubspec.yaml` fata de folderele reale (ex: assets/audio/sounds/...).
