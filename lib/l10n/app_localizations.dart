import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ro'),
  ];

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Simple string map
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': "Alessia's World",
      'menuSounds': 'Sounds',
      'menuInstruments': 'Instruments',
      'menuSongs': 'Songs',
      'menuStories': 'Stories',
      'menuGames': 'Games',
    },
    'ro': {
      'appTitle': 'Lumea Alessiei',
      'menuSounds': 'Sunete',
      'menuInstruments': 'Instrumente',
      'menuSongs': 'Cântece',
      'menuStories': 'Povești',
      'menuGames': 'Jocuri',
    },
  };

  String _t(String key) {
    final lang = _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    return lang[key] ?? key;
  }

  // Exposed getters (add more as you need them)
  String get appTitle => _t('appTitle');
  String get menuSounds => _t('menuSounds');
  String get menuInstruments => _t('menuInstruments');
  String get menuSongs => _t('menuSongs');
  String get menuStories => _t('menuStories');
  String get menuGames => _t('menuGames');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
