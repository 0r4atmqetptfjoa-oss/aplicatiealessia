import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

/// Displays the main menu with navigation to all feature areas.
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('appTitle')),
      ),
      body: ListView(
        children: [
          _buildMenuItem(
            context,
            loc.translate('games'),
            '/games',
            assetName: 'games_menu.png',
          ),
          _buildMenuItem(
            context,
            loc.translate('instruments'),
            '/instruments',
            assetName: 'instruments_menu.png',
          ),
          _buildMenuItem(
            context,
            loc.translate('songs'),
            '/songs',
            assetName: 'songs.png',
          ),
          _buildMenuItem(
            context,
            loc.translate('sounds'),
            '/sounds',
            assetName: 'sounds_menu.png',
          ),
          _buildMenuItem(
            context,
            loc.translate('stories'),
            '/stories',
            assetName: 'stories.png',
          ),
          // Additional entries for profiles and premium features
          _buildMenuItem(
            context,
            'Profiles',
            '/profiles',
            assetName: 'profile_selection.png',
          ),
          _buildMenuItem(
            context,
            'Parental Gate',
            '/parental-gate',
            assetName: 'parental_gate.png',
          ),
          _buildMenuItem(
            context,
            'Upgrade',
            '/paywall',
            assetName: 'paywall.png',
          ),

        // Settings entry
        _buildMenuItem(
          context,
          loc.translate('settings'),
          '/settings',
          assetName: 'settings.png',
        ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String route, {
    String? assetName,
  }) {
    return ListTile(
      leading: assetName != null
          ? Image.asset(
              'assets/images/$assetName',
              width: 40,
              height: 40,
            )
          : null,
      title: Text(
        title,
        // headline6 -> titleLarge【259856227738898†L509-L519】.
        style: Theme.of(context).textTheme.titleLarge,
      ),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => context.go(route),
    );
  }
}