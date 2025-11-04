import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import 'package:lumea_alessiei/src/core/data_provider.dart';

// Helper pentru a obține traducerea unui titlu de sunet
String _getTranslatedSoundTitle(BuildContext context, String key) {
  final l10n = AppLocalizations.of(context);
  switch (key) {
    case 'soundCow': return l10n.soundCow;
    case 'soundSheep': return l10n.soundSheep;
    case 'soundPig': return l10n.soundPig;
    case 'soundHorse': return l10n.soundHorse;
    case 'soundHen': return l10n.soundHen;
    case 'soundDuck': return l10n.soundDuck;
    case 'soundDog': return l10n.soundDog;
    case 'soundCat': return l10n.soundCat;
    case 'soundTurkey': return l10n.soundTurkey;
    case 'soundRabbit': return l10n.soundRabbit;
    case 'soundLion': return l10n.soundLion;
    case 'soundTiger': return l10n.soundTiger;
    case 'soundMonkey': return l10n.soundMonkey;
    case 'soundElephant': return l10n.soundElephant;
    case 'soundSnake': return l10n.soundSnake;
    case 'soundGiraffe': return l10n.soundGiraffe;
    case 'soundZebra': return l10n.soundZebra;
    case 'soundRhino': return l10n.soundRhino;
    case 'soundCrocodile': return l10n.soundCrocodile;
    case 'soundHippo': return l10n.soundHippo;
    case 'soundDolphin': return l10n.soundDolphin;
    case 'soundWhale': return l10n.soundWhale;
    case 'soundFish': return l10n.soundFish;
    case 'soundOctopus': return l10n.soundOctopus;
    case 'soundSeahorse': return l10n.soundSeahorse;
    case 'soundShark': return l10n.soundShark;
    case 'soundJellyfish': return l10n.soundJellyfish;
    case 'soundSeal': return l10n.soundSeal;
    case 'soundCrab': return l10n.soundCrab;
    case 'soundStarfish': return l10n.soundStarfish;
    case 'soundOwl': return l10n.soundOwl;
    case 'soundParrot': return l10n.soundParrot;
    case 'soundSparrow': return l10n.soundSparrow;
    case 'soundPenguin': return l10n.soundPenguin;
    case 'soundFlamingo': return l10n.soundFlamingo;
    case 'soundToucan': return l10n.soundToucan;
    case 'soundSwan': return l10n.soundSwan;
    case 'soundEagle': return l10n.soundEagle;
    case 'soundPeacock': return l10n.soundPeacock;
    case 'soundMoorhen': return l10n.soundMoorhen;
    case 'soundCar': return l10n.soundCar;
    case 'soundTrain': return l10n.soundTrain;
    case 'soundAirplane': return l10n.soundAirplane;
    case 'soundBus': return l10n.soundBus;
    case 'soundAmbulance': return l10n.soundAmbulance;
    case 'soundTractor': return l10n.soundTractor;
    case 'soundShip': return l10n.soundShip;
    case 'soundMotorcycle': return l10n.soundMotorcycle;
    case 'soundHelicopter': return l10n.soundHelicopter;
    case 'soundFiretruck': return l10n.soundFiretruck;
    default: return key; // Fallback
  }
}

class SoundsDetailScreen extends ConsumerStatefulWidget {
  final String category;

  const SoundsDetailScreen({super.key, required this.category});

  @override
  ConsumerState<SoundsDetailScreen> createState() => _SoundsDetailScreenState();
}

class _SoundsDetailScreenState extends ConsumerState<SoundsDetailScreen> {
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

  Future<void> _playSound(String category, String soundId) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/sunete/$category/$soundId.wav'));
    } catch (e) {
      // Gestionează eroarea
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appData = ref.watch(appDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menuSounds), // Folosește o cheie generală
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/sounds'),
        ),
      ),
      body: appData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final items = (data.sounds['items']?[widget.category] as List?)?.cast<Map<String, dynamic>>() ?? [];
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final soundId = item['id'] as String;
              final titleKey = item['title'] as String;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => _playSound(widget.category, soundId),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/images/sounds_module/${widget.category}/$soundId.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _getTranslatedSoundTitle(context, titleKey),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
