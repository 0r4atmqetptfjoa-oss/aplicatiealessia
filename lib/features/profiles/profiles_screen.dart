import 'dart:math';
import 'package:flutter/material.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:alesia/features/profiles/profile_dashboard_screen.dart';

class ProfilesScreen extends StatefulWidget { const ProfilesScreen({super.key}); @override State<ProfilesScreen> createState()=>_ProfilesScreenState(); }
class _ProfilesScreenState extends State<ProfilesScreen>{
  late ProfileService ps;
  @override void initState(){ super.initState(); ps=getIt<ProfileService>(); }
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Profiluri')),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>const ProfileDashboardScreen())), label: const Text('Dashboard profil'), icon: const Icon(Icons.bar_chart)),
      body: ValueListenableBuilder<List<ChildProfile>>(valueListenable: ps.profiles, builder:(context,profiles,_){
      return GridView.builder(padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12),
        itemCount: profiles.length+1, itemBuilder:(context,i){
          if(i==profiles.length){ return Card(child: InkWell(onTap:() async { final name=await _askName(context); if(name==null||name.isEmpty) return; final color=(Random().nextDouble()*0xFFFFFF).toInt()|0xFF000000; await ps.addProfile(name,color); setState((){}); }, child: const Center(child: Icon(Icons.add, size: 48))));}
          final p=profiles[i]; final isActive=ps.activeId.value==p.id;
          return GestureDetector(onTap:()=>ps.setActive(p.id), child: Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[
            CircleAvatar(radius: 36, backgroundColor: Color(p.color), child: const Icon(Icons.child_care, color: Colors.white)),
            const SizedBox(height:8), Text(p.name), if(isActive) const Text('Activ', style: TextStyle(color: Colors.green)),
          ])));
        });
    });
  }
  Future<String?> _askName(BuildContext context) {
    final c=TextEditingController();
    return showDialog<String>(context: context, builder:(ctx)=>AlertDialog(title: const Text('Nume profil'), content: TextField(controller: c), actions:[
      TextButton(onPressed:()=>Navigator.pop(ctx), child: const Text('Anulează')),
      ElevatedButton(onPressed:()=>Navigator.pop(ctx,c.text.trim()), child: const Text('OK')),
    ]));
  }
}
