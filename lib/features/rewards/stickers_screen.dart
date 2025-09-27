import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StickersScreen extends StatefulWidget {
  const StickersScreen({super.key});

  @override
  State<StickersScreen> createState() => _StickersScreenState();
}

class _StickersScreenState extends State<StickersScreen> {
  late final ProgressService _progress;
  final _defs = <Map<String,String>>[
    {'id':'piano_star_1','label':'Pian ⭐1'},
    {'id':'piano_star_2','label':'Pian ⭐2'},
    {'id':'piano_star_3','label':'Pian ⭐3'},
    {'id':'drums_star_1','label':'Tobe ⭐1'},
    {'id':'drums_star_2','label':'Tobe ⭐2'},
    {'id':'drums_star_3','label':'Tobe ⭐3'},
    {'id':'xylophone_star_1','label':'Xilofon ⭐1'},
    {'id':'xylophone_star_2','label':'Xilofon ⭐2'},
    {'id':'xylophone_star_3','label':'Xilofon ⭐3'},
    {'id':'organ_star_1','label':'Orgă ⭐1'},
    {'id':'organ_star_2','label':'Orgă ⭐2'},
    {'id':'organ_star_3','label':'Orgă ⭐3'},
  ];

  @override
  void initState() {
    super.initState();
    _progress = getIt<ProgressService>();
  }

  @override
  Widget build(BuildContext context) {
    final stickers = _progress.stickers.toSet();
    return Scaffold(
      appBar: AppBar(title: const Text('Stickere & Colecții')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.8),
        itemCount: _defs.length,
        itemBuilder: (context, i) {
          final d = _defs[i];
          final owned = stickers.contains(d['id']);
          return Column(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: owned ? Colors.amber : Colors.grey.shade300, width: 3),
                    color: owned ? Colors.amber.shade50 : Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // TODO (Răzvan): Înlocuiește cu sprite-ul final pentru sticker '${d['id']}.png'
                        Image.asset('assets/images/placeholders/placeholder_square.png', fit: BoxFit.cover, color: owned ? null : Colors.white.withOpacity(0.6), colorBlendMode: BlendMode.modulate),
                        if (owned) const Align(alignment: Alignment.topRight, child: Padding(padding: EdgeInsets.all(6), child: Icon(Icons.check_circle, color: Colors.green))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(d['label']!, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ).animate().fade().scale(delay: (i * 40).ms);
        },
      ),
    );
  }
}
