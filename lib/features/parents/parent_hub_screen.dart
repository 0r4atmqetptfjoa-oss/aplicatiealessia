import 'package:alesia/features/parent/story_package_preview_screen.dart';
import 'package:alesia/features/parent/parental_controls_screen.dart';
import 'package:alesia/features/profiles/profiles_screen.dart';
import 'package:alesia/features/rewards/rewards_screen.dart';
import 'package:alesia/features/analytics/analytics_dashboard_screen.dart';
import 'package:alesia/features/analytics/profile_dashboard_screen.dart';
import 'package:alesia/features/stories/story_pack_screen.dart';
import 'package:alesia/features/quests/quests_screen.dart';
import 'package:alesia/features/theme/theme_settings_screen.dart';
import 'package:alesia/features/parent/backup_screen.dart';
import 'package:alesia/features/abtest/abtest_screen.dart';
import 'package:alesia/features/stories/story_editor_screen.dart';
import 'package:alesia/features/stories/story_graph_editor_screen.dart';
import 'package:flutter/material.dart';

class ParentHubScreen extends StatelessWidget {
  const ParentHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Zona Părinți'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Profiluri'),
              Tab(text: 'Control'),
              Tab(text: 'Analiză'),
              Tab(text: 'Profil (Grafice)'),
              Tab(text: 'Quest-uri'),
              Tab(text: 'Teme'),
              Tab(text: 'Backup'),
              Tab(text: 'Povești (Editor Vizual)'),
              Tab(text: 'Pachete Povești'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const ProfilesScreen(),
            const ParentalControlsScreen(),
            const AnalyticsDashboardScreen(),
            const ProfileDashboardScreen(),
            const QuestsScreen(),
            const ThemeSettingsScreen(),
            const BackupScreen(),
            const StoryGraphEditorScreen(),
            StoryPacksScreen(),
          ],
        ),
      ),
    );
  }
}