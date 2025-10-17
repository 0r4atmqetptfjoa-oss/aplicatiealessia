import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rive/rive.dart';

class SoundCategoryScreen extends StatefulWidget {
  final String category;

  const SoundCategoryScreen({super.key, required this.category});

  @override
  State<SoundCategoryScreen> createState() => _SoundCategoryScreenState();
}

class _SoundCategoryScreenState extends State<SoundCategoryScreen> {
  late final AudioPlayer _audioPlayer;
  SMIInput<bool>? _riveInput;

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

  static final Map<String, List<_SoundItem>> _itemsByCategory = {
    'pasari': [
      const _SoundItem('Măcăleandru', 'MACALEANDRU', 'assets/audio/sunete/pasari/macaleandru.wav'),
      const _SoundItem('Lebădă', 'LEBADA', 'assets/audio/sunete/pasari/lebada.wav'),
      const _SoundItem('Bufniță', 'BUFNITA', 'assets/audio/sunete/pasari/bufnita.wav'),
      const _SoundItem('Rață Sălbatică', 'RATA_SALBATICA', 'assets/audio/sunete/pasari/rata_salbatica.wav'),
      const _SoundItem('Flamingo', 'FLAMINGO', 'assets/audio/sunete/pasari/flamingo.wav'),
      const _SoundItem('Porumbel', 'PORUMBEL', 'assets/audio/sunete/pasari/porumbel.wav'),
      const _SoundItem('Fazan', 'FAZAN', 'assets/audio/sunete/pasari/fazan.wav'),
      const _SoundItem('Stârcă', 'STARCA', 'assets/audio/sunete/pasari/starca.wav'),
    ],
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
  };

  List<_SoundItem> get _items => _itemsByCategory[widget.category.toLowerCase()] ?? const [];

  String get _categoryLabel {
    switch (widget.category.toLowerCase()) {
      case 'pasari':
        return 'Păsări';
      case 'ferma':
        return 'Animale de fermă';
      case 'marine':
        return 'Animale marine';
      case 'vehicule':
        return 'Vehicule';
      case 'salbatice':
        return 'Animale sălbatice';
      default:
        return widget.category;
    }
  }

  String get _riveFile {
    return 'assets/rive/${widget.category.toLowerCase()}.riv';
  }

  String get _backgroundFile {
    return 'assets/images/sounds_module/${widget.category.toLowerCase()}_background.png';
  }

  Future<void> _playSound(String path) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path.replaceFirst('assets/', '')));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    _riveInput = controller.findInput<bool>('play');
  }

  void _triggerAnimation() {
    _riveInput?.value = true;
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundFile),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 0.9,
          ),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];
            return _SoundItemCard(
              item: item,
              riveFile: _riveFile,
              onTap: () {
                _playSound(item.audioPath);
                _triggerAnimation();
              },
              onRiveInit: _onRiveInit,
            );
          },
        ),
      ),
    );
  }
}

class _SoundItem {
  final String label;
  final String artboard;
  final String audioPath;

  const _SoundItem(this.label, this.artboard, this.audioPath);
}

class _SoundItemCard extends StatelessWidget {
  final _SoundItem item;
  final String riveFile;
  final VoidCallback onTap;
  final void Function(Artboard) onRiveInit;

  const _SoundItemCard({required this.item, required this.riveFile, required this.onTap, required this.onRiveInit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: RiveAnimation.asset(
                  riveFile,
                  artboard: item.artboard,
                  onInit: onRiveInit,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 12.0),
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
