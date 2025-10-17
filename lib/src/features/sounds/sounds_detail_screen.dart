import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:rive/rive.dart';
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
  // the display label, artboard name (unused in this simplified version)
  // and the path to the audio file.  We use `.wav` files for the
  // placeholder sounds.  Adjust these lists when you add new
  // categories or items.
  static final Map<String, List<_SoundItem>> _itemsByCategory = {
    'ferma': [
      const _SoundItem('Vacă', 'VACA', 'assets/audio/sunete/ferma/vaca.wav'),
      const _SoundItem('Oaie', 'OAIE', 'assets/audio/sunete/ferma/oaie.wav'),
      const _SoundItem('Porc', 'PORC', 'assets/audio/sunete/ferma/porc.wav'),
      const _SoundItem('Cal', 'CAL', 'assets/audio/sunete/ferma/cal.wav'),
      const _SoundItem('Găină', 'GAINA', 'assets/audio/sunete/ferma/gaina.wav'),
      const _SoundItem('Rață', 'RATA', 'assets/audio/sunete/ferma/rata.wav'),
      const _SoundItem('Câine', 'CAINE', 'assets/audio/sunete/ferma/caine.wav'),
      const _SoundItem('Pisică', 'PISICA', 'assets/audio/sunete/ferma/pisica.wav'),
      const _SoundItem('Curcan', 'CURCAN', 'assets/audio/sunete/ferma/curcan.wav'),
      const _SoundItem('Iepure', 'IEPURE', 'assets/audio/sunete/ferma/iepure.wav'),
    ],
    'marine': [
      const _SoundItem('Delfin', 'DELFIN', 'assets/audio/sunete/marine/delfin.wav'),
      const _SoundItem('Balena', 'BALENA', 'assets/audio/sunete/marine/balena.wav'),
      const _SoundItem('Pește', 'PESTE', 'assets/audio/sunete/marine/peste.wav'),
      const _SoundItem('Caracatiță', 'CARACATITA', 'assets/audio/sunete/marine/caracatita.wav'),
      const _SoundItem('Cal de mare', 'CALDEMARE', 'assets/audio/sunete/marine/cal_de_mare.wav'),
      const _SoundItem('Rechin', 'RECHIN', 'assets/audio/sunete/marine/rechin.wav'),
      const _SoundItem('Meduză', 'MEDUZA', 'assets/audio/sunete/marine/meduza.wav'),
      const _SoundItem('Focă', 'FOCA', 'assets/audio/sunete/marine/foca.wav'),
      const _SoundItem('Crab', 'CRAB', 'assets/audio/sunete/marine/crab.wav'),
      const _SoundItem('Stea de mare', 'STEAMARE', 'assets/audio/sunete/marine/stea_de_mare.wav'),
    ],
    'vehicule': [
      const _SoundItem('Mașină', 'MASINA', 'assets/audio/sunete/vehicule/masina.wav'),
      const _SoundItem('Tren', 'TREN', 'assets/audio/sunete/vehicule/tren.wav'),
      const _SoundItem('Avion', 'AVION', 'assets/audio/sunete/vehicule/avion.wav'),
      const _SoundItem('Autobuz', 'AUTOBUZ', 'assets/audio/sunete/vehicule/autobuz.wav'),
      const _SoundItem('Ambulanță', 'AMBULANTA', 'assets/audio/sunete/vehicule/ambulanta.wav'),
      const _SoundItem('Tractor', 'TRACTOR', 'assets/audio/sunete/vehicule/tractor.wav'),
      const _SoundItem('Vapor', 'VAPOR', 'assets/audio/sunete/vehicule/vapor.wav'),
      const _SoundItem('Motocicletă', 'MOTOCICLETA', 'assets/audio/sunete/vehicule/motocicleta.wav'),
      const _SoundItem('Elicopter', 'ELICOPTER', 'assets/audio/sunete/vehicule/elicopter.wav'),
      const _SoundItem('Camion de pompieri', 'CAMIONPOMPIERI', 'assets/audio/sunete/vehicule/camion_pompieri.wav'),
    ],
    'salbatice': [
      const _SoundItem('Leu', 'LEU', 'assets/audio/sunete/salbatice/leu.wav'),
      const _SoundItem('Tigru', 'TIGRU', 'assets/audio/sunete/salbatice/tigru.wav'),
      const _SoundItem('Maimuță', 'MAIMUTA', 'assets/audio/sunete/salbatice/maimuta.wav'),
      const _SoundItem('Elefant', 'ELEFANT', 'assets/audio/sunete/salbatice/elefant.wav'),
      const _SoundItem('Șarpe', 'SARPE', 'assets/audio/sunete/salbatice/sarpe.wav'),
      const _SoundItem('Girafă', 'GIRAFA', 'assets/audio/sunete/salbatice/girafa.wav'),
      const _SoundItem('Zebră', 'ZEBRA', 'assets/audio/sunete/salbatice/zebra.wav'),
      const _SoundItem('Rinocer', 'RINOCER', 'assets/audio/sunete/salbatice/rinocer.wav'),
      const _SoundItem('Crocodil', 'CROCODIL', 'assets/audio/sunete/salbatice/crocodil.wav'),
      const _SoundItem('Hipopotam', 'HIPOPOTAM', 'assets/audio/sunete/salbatice/hipopotam.wav'),
    ],
    'pasari': [
      const _SoundItem('Bufniță', 'BUFNITA', 'assets/audio/sunete/pasari/bufnita.wav'),
      const _SoundItem('Papagal', 'PAPAGAL', 'assets/audio/sunete/pasari/papagal.wav'),
      const _SoundItem('Vrabie', 'VRABIE', 'assets/audio/sunete/pasari/vrabie.wav'),
      const _SoundItem('Pinguin', 'PINGUIN', 'assets/audio/sunete/pasari/pinguin.wav'),
      const _SoundItem('Flamingo', 'FLAMINGO', 'assets/audio/sunete/pasari/flamingo.wav'),
      const _SoundItem('Tucan', 'TUCAN', 'assets/audio/sunete/pasari/tucan.wav'),
      const _SoundItem('Lebădă', 'LEBADA', 'assets/audio/sunete/pasari/lebada.wav'),
      const _SoundItem('Vultur', 'VULTUR', 'assets/audio/sunete/pasari/vultur.wav'),
      const _SoundItem('Păun', 'PAUN', 'assets/audio/sunete/pasari/paun.wav'),
      const _SoundItem('Găinușă de apă', 'GAINUSAAPA', 'assets/audio/sunete/pasari/gainusa_de_apa.wav'),
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
  // In this simplified implementation we no longer use Rive for the
  // sound buttons.  Instead we derive the image path from the audio
  // file path by replacing the `audio/sunete` segment with
  // `images/sounds_module` and swapping the extension for `.png`.

  String get _imagePath {
    final audioPath = widget.item.audioPath;
    // Example: assets/audio/sunete/ferma/vaca.wav → assets/images/sounds_module/ferma/vaca.png
    var path = audioPath.replaceFirst('assets/audio/sunete', 'assets/images/sounds_module');
    // Replace the extension (.mp3 or .wav) with .png
    if (path.endsWith('.mp3')) {
      path = path.replaceFirst('.mp3', '.png');
    } else if (path.endsWith('.wav')) {
      path = path.replaceFirst('.wav', '.png');
    }
    return path;
  }

  void _handleTap() {
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
                // Display a static image for the sound item.  The image
                // filename matches the audio filename (same name and
                // category) but with `.png` extension and located under
                // `assets/images/sounds_module`.
                child: Image.asset(
                  _imagePath,
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