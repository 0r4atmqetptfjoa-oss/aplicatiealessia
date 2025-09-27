class StoryPackagePreview {
  final String tempDirPath;
  final String? storyJson;
  final List<String> imagesFound;
  final List<String> audioFound;
  final List<String> imagesExpected;
  final List<String> audioExpected;

  StoryPackagePreview({
    required this.tempDirPath,
    required this.storyJson,
    required this.imagesFound,
    required this.audioFound,
    required this.imagesExpected,
    required this.audioExpected,
  });

  List<String> get imagesMissing =>
      imagesExpected.where((e) => !imagesFound.any((f) => f.endsWith(e))).toList();

  List<String> get audioMissing =>
      audioExpected.where((e) => !audioFound.any((f) => f.endsWith(e))).toList();
}
