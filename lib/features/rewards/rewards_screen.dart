import 'package:flutter/material.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/progress_service.dart';
class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});
  @override Widget build(BuildContext context){
    final p=getIt<ProgressService>(); final entries=p.stickers.entries.toList();
    return Scaffold(appBar: AppBar(title: const Text('Colecție Stickere')), body: entries.isEmpty?const Center(child: Text('Nicio recompensă încă.')):GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,crossAxisSpacing:12,mainAxisSpacing:12), itemCount: entries.length, itemBuilder:(context,i){
      final e=entries[i]; return Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[
        // TODO (Răzvan): Înlocuiește cu sprite sticker final
        Image.asset('assets/images/placeholders/placeholder_square.png', width: 72, height: 72),
        const SizedBox(height:8), Text(e.key, textAlign: TextAlign.center), Text('x${e.value}')
      ]));
    }));
  }
}
