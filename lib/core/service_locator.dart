import 'package:get_it/get_it.dart';
import '../services/audio_service.dart';
import '../services/text_to_speech_service.dart';
import '../services/image_generation_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Servicii app
  sl.registerLazySingleton<AudioService>(() => AudioService());
  sl.registerLazySingleton<TextToSpeechService>(() => TextToSpeechService());
  sl.registerLazySingleton<ImageGenerationService>(() => ImageGenerationService());

  // Inițializări asincrone
  await sl<AudioService>().init();
}
