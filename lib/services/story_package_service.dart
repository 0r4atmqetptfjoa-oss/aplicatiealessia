import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class StoryPackageService {
  /// Exportează numai JSON-ul poveștii într-un pachet .alesia_story.
  /// Notă: resursele (imagini/audio) nu pot fi extrase din assets la runtime;
  /// pachetul include doar JSON + manifest cu căi așteptate.
  Future<File> exportPackage() async {
    final dir = await getApplicationDocumentsDirectory();
    final out = File('${dir.path}/story_${DateTime.now().millisecondsSinceEpoch}.alesia_story');
    final encoder = ZipFileEncoder()..create(out.path);
    final jsonStr = getIt<StoryService>().graphJson;
    encoder.addFile(_tempFile('story.json', jsonStr));
    // manifest simplu pentru artiști
    final manifest = json.encode({'images': ['story_*.png'], 'audio': ['story_*.mp3']});
    encoder.addFile(_tempFile('manifest.json', manifest));
    encoder.close();
    return out;
  }

  /// Importă un pachet .alesia_story: citește story.json și îl aplică.
  /// Dacă există foldere media în arhivă, le extrage în Documents/stories/<id>/
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

    // Extrage restul în Documents/stories/custom_<ts>/
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
