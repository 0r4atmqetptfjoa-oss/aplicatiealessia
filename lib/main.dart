import 'package:alesia/core/app_router.dart';
import 'package:alesia/services/theme_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:alesia/services/parental_service.dart';
import 'package:alesia/services/quest_service.dart';
import 'package:alesia/services/parental_service.dart' as ps;

import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupLocator();
  // Init services
  await getIt<AudioService>().init();
  await getIt<ProgressService>().init();
  // Analytics: contorizează lansarea
  getIt<ps.AnalyticsService>().inc('app_launches');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeService>();
    return ValueListenableBuilder<ThemeData>(
      valueListenable: theme.theme,
      builder: (context, t, _) {
        return MaterialApp.router(
          title: 'Alesia',
          theme: t,
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}