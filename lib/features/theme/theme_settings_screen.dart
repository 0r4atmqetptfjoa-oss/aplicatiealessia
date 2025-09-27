import 'package:flutter/material.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/theme_service.dart';
class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});
  @override Widget build(BuildContext context){
    final ts=getIt<ThemeService>();
    return ValueListenableBuilder<ThemeFlavor>(valueListenable: ts.flavor, builder:(context,f,_){
      return Column(children:[
        RadioListTile<ThemeFlavor>(value: ThemeFlavor.classic, groupValue: f, onChanged: (v)=>ts.setFlavor(v!), title: const Text('Clasic')),
        RadioListTile<ThemeFlavor>(value: ThemeFlavor.forest, groupValue: f, onChanged: (v)=>ts.setFlavor(v!), title: const Text('Pădure')),
        RadioListTile<ThemeFlavor>(value: ThemeFlavor.underwater, groupValue: f, onChanged: (v)=>ts.setFlavor(v!), title: const Text('Subacvatic')),
        RadioListTile<ThemeFlavor>(value: ThemeFlavor.winter, groupValue: f, onChanged: (v)=>ts.setFlavor(v!), title: const Text('Iarnă')),
      ]);
    });
  }
}
