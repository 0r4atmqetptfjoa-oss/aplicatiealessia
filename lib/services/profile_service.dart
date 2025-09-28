
import 'package:flutter/foundation.dart';

class ChildProfile {
  final String id;
  final String name;
  final int color;
  const ChildProfile({required this.id, required this.name, required this.color});

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        color: json['color'] as int,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'color': color};
}

class ProfileService {
  // Exposed as ValueNotifier to match UI expectations.
  final ValueNotifier<List<ChildProfile>> profiles = ValueNotifier<List<ChildProfile>>(<ChildProfile>[]);
  final ValueNotifier<String?> activeId = ValueNotifier<String?>(null);

  ChildProfile? get active =>
      profiles.value.firstWhere((p) => p.id == activeId.value, orElse: () => const ChildProfile(id: '', name: '', color: 0)).id.isEmpty
          ? null
          : profiles.value.firstWhere((p) => p.id == activeId.value);

  Future<void> addProfile(String name, int color) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final next = List<ChildProfile>.from(profiles.value)..add(ChildProfile(id: id, name: name, color: color));
    profiles.value = next;
    profiles.notifyListeners();
    activeId.value ??= id;
  }

  Future<void> setActive(String id) async {
    if (profiles.value.any((p) => p.id == id)) {
      activeId.value = id;
      activeId.notifyListeners();
    }
  }
}
