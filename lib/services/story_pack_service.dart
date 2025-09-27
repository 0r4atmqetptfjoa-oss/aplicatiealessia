import 'dart:convert';
import 'dart:io';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_service.dart';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Export/Import pachete de poveste ca .alesia_story (ZIP).
/// În prezent include doar JSON-ul poveștii.
/// // TODO (Răzvan): Când ai resurse media externe (png/mp3) în storage accesibil, atașează-le în pachet.
class StoryPackService {
  Future<File> exportPack() async {
    final jsonStr = getIt<StoryService>().graphJson;
    final archive = Archive();
    archive.addFile(ArchiveFile.string('story.json', jsonStr));
    final bytes = ZipEncoder().encode(archive)!;
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/StoryPack_${DateTime.now().millisecondsSinceEpoch}.alesia_story';
    final f = File(path)..writeAsBytesSync(bytes);
    return f;
  }

  Future<void> importPack() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['alesia_story', 'zip']);
    if (res == null || res.files.isEmpty) return;
    final file = File(res.files.single.path!);
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final storyFile = archive.files.firstWhere((f) => f.name.endsWith('story.json'), orElse: () => ArchiveFile('missing', 0, null));
    if (storyFile.content == null) return;
    final jsonStr = utf8.decode(storyFile.content as List<int>);
    await getIt<StoryService>().setGraphFromJson(jsonStr);
  }
}
