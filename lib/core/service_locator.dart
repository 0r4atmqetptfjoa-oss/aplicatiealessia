import 'package:alesia/services/audio_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<AudioService>(() => AudioService());
}
