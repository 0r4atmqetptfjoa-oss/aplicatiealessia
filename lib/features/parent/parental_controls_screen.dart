import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/parental_control_service.dart';

class ParentalControlsScreen extends StatefulWidget {
  const ParentalControlsScreen({super.key});
  @override
  State<ParentalControlsScreen> createState() => _ParentalControlsScreenState();
}
class _ParentalControlsScreenState extends State<ParentalControlsScreen> {
  late ParentalControlService s;
  @override void initState(){ super.initState(); s=getIt<ParentalControlService>(); }
  @override Widget build(BuildContext context){
    return ListView(padding: const EdgeInsets.all(16), children: [
      SwitchListTile(value: s.bgMusicEnabled, onChanged:(v){ setState(()=>s.bgMusicEnabled=v); s.save(); }, title: const Text('Muzică de fundal')),
      SwitchListTile(value: s.disableParticles, onChanged:(v){ setState(()=>s.disableParticles=v); s.save(); }, title: const Text('Dezactivează particulele')),
      ListTile(title: const Text('Limită zilnică (minute)'), trailing: SizedBox(width:100, child: TextFormField(initialValue: s.dailyMinutes.toString(), keyboardType: TextInputType.number, onFieldSubmitted:(v){ s.dailyMinutes=int.tryParse(v)??0; s.save(); }))),
      const SizedBox(height:12),
      ListTile(title: const Text('Setare PIN'), trailing: ElevatedButton(onPressed: () async { final pin=await _askPin(context); s.setPin(pin?.isEmpty==true?null:pin); if(!mounted) return; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN actualizat'))); }, child: const Text('Configurează'))),
    ].animate().fadeIn());
  }
  Future<String?> _askPin(BuildContext context) async {
    final c=TextEditingController();
    return showDialog<String>(context: context, builder: (ctx)=>AlertDialog(title: const Text('Introdu PIN (4 cifre)'), content: TextField(controller:c,keyboardType: TextInputType.number, maxLength:4, obscureText:true), actions:[ TextButton(onPressed:()=>Navigator.pop(ctx), child: const Text('Anulează')), ElevatedButton(onPressed:()=>Navigator.pop(ctx,c.text.trim()), child: const Text('Salvează')) ]));
  }
}
