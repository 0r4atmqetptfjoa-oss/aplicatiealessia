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

class StoryPreview {
  final int nodeCount;
  final List<String> sampleSubtitles;
  final List<String> errors;
  StoryPreview({required this.nodeCount, required this.sampleSubtitles, required this.errors});
}

extension StoryPackagePreview on StoryPackageService {
  Future<StoryPreview?> readPreviewFromPackage() async {
    final sel = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['alesia_story']);
    if (sel == null || sel.files.isEmpty) return null;
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
    if (storyJson == null) return null;
    final svc = getIt<StoryService>();
    final m = Map<String, dynamic>.from(json.decode(storyJson));
    final g = <String, StoryNode>{};
    m.forEach((k, v) => g[k] = StoryNode.fromJson(Map<String, dynamic>.from(v)));
    final errs = svc.validateGraph(g);
    final subs = g.values.map((n) => n.subtitle).take(5).toList();
    return StoryPreview(nodeCount: g.length, sampleSubtitles: subs, errors: errs);
  }
}
