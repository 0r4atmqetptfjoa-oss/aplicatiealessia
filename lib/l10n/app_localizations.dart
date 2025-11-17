import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A basic localization class that loads translations from ARB files.
///
/// This implementation reads the JSON-formatted ARB files at runtime and makes
/// the translated strings available through the [translate] method. The
/// [delegate] exposes the appropriate [LocalizationsDelegate] for Flutter.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  late Map<String, String> _localizedStrings;

  /// Loads the localized strings for the given [locale].
  static Future<AppLocalizations> load(Locale locale) async {
    final String jsonString =
        await rootBundle.loadString('lib/l10n/app_${locale.languageCode}.arb');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final AppLocalizations localizations = AppLocalizations(locale);
    localizations._localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return localizations;
  }

  /// Returns the translation for the given [key].
  String translate(String key) => _localizedStrings[key] ?? key;

  /// A convenient method to retrieve the [AppLocalizations] instance from the
  /// current build context.
  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  /// The delegate that provides [AppLocalizations] instances.
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ro'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      AppLocalizations.load(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}