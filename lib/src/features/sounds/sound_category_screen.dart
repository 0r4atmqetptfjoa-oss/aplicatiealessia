import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data_provider.dart';
import '../../services/audio_service.dart';

class SoundCategoryScreen extends ConsumerWidget {
  final String category;

  const SoundCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(appDataProvider);

    return data.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (appData) {
        final categoryData = appData.sounds['categories'].firstWhere((c) => c['id'] == category);
        final items = categoryData['items'] as List;

        return _SoundCategoryView(category: category, items: items, categoryName: categoryData['name']);
      },
    );
  }
}

class _SoundCategoryView extends ConsumerStatefulWidget {
  final String category;
  final List items;
  final String categoryName;

  const _SoundCategoryView({required this.category, required this.items, required this.categoryName});

  @override
  ConsumerState<_SoundCategoryView> createState() => _SoundCategoryViewState();
}

class _SoundCategoryViewState extends ConsumerState<_SoundCategoryView> {
  SMIInput<bool>? _riveInput;

  String get _riveFile {
    return 'assets/rive/${widget.category.toLowerCase()}.riv';
  }

  String get _backgroundFile {
    return 'assets/images/sounds_module/${widget.category.toLowerCase()}_background.png';
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
    final audioService = ref.read(audioServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sunete: ${widget.categoryName}'),
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
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final audioPath = 'assets/audio/sounds/${widget.category}/${item["id"]}.wav';
            return _SoundItemCard(
              item: _SoundItem(item['name'], item['id'].toUpperCase(), audioPath),
              riveFile: _riveFile,
              onTap: () {
                audioService.play(audioPath, channel: AudioChannel.sfx);
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
