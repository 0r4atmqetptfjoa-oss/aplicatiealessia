import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items=[
      {'title':'Instrumente','route':'/instrumente'},
      {'title':'Editor Povești','route':'/povesti-editor-vizual'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Jocuri')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_,i){
          final it=items[i];
          return ListTile(
            title: Text(it['title']!), trailing: const Icon(Icons.chevron_right),
            onTap: ()=>GoRouter.of(context).push(it['route']!),
          ).animate().fade().slide();
        },
        separatorBuilder: (_, __)=>const Divider(), itemCount: items.length),
    );
  }
}
