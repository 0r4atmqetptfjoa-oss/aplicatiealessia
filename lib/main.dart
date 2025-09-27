import 'package:alesia/core/app_router.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: getIt<ThemeService>().theme,
      builder: (context, theme, _) {
        return _AlesiaGuardian(child: MaterialApp.router(
      title: 'Alesia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: theme,
    );
          ),
        );
      },
    );
  }
}


class _AlesiaGuardian extends StatefulWidget {
  final Widget child;
  const _AlesiaGuardian({required this.child});

  @override
  State<_AlesiaGuardian> createState() => _AlesiaGuardianState();
}

class _AlesiaGuardianState extends State<_AlesiaGuardian> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getIt<TimeTrackerService>().onResume();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final pcs = getIt<ParentalControlService>();
    final tts = getIt<TimeTrackerService>();
    if (state == AppLifecycleState.resumed) {
      tts.onResume();
    } else if (state == AppLifecycleState.paused) {
      tts.onPauseOrStop(breakIntervalMinutes: 20, dailyLimitMinutes: pcs.dailyMinutes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tts = getIt<TimeTrackerService>();
    return Stack(
      children: [
        widget.child,
        BreakOverlay(flag: tts.shouldBreak, onDismiss: () => tts.shouldBreak.value = false),
      ],
    );
  }
}
