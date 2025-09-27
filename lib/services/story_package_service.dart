import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_service.dart';
import 'package:alesia/services/story_package_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class StoryPackageService {
  Future<Map<String, dynamic>> buildSnapshot() async {
    // rezervat pentru extinderi viitoare
    return {'ok': true};
  }

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

  Future<StoryPackagePreview?> pickForPreview() async {
    final sel = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['alesia_story']);
    if (sel == null || sel.files.isEmpty) return null;
    final file = File(sel.files.single.path!);
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    String? storyJson;
    List<String> images = [];
    List<String> audio = [];
    List<String> expImages = [];
    List<String> expAudio = [];

    for (final f in archive) {
      if (!f.isFile) continue;
      if (f.name.endsWith('.png')) images.add(f.name);
      if (f.name.endsWith('.mp3')) audio.add(f.name);
      if (f.name.endsWith('story.json')) {
        storyJson = utf8.decode(f.content as List<int>);
      }
      if (f.name.endsWith('manifest.json')) {
        final manifest = utf8.decode(f.content as List<int>);
        final m = json.decode(manifest) as Map<String, dynamic>;
        expImages = (m['images'] as List?)?.map((e) => e.toString()).toList() ?? [];
        expAudio  = (m['audio']  as List?)?.map((e) => e.toString()).toList() ?? [];
      }
    }

    final dir = await getApplicationDocumentsDirectory();
    final target = Directory('${dir.path}/stories/preview_${DateTime.now().millisecondsSinceEpoch}');
    target.createSync(recursive: true);
    extractArchiveToDisk(archive, target.path);

    return StoryPackagePreview(
      tempDirPath: target.path,
      storyJson: storyJson,
      imagesFound: images,
      audioFound: audio,
      imagesExpected: expImages,
      audioExpected: expAudio,
    );
  }

  File _tempFile(String name, String content) {
    final f = File('${Directory.systemTemp.path}/$name');
    f.writeAsStringSync(content);
    return f;
  }
}
