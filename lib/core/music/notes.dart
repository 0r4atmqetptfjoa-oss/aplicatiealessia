library notes;

/// Utilități simple pentru frecvențe muzicale (A4 = 440 Hz).
/// Acceptă note în formatul 'C4', 'D#4', 'Db4', 'A5' etc.
double noteHz(String token) {
  final m = RegExp(r'^(?:([A-Ga-g])([#b]?))(\d+)$').firstMatch(token);
  if (m == null) throw ArgumentError('Format notă invalid: $token');
  final letter = m.group(1)!.toUpperCase();
  final accidental = m.group(2)!;
  final octave = int.parse(m.group(3)!);

  // Semiton offsets from C
  const Map<String, int> base = {
    'C': 0, 'D': 2, 'E': 4, 'F': 5, 'G': 7, 'A': 9, 'B': 11,
  };
  int semis = base[letter]!;
  if (accidental == '#') semis += 1;
  if (accidental == 'b') semis -= 1;

  final n = (octave - 4) * 12 + (semis - 9); // semitone distance from A4
  return 440.0 * Math.pow(2.0, n / 12.0);
}

/// Frecvențe utile direct (C-major o octavă)
const List<String> cMajor4Up = ['C4','D4','E4','F4','G4','A4','B4','C5'];
