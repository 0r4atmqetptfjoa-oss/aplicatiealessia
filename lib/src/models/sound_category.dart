class SoundCategory {
  final String id;
  final String name;
  final List<SoundItem> items;

  SoundCategory({required this.id, required this.name, required this.items});

  factory SoundCategory.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<SoundItem> items = itemsList.map((i) => SoundItem.fromJson(i)).toList();

    return SoundCategory(
      id: json['id'],
      name: json['name'],
      items: items,
    );
  }
}

class SoundItem {
  final String id;
  final String name;

  SoundItem({required this.id, required this.name});

  factory SoundItem.fromJson(Map<String, dynamic> json) {
    return SoundItem(
      id: json['id'],
      name: json['name'],
    );
  }
}
