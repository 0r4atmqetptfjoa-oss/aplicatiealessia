import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ro.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ro'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Alessia\'s World'**
  String get appTitle;

  /// No description provided for @menuSounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get menuSounds;

  /// No description provided for @menuInstruments.
  ///
  /// In en, this message translates to:
  /// **'Instruments'**
  String get menuInstruments;

  /// No description provided for @menuSongs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get menuSongs;

  /// No description provided for @menuStories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get menuStories;

  /// No description provided for @menuGames.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get menuGames;

  /// No description provided for @gameAlphabet.
  ///
  /// In en, this message translates to:
  /// **'Alphabet'**
  String get gameAlphabet;

  /// No description provided for @gameNumbers.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get gameNumbers;

  /// No description provided for @gamePuzzle.
  ///
  /// In en, this message translates to:
  /// **'Puzzle'**
  String get gamePuzzle;

  /// No description provided for @gameMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get gameMemory;

  /// No description provided for @gameShapes.
  ///
  /// In en, this message translates to:
  /// **'Shapes'**
  String get gameShapes;

  /// No description provided for @gameColors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get gameColors;

  /// No description provided for @gameMathQuiz.
  ///
  /// In en, this message translates to:
  /// **'Math Quiz'**
  String get gameMathQuiz;

  /// No description provided for @gamePuzzle2.
  ///
  /// In en, this message translates to:
  /// **'Puzzle 2'**
  String get gamePuzzle2;

  /// No description provided for @gameInstruments.
  ///
  /// In en, this message translates to:
  /// **'Instruments Game'**
  String get gameInstruments;

  /// No description provided for @gameSortingAnimals.
  ///
  /// In en, this message translates to:
  /// **'Sorting Animals'**
  String get gameSortingAnimals;

  /// No description provided for @gameCooking.
  ///
  /// In en, this message translates to:
  /// **'Cooking Game'**
  String get gameCooking;

  /// No description provided for @gameMaze.
  ///
  /// In en, this message translates to:
  /// **'Maze'**
  String get gameMaze;

  /// No description provided for @gameHiddenObjects.
  ///
  /// In en, this message translates to:
  /// **'Hidden Objects'**
  String get gameHiddenObjects;

  /// No description provided for @gameBlocks.
  ///
  /// In en, this message translates to:
  /// **'Blocks'**
  String get gameBlocks;

  /// No description provided for @song_twinkle_twinkle.
  ///
  /// In en, this message translates to:
  /// **'Twinkle Twinkle Little Star'**
  String get song_twinkle_twinkle;

  /// No description provided for @story_scufita_rosie.
  ///
  /// In en, this message translates to:
  /// **'Little Red Riding Hood'**
  String get story_scufita_rosie;

  /// No description provided for @story_goldilocks.
  ///
  /// In en, this message translates to:
  /// **'Goldilocks and the Three Bears'**
  String get story_goldilocks;

  /// No description provided for @story_hansel_gretel.
  ///
  /// In en, this message translates to:
  /// **'Hansel and Gretel'**
  String get story_hansel_gretel;

  /// No description provided for @story_three_pigs.
  ///
  /// In en, this message translates to:
  /// **'The Three Little Pigs'**
  String get story_three_pigs;

  /// No description provided for @story_cinderella.
  ///
  /// In en, this message translates to:
  /// **'Cinderella'**
  String get story_cinderella;

  /// No description provided for @story_snow_white.
  ///
  /// In en, this message translates to:
  /// **'Snow White'**
  String get story_snow_white;

  /// No description provided for @story_jack_beanstalk.
  ///
  /// In en, this message translates to:
  /// **'Jack and the Beanstalk'**
  String get story_jack_beanstalk;

  /// No description provided for @story_friendly_dragon.
  ///
  /// In en, this message translates to:
  /// **'The Friendly Dragon'**
  String get story_friendly_dragon;

  /// No description provided for @story_rapunzel.
  ///
  /// In en, this message translates to:
  /// **'Rapunzel'**
  String get story_rapunzel;

  /// No description provided for @story_pinocchio.
  ///
  /// In en, this message translates to:
  /// **'Pinocchio'**
  String get story_pinocchio;

  /// No description provided for @story_sleeping_beauty.
  ///
  /// In en, this message translates to:
  /// **'Sleeping Beauty'**
  String get story_sleeping_beauty;

  /// No description provided for @story_thumbelina.
  ///
  /// In en, this message translates to:
  /// **'Thumbelina'**
  String get story_thumbelina;

  /// No description provided for @story_puss_in_boots.
  ///
  /// In en, this message translates to:
  /// **'Puss in Boots'**
  String get story_puss_in_boots;

  /// No description provided for @story_frog_prince.
  ///
  /// In en, this message translates to:
  /// **'The Frog Prince'**
  String get story_frog_prince;

  /// No description provided for @story_princess_pea.
  ///
  /// In en, this message translates to:
  /// **'The Princess and the Pea'**
  String get story_princess_pea;

  /// No description provided for @story_tortoise_hare.
  ///
  /// In en, this message translates to:
  /// **'The Tortoise and the Hare'**
  String get story_tortoise_hare;

  /// No description provided for @story_little_robot.
  ///
  /// In en, this message translates to:
  /// **'The Brave Little Robot'**
  String get story_little_robot;

  /// No description provided for @story_magical_rainbow.
  ///
  /// In en, this message translates to:
  /// **'The Magical Rainbow'**
  String get story_magical_rainbow;

  /// No description provided for @categoryFarm.
  ///
  /// In en, this message translates to:
  /// **'Farm Animals'**
  String get categoryFarm;

  /// No description provided for @categoryWild.
  ///
  /// In en, this message translates to:
  /// **'Wild Animals'**
  String get categoryWild;

  /// No description provided for @categoryMarine.
  ///
  /// In en, this message translates to:
  /// **'Marine Animals'**
  String get categoryMarine;

  /// No description provided for @categoryBirds.
  ///
  /// In en, this message translates to:
  /// **'Birds'**
  String get categoryBirds;

  /// No description provided for @categoryVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get categoryVehicles;

  /// No description provided for @soundCow.
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get soundCow;

  /// No description provided for @soundSheep.
  ///
  /// In en, this message translates to:
  /// **'Sheep'**
  String get soundSheep;

  /// No description provided for @soundPig.
  ///
  /// In en, this message translates to:
  /// **'Pig'**
  String get soundPig;

  /// No description provided for @soundHorse.
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get soundHorse;

  /// No description provided for @soundHen.
  ///
  /// In en, this message translates to:
  /// **'Hen'**
  String get soundHen;

  /// No description provided for @soundDuck.
  ///
  /// In en, this message translates to:
  /// **'Duck'**
  String get soundDuck;

  /// No description provided for @soundDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get soundDog;

  /// No description provided for @soundCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get soundCat;

  /// No description provided for @soundTurkey.
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get soundTurkey;

  /// No description provided for @soundRabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get soundRabbit;

  /// No description provided for @soundLion.
  ///
  /// In en, this message translates to:
  /// **'Lion'**
  String get soundLion;

  /// No description provided for @soundTiger.
  ///
  /// In en, this message translates to:
  /// **'Tiger'**
  String get soundTiger;

  /// No description provided for @soundMonkey.
  ///
  /// In en, this message translates to:
  /// **'Monkey'**
  String get soundMonkey;

  /// No description provided for @soundElephant.
  ///
  /// In en, this message translates to:
  /// **'Elephant'**
  String get soundElephant;

  /// No description provided for @soundSnake.
  ///
  /// In en, this message translates to:
  /// **'Snake'**
  String get soundSnake;

  /// No description provided for @soundGiraffe.
  ///
  /// In en, this message translates to:
  /// **'Giraffe'**
  String get soundGiraffe;

  /// No description provided for @soundZebra.
  ///
  /// In en, this message translates to:
  /// **'Zebra'**
  String get soundZebra;

  /// No description provided for @soundRhino.
  ///
  /// In en, this message translates to:
  /// **'Rhino'**
  String get soundRhino;

  /// No description provided for @soundCrocodile.
  ///
  /// In en, this message translates to:
  /// **'Crocodile'**
  String get soundCrocodile;

  /// No description provided for @soundHippo.
  ///
  /// In en, this message translates to:
  /// **'Hippo'**
  String get soundHippo;

  /// No description provided for @soundDolphin.
  ///
  /// In en, this message translates to:
  /// **'Dolphin'**
  String get soundDolphin;

  /// No description provided for @soundWhale.
  ///
  /// In en, this message translates to:
  /// **'Whale'**
  String get soundWhale;

  /// No description provided for @soundFish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get soundFish;

  /// No description provided for @soundOctopus.
  ///
  /// In en, this message translates to:
  /// **'Octopus'**
  String get soundOctopus;

  /// No description provided for @soundSeahorse.
  ///
  /// In en, this message translates to:
  /// **'Seahorse'**
  String get soundSeahorse;

  /// No description provided for @soundShark.
  ///
  /// In en, this message translates to:
  /// **'Shark'**
  String get soundShark;

  /// No description provided for @soundJellyfish.
  ///
  /// In en, this message translates to:
  /// **'Jellyfish'**
  String get soundJellyfish;

  /// No description provided for @soundSeal.
  ///
  /// In en, this message translates to:
  /// **'Seal'**
  String get soundSeal;

  /// No description provided for @soundCrab.
  ///
  /// In en, this message translates to:
  /// **'Crab'**
  String get soundCrab;

  /// No description provided for @soundStarfish.
  ///
  /// In en, this message translates to:
  /// **'Starfish'**
  String get soundStarfish;

  /// No description provided for @soundOwl.
  ///
  /// In en, this message translates to:
  /// **'Owl'**
  String get soundOwl;

  /// No description provided for @soundParrot.
  ///
  /// In en, this message translates to:
  /// **'Parrot'**
  String get soundParrot;

  /// No description provided for @soundSparrow.
  ///
  /// In en, this message translates to:
  /// **'Sparrow'**
  String get soundSparrow;

  /// No description provided for @soundPenguin.
  ///
  /// In en, this message translates to:
  /// **'Penguin'**
  String get soundPenguin;

  /// No description provided for @soundFlamingo.
  ///
  /// In en, this message translates to:
  /// **'Flamingo'**
  String get soundFlamingo;

  /// No description provided for @soundToucan.
  ///
  /// In en, this message translates to:
  /// **'Toucan'**
  String get soundToucan;

  /// No description provided for @soundSwan.
  ///
  /// In en, this message translates to:
  /// **'Swan'**
  String get soundSwan;

  /// No description provided for @soundEagle.
  ///
  /// In en, this message translates to:
  /// **'Eagle'**
  String get soundEagle;

  /// No description provided for @soundPeacock.
  ///
  /// In en, this message translates to:
  /// **'Peacock'**
  String get soundPeacock;

  /// No description provided for @soundMoorhen.
  ///
  /// In en, this message translates to:
  /// **'Moorhen'**
  String get soundMoorhen;

  /// No description provided for @soundCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get soundCar;

  /// No description provided for @soundTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get soundTrain;

  /// No description provided for @soundAirplane.
  ///
  /// In en, this message translates to:
  /// **'Airplane'**
  String get soundAirplane;

  /// No description provided for @soundBus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get soundBus;

  /// No description provided for @soundAmbulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get soundAmbulance;

  /// No description provided for @soundTractor.
  ///
  /// In en, this message translates to:
  /// **'Tractor'**
  String get soundTractor;

  /// No description provided for @soundShip.
  ///
  /// In en, this message translates to:
  /// **'Ship'**
  String get soundShip;

  /// No description provided for @soundMotorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get soundMotorcycle;

  /// No description provided for @soundHelicopter.
  ///
  /// In en, this message translates to:
  /// **'Helicopter'**
  String get soundHelicopter;

  /// No description provided for @soundFiretruck.
  ///
  /// In en, this message translates to:
  /// **'Firetruck'**
  String get soundFiretruck;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ro'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ro':
      return AppLocalizationsRo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
