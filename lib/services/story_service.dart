class StoryChoice { final String text; final String nextId; StoryChoice(this.text, this.nextId); }
class StoryNode { final String id; final String subtitle; final String? audioId; final List<StoryChoice> choices;
  StoryNode({required this.id,this.subtitle='',this.audioId,List<StoryChoice>? choices}):choices=choices??[]; }

class StoryService {
  final Map<String,StoryNode> graph = {
    'start': StoryNode(id:'start', subtitle:'Început', choices:[StoryChoice('Continuă','end')]),
    'end': StoryNode(id:'end', subtitle:'Sfârșit'),
  };

  Map<String, dynamic> get graphJson => graph.map((k, v) => MapEntry(k, {
    'subtitle': v.subtitle, 'audioId': v.audioId, 'choices': v.choices.map((c)=>{'t':c.text,'n':c.nextId}).toList()
  }));

  Future<void> replaceGraph(Map<String, StoryNode> g) async {
    graph
      ..clear()
      ..addAll(g);
  }

  Future<void> putNode(StoryNode n) async { graph[n.id]=n; }
  Future<void> removeNode(String id) async {
    graph.remove(id);
    for (final n in graph.values) { n.choices.removeWhere((c)=>c.nextId==id); }
  }
  Future<void> updateNode(String id,{String? subtitle,String? audioId}) async {
    final n = graph[id]; if(n==null) return;
    graph[id] = StoryNode(id:n.id, subtitle: subtitle??n.subtitle, audioId: audioId??n.audioId, choices: List.of(n.choices));
  }
  Future<void> addChoice(String from, StoryChoice c) async { graph[from]?.choices.add(c); }
}
