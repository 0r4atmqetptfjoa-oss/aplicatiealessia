import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_service.dart';

class StoryPackService {
  Future<File> exportPack({String? name}) async {
    final story = getIt<StoryService>();
    final dir = await getApplicationDocumentsDirectory();
    final id = const Uuid().v4();
    final outPath = '${dir.path}/$id.alesia_story';

    final encoder = ZipFileEncoder();
    encoder.create(outPath);
    // manifest.json
    final manifest = {
      'id': id,
      'name': name ?? 'Story Pack',
      'version': 1,
      'graph': json.decode(story.graphJson),
      'assets': {
        'audioMap': story.audioMap,
        'imageMap': story.imageMap,
      }
    };
    final manifestBytes = utf8.encode(const JsonEncoder.withIndent('  ').convert(manifest));
    encoder.addArchiveFile(ArchiveFile('manifest.json', manifestBytes.length, manifestBytes));

    // NOTE: În această fază nu includem fișiere binare; folosim mapările din StoryService către fișiere locale deja existente.
    // Extensie viitoare: copierea binarelor în arhivă.

    encoder.close();
    return File(outPath);
  }

  Future<void> importPack() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['alesia_story']);
    if (res == null || res.files.isEmpty) return;
    final file = File(res.files.single.path!);
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final manifestEntry = archive.findFile('manifest.json');
    if (manifestEntry == null) return;
    final data = json.decode(utf8.decode(manifestEntry.content as List<int>)) as Map<String, dynamic>;

    final story = getIt<StoryService>();
    await story.setGraphFromJson(json.encode(data['graph']));
    story.setAssetMaps(
      Map<String, String>.from(data['assets']?['audioMap'] ?? {}),
      Map<String, String>.from(data['assets']?['imageMap'] ?? {}),
    );
  }
}
