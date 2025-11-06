import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart'; // Importul corect

class PianoPlayScreen extends StatefulWidget {
  const PianoPlayScreen({super.key});

  @override
  State<PianoPlayScreen> createState() => _PianoPlayScreenState();
}

class _PianoPlayScreenState extends State<PianoPlayScreen> {
  final _flutterMidi = FlutterMidi();

  @override
  void initState() {
    super.initState();
    _loadSoundfont();
  }

  void _loadSoundfont() async {
    _flutterMidi.unmute();
    ByteData _byte = await rootBundle.load('assets/sf2/Piano.sf2');
    _flutterMidi.prepare(sf2: _byte, name: 'Piano.sf2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: InteractivePiano(
          highlightedNotes: const [],
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: 60,
          noteRange: NoteRange.forClefs([Clef.Treble]),
          onNotePositionTapped: (position) {
            _flutterMidi.playMidiNote(midi: position.pitch);
          },
        ),
      ),
    );
  }
}
