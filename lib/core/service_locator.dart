import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/seasonal_theme_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:alesia/services/parental_service.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/synth_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<SynthService>(() => SynthService());
}
