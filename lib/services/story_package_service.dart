import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class StoryPackageService {
  Future<File> exportPackage() async {
    final dir = await getApplicationDocumentsDirectory();
    final out = File('${dir.path}/story_${DateTime.now().millisecondsSinceEpoch}.alesia_story');
    final encoder = ZipFileEncoder()..create(out.path);
    final jsonStr = getIt<StoryService>().graphJson;
    encoder.addFile(_tempFile('story.json', jsonStr));
    final manifest = json.encode({'images': ['story_*.png'], 'audio': ['story_*.mp3']});
    encoder.addFile(_tempFile('manifest.json', manifest));
    encoder.close();
    return out;
  }

  Future<void> importPackage() async {
    final sel = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['alesia_story']);
    if (sel == null || sel.files.isEmpty) return;
    final file = File(sel.files.single.path!);
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    String? storyJson;
    for (final f in archive) {
      if (f.isFile && f.name.endsWith('story.json')) {
        storyJson = utf8.decode(f.content as List<int>);
        break;
      }
    }
    if (storyJson != null) {
      await getIt<StoryService>().setGraphFromJson(storyJson);
    }

    final dir = await getApplicationDocumentsDirectory();
    final target = Directory('${dir.path}/stories/custom_${DateTime.now().millisecondsSinceEpoch}');
    target.createSync(recursive: true);
    extractArchiveToDisk(archive, target.path);
  }

  File _tempFile(String name, String content) {
    final f = File('${Directory.systemTemp.path}/$name');
    f.writeAsStringSync(content);
    return f;
  }
}

class StoryValidation {
  final bool ok;
  final List<String> warnings;
  final int nodes;
  final int choices;
  StoryValidation({required this.ok, required this.warnings, required this.nodes, required this.choices});
}

extension StoryPackageValidation on StoryPackageService {
  StoryValidation validateBytes(List<int> bytes) {
    final warnings = <String>[];
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      ArchiveFile? story;
      for (final f in archive) { if (f.isFile && f.name.endsWith('story.json')) { story = f; break; } }
      if (story == null) { return StoryValidation(ok:false, warnings:['Lipsește story.json'], nodes:0, choices:0); }
      final raw = utf8.decode(story.content as List<int>);
      final jsonMap = json.decode(raw) as Map<String, dynamic>;
      final nodes = jsonMap.length;
      int choices = 0;
      final ids = jsonMap.keys.toSet();
      jsonMap.forEach((id, node) {
        final m = node as Map<String, dynamic>;
        final ch = (m['choices'] as List? ?? []);
        choices += ch.length;
        for (final c in ch) {
          final nx = (c as Map)['nextId'];
          if (!ids.contains(nx)) { warnings.add('Choice din $id duce la nod inexistent: $nx'); }
        }
      });
      final hasImg = archive.files.any((f) => f.isFile && (f.name.endsWith('.png') || f.name.endsWith('.jpg')));
      final hasAudio = archive.files.any((f) => f.isFile && f.name.endsWith('.mp3'));
      if (!hasImg) warnings.add('Nu s-au găsit imagini (png/jpg) în pachet.');
      if (!hasAudio) warnings.add('Nu s-au găsit fișiere audio (.mp3) în pachet.');
      return StoryValidation(ok: warnings.isEmpty, warnings: warnings, nodes: nodes, choices: choices);
    } catch (e) {
      return StoryValidation(ok:false, warnings:['Eroare la parsare: $e'], nodes:0, choices:0);
    }
  }
}
