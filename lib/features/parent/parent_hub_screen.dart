import 'package:alesia/features/analytics/profile_dashboard_screen.dart';
import 'package:alesia/features/parent/story_packages_screen.dart';
import 'package:flutter/material.dart';
import 'package:alesia/features/profiles/profiles_screen.dart';
import 'package:alesia/features/parent/parental_controls_screen.dart';
import 'package:alesia/features/analytics/analytics_dashboard_screen.dart';
import 'package:alesia/features/quests/quests_screen.dart';
import 'package:alesia/features/theme/theme_settings_screen.dart';
import 'package:alesia/features/backup/backup_screen.dart';
import 'package:alesia/features/abtest/ab_test_screen.dart';
import 'package:alesia/features/stories/story_editor_screen.dart';

class ParentHubScreen extends StatelessWidget {
  const ParentHubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Zona Părinți'),
          bottom: const TabBar(isScrollable: true, tabs: [
            Tab(text: 'Profiluri'),
            Tab(text: 'Control'),
            Tab(text: 'Analiză'),
            Tab(text: 'Quest-uri'),
            Tab(text: 'Teme'),
            Tab(text: 'Backup'),
            Tab(text: 'Testare'),
            Tab(text: 'Stories JSON'),
          ]),
        ),
        body: const TabBarView(children: [
          ProfilesScreen(),
          ParentalControlsScreen(),
          AnalyticsDashboardScreen(),
          QuestsScreen(),
          ThemeSettingsScreen(),
          BackupScreen(),
          ABTestScreen(),
          StoryEditorScreen(),
            StoryPackagesScreen(),
        ]),
      ),
    );
  }
}
