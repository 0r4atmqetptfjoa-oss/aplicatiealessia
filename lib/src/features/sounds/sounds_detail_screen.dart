import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:audioplayers/audioplayers.dart';

/// Displays a list of items for a given sound category.
///
/// In the final implementation this screen will show animated buttons
/// with Rive and play the appropriate sound when tapped.  For now it
/// simply shows the category name and placeholder items.
class SoundsDetailScreen extends StatefulWidget {
  final String category;

  const SoundsDetailScreen({super.key, required this.category});

  @override
  State<SoundsDetailScreen> createState() => _SoundsDetailScreenState();
}

class _SoundsDetailScreenState extends State<SoundsDetailScreen> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Map categories to their list of sound items.  Each item defines
  // the display label, the artboard name in the Rive file and the
  // path to the audio file.  Update this map when you add new
  // categories or items.
  static final Map<String, List<_SoundItem>> _itemsByCategory = {
    'ferma': [
      _SoundItem('Vacă', 'VACA', 'assets/audio/sunete/ferma/vaca.mp3'),
      _SoundItem('Oaie', 'OAIE', 'assets/audio/sunete/ferma/oaie.mp3'),
      _SoundItem('Porc', 'PORC', 'assets/audio/sunete/ferma/porc.mp3'),
      _SoundItem('Cal', 'CAL', 'assets/audio/sunete/ferma/cal.mp3'),
      _SoundItem('Capră', 'CAPRA', 'assets/audio/sunete/ferma/capra.mp3'),
      _SoundItem('Cocoș', 'COCOS', 'assets/audio/sunete/ferma/cocos.mp3'),
      _SoundItem('Curcan', 'CURCAN', 'assets/audio/sunete/ferma/curcan.mp3'),
      _SoundItem('Gâscă', 'GASCA', 'assets/audio/sunete/ferma/gasca.mp3'),
      _SoundItem('Câine', 'CAINE', 'assets/audio/sunete/ferma/caine.mp3'),
      _SoundItem('Pisică', 'PISICA', 'assets/audio/sunete/ferma/pisica.mp3'),
    ],
    'marine': [
      _SoundItem('Delfin', 'DELFIN', 'assets/audio/sunete/marine/delfin.mp3'),
      _SoundItem('Rechin', 'RECHIN', 'assets/audio/sunete/marine/rechin.mp3'),
      _SoundItem('Balena', 'BALENA', 'assets/audio/sunete/marine/balena.mp3'),
      _SoundItem('Caracatiță', 'CARACATITA', 'assets/audio/sunete/marine/caracatita.mp3'),
      _SoundItem('Cal de mare', 'CALDEMARE', 'assets/audio/sunete/marine/caldemare.mp3'),
      _SoundItem('Meduză', 'MEDUZA', 'assets/audio/sunete/marine/meduza.mp3'),
      _SoundItem('Țestoasă', 'TESTOASA', 'assets/audio/sunete/marine/testoasa.mp3'),
      _SoundItem('Pește', 'PESTE', 'assets/audio/sunete/marine/peste.mp3'),
      _SoundItem('Creveți', 'CREVETI', 'assets/audio/sunete/marine/creveti.mp3'),
      _SoundItem('Focă', 'FOCA', 'assets/audio/sunete/marine/foca.mp3'),
    ],
    'vehicule': [
      // Note: labels use proper Romanian diacritics; artboard names
      // omit diacritics to match Rive artboard identifiers; file names
      // are lowercase without diacritics.
      _SoundItem('Mașină', 'MASINA', 'assets/audio/sunete/vehicule/masina.mp3'),
      _SoundItem('Ambulanță', 'AMBULANTA', 'assets/audio/sunete/vehicule/ambulanta.mp3'),
      _SoundItem('Motocicletă', 'MOTOCICLETA', 'assets/audio/sunete/vehicule/motocicleta.mp3'),
      _SoundItem('Camion', 'CAMION', 'assets/audio/sunete/vehicule/camion.mp3'),
      _SoundItem('Tren', 'TREN', 'assets/audio/sunete/vehicule/tren.mp3'),
      _SoundItem('Avion', 'AVION', 'assets/audio/sunete/vehicule/avion.mp3'),
      _SoundItem('Barcă', 'BARCA', 'assets/audio/sunete/vehicule/barca.mp3'),
      _SoundItem('Elicopter', 'ELICOPTER', 'assets/audio/sunete/vehicule/elicopter.mp3'),
      _SoundItem('Autobuz', 'AUTOBUZ', 'assets/audio/sunete/vehicule/autobuz.mp3'),
      _SoundItem('Tractor', 'TRACTOR', 'assets/audio/sunete/vehicule/tractor.mp3'),
    ],
    'salbatice': [
      _SoundItem('Leu', 'LEU', 'assets/audio/sunete/salbatice/leu.mp3'),
      _SoundItem('Tigru', 'TIGRU', 'assets/audio/sunete/salbatice/tigru.mp3'),
      _SoundItem('Elefant', 'ELEFANT', 'assets/audio/sunete/salbatice/elefant.mp3'),
      _SoundItem('Zebră', 'ZEBRA', 'assets/audio/sunete/salbatice/zebra.mp3'),
      _SoundItem('Girafă', 'GIRAFA', 'assets/audio/sunete/salbatice/girafa.mp3'),
      _SoundItem('Urs', 'URS', 'assets/audio/sunete/salbatice/urs.mp3'),
      _SoundItem('Maimuță', 'MAIMUTA', 'assets/audio/sunete/salbatice/maimuta.mp3'),
      _SoundItem('Crocodil', 'CROCODIL', 'assets/audio/sunete/salbatice/crocodil.mp3'),
      _SoundItem('Rinocer', 'RINOCER', 'assets/audio/sunete/salbatice/rinocer.mp3'),
      _SoundItem('Hipopotam', 'HIPOPOTAM', 'assets/audio/sunete/salbatice/hipopotam.mp3'),
    ],
    'pasari': [
      _SoundItem('Bufniță', 'BUFNITA', 'assets/audio/sunete/pasari/bufnita.mp3'),
      _SoundItem('Papagal', 'PAPAGAL', 'assets/audio/sunete/pasari/papagal.mp3'),
      _SoundItem('Vrabie', 'VRABIE', 'assets/audio/sunete/pasari/vrabie.mp3'),
      _SoundItem('Pinguin', 'PINGUIN', 'assets/audio/sunete/pasari/pinguin.mp3'),
      _SoundItem('Flamingo', 'FLAMINGO', 'assets/audio/sunete/pasari/flamingo.mp3'),
      _SoundItem('Tucan', 'TUCAN', 'assets/audio/sunete/pasari/tucan.mp3'),
      _SoundItem('Lebădă', 'LEBADA', 'assets/audio/sunete/pasari/lebada.mp3'),
      _SoundItem('Vultur', 'VULTUR', 'assets/audio/sunete/pasari/vultur.mp3'),
      _SoundItem('Păun', 'PAUN', 'assets/audio/sunete/pasari/paun.mp3'),
      _SoundItem('Rață', 'RATA', 'assets/audio/sunete/pasari/rata.mp3'),
    ],
  };

  List<_SoundItem> get _items => _itemsByCategory[widget.category.toLowerCase()] ?? const [];

  String get _categoryLabel {
    // Provide a user‑friendly label for the category if available
    switch (widget.category.toLowerCase()) {
      case 'ferma':
        return 'Animale de fermă';
      case 'marine':
        return 'Animale marine';
      case 'vehicule':
        return 'Vehicule';
      case 'salbatice':
        return 'Animale sălbatice';
      case 'pasari':
        return 'Păsări';
      default:
        return widget.category;
    }
  }

  Future<void> _playSound(String path) async {
    try {
      // Stop any currently playing sound before starting a new one.
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      // You can log or handle audio errors here.  For now we ignore.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sunete: $_categoryLabel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/sounds'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return _SoundItemCard(
            item: item,
            onTap: () {
              _playSound(item.audioPath);
            },
          );
        },
      ),
    );
  }
}

/// Model representing a sound item with a label, Rive artboard and audio file.
class _SoundItem {
  final String label;
  final String artboard;
  final String audioPath;

  const _SoundItem(this.label, this.artboard, this.audioPath);
}

/// Widget representing an interactive sound item.
class _SoundItemCard extends StatefulWidget {
  final _SoundItem item;
  final VoidCallback onTap;

  const _SoundItemCard({required this.item, required this.onTap});

  @override
  State<_SoundItemCard> createState() => _SoundItemCardState();
}

class _SoundItemCardState extends State<_SoundItemCard> {
  SMITrigger? _pressTrigger;
  Artboard? _artboard;

  void _onRiveInit(Artboard artboard) {
    // Called when the Rive artboard is loaded.  Attach the state
    // machine controller if available and store the press trigger for
    // later use.
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
    if (controller != null) {
      artboard.addController(controller);
      final input = controller.findInput<bool>('isPressed');
      if (input is SMITrigger) {
        _pressTrigger = input;
      }
    }
    _artboard = artboard;
  }

  void _handleTap() {
    // Fire the press trigger to play the animation.
    _pressTrigger?.fire();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RiveAnimation.asset(
                  'assets/rive/sound_buttons.riv',
                  artboard: widget.item.artboard,
                  onInit: _onRiveInit,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                widget.item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}