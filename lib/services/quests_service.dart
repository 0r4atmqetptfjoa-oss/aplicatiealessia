import 'dart:convert'; import 'package:shared_preferences/shared_preferences.dart';
class QuestsService{
  static const _k='quests'; final Map<String,int> _p={}; SharedPreferences? _s;
  final Map<String,int> _goals=const {'piano_3_success':3,'drums_3_success':3,'xylophone_3_success':3,'organ_3_success':3,'explore_1_success':1};
  Future<void> init() async{ _s=await SharedPreferences.getInstance(); final raw=_s!.getString(_k); if(raw!=null){ final m=Map<String,dynamic>.from(json.decode(raw)); _p..clear()..addAll(m.map((k,v)=>MapEntry(k,(v as num).toInt())));} }
  Future<void> _save() async{ await _s?.setString(_k,json.encode(_p)); }
  void recordInstrumentSuccess(String instrument){ final id='${instrument}_3_success'; _p[id]=(_p[id]??0)+1; _p['explore_1_success']=(_p['explore_1_success']??0)+1; _save(); }
  int progressOf(String id)=>_p[id]??0; int goalOf(String id)=>_goals[id]??0; bool isComplete(String id)=>progressOf(id)>=goalOf(id);
  Map<String,int> get goals=>Map.unmodifiable(_goals); Map<String,int> get allProgress=>Map.unmodifiable(_p);
}
