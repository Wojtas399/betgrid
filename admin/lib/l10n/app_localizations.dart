import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of Str
/// returned by `Str.of(context)`.
///
/// Applications need to include `Str.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Str.localizationsDelegates,
///   supportedLocales: Str.supportedLocales,
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
/// be consistent with the languages listed in the Str.supportedLocales
/// property.
abstract class Str {
  Str(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Str of(BuildContext context) {
    return Localizations.of<Str>(context, Str)!;
  }

  static const LocalizationsDelegate<Str> delegate = _StrDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('pl')
  ];

  /// No description provided for @driversEditorScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj kierowców'**
  String get driversEditorScreenTitle;

  /// No description provided for @driversEditorAddDriver.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj kierowcę'**
  String get driversEditorAddDriver;

  /// No description provided for @driversEditorDeleteDriverConfirmationTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuwanie kierowcy'**
  String get driversEditorDeleteDriverConfirmationTitle;

  /// No description provided for @driversEditorDeleteDriverConfirmationMessage.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć kierowcę {driverName}?'**
  String driversEditorDeleteDriverConfirmationMessage(String driverName);

  /// No description provided for @driversEditorSuccessfullyAddedDriver.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie dodano nowego kierowcę'**
  String get driversEditorSuccessfullyAddedDriver;

  /// No description provided for @driversEditorSuccessfullyDeletedDriver.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie usunięto kierowcę'**
  String get driversEditorSuccessfullyDeletedDriver;

  /// No description provided for @editorsScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Edytory'**
  String get editorsScreenTitle;

  /// No description provided for @grandPrixesEditorScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj grand prixy'**
  String get grandPrixesEditorScreenTitle;

  /// No description provided for @grandPrixesEditorDeleteGrandPrixConfirmationTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuwanie grand prixu'**
  String get grandPrixesEditorDeleteGrandPrixConfirmationTitle;

  /// No description provided for @grandPrixesEditorDeleteGrandPrixConfirmationMessage.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć grand prix {grandPrixName}?'**
  String grandPrixesEditorDeleteGrandPrixConfirmationMessage(String grandPrixName);

  /// No description provided for @grandPrixesEditorSuccessfullyDeletedGrandPrix.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie usunięto grand prix'**
  String get grandPrixesEditorSuccessfullyDeletedGrandPrix;

  /// No description provided for @grandPrixesEditorSuccessfullyAddedGrandPrix.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie dodano nowe grand prix'**
  String get grandPrixesEditorSuccessfullyAddedGrandPrix;

  /// No description provided for @grandPrixesEditorAddGrandPrix.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj grand prix'**
  String get grandPrixesEditorAddGrandPrix;

  /// No description provided for @grandPrixesEditorGrandPrixName.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa grand prix'**
  String get grandPrixesEditorGrandPrixName;

  /// No description provided for @grandPrixesEditorCountryAlpha2Code.
  ///
  /// In pl, this message translates to:
  /// **'Kod kraju'**
  String get grandPrixesEditorCountryAlpha2Code;

  /// No description provided for @homeScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Strona główna'**
  String get homeScreenTitle;

  /// No description provided for @homeCreateGrandPrixButton.
  ///
  /// In pl, this message translates to:
  /// **'Stwórz nowe grand prix'**
  String get homeCreateGrandPrixButton;

  /// No description provided for @homeEditDriversButton.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj kierowców'**
  String get homeEditDriversButton;

  /// No description provided for @homeEditSeasonDriversButton.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj kierowców z sezonu'**
  String get homeEditSeasonDriversButton;

  /// No description provided for @homeEditTeamsButton.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj zespoły'**
  String get homeEditTeamsButton;

  /// No description provided for @homeEditSeasonTeamsButton.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj zespoły z sezonu'**
  String get homeEditSeasonTeamsButton;

  /// No description provided for @homeEditGrandPrixesButton.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj grand prixy'**
  String get homeEditGrandPrixesButton;

  /// No description provided for @homeEditSeasonGrandPrixesButton.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj grand prixy z sezonu'**
  String get homeEditSeasonGrandPrixesButton;

  /// No description provided for @seasonDriversEditorScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj kierowców sezonu'**
  String get seasonDriversEditorScreenTitle;

  /// No description provided for @seasonDriversEditorAddSeasonDriver.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj kierowcę do sezonu'**
  String get seasonDriversEditorAddSeasonDriver;

  /// No description provided for @seasonDriversEditorDriver.
  ///
  /// In pl, this message translates to:
  /// **'Kierowca'**
  String get seasonDriversEditorDriver;

  /// No description provided for @seasonDriversEditorDriverNumber.
  ///
  /// In pl, this message translates to:
  /// **'Numer kierowcy'**
  String get seasonDriversEditorDriverNumber;

  /// No description provided for @seasonDriversEditorTeam.
  ///
  /// In pl, this message translates to:
  /// **'Zespół'**
  String get seasonDriversEditorTeam;

  /// No description provided for @seasonDriversEditorSeasonDriverDeletionConfirmationTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuwanie kierowcy z sezonu'**
  String get seasonDriversEditorSeasonDriverDeletionConfirmationTitle;

  /// No description provided for @seasonDriversEditorSeasonDriverDeletionConfirmationMessage.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć kierowcę {driverName} z sezonu {season}?'**
  String seasonDriversEditorSeasonDriverDeletionConfirmationMessage(String driverName, int season);

  /// No description provided for @seasonDriversEditorSuccessfullyAddedDriver.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie dodano kierowcę do sezonu'**
  String get seasonDriversEditorSuccessfullyAddedDriver;

  /// No description provided for @seasonDriversEditorSuccessfullyDeletedSeasonDriver.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie usunięto kierowcę z sezonu'**
  String get seasonDriversEditorSuccessfullyDeletedSeasonDriver;

  /// No description provided for @seasonGrandPrixResultsEditorQualifications.
  ///
  /// In pl, this message translates to:
  /// **'Kwalifikacje'**
  String get seasonGrandPrixResultsEditorQualifications;

  /// No description provided for @seasonGrandPrixResultsEditorRace.
  ///
  /// In pl, this message translates to:
  /// **'Wyścig'**
  String get seasonGrandPrixResultsEditorRace;

  /// No description provided for @seasonGrandPrixResultsEditorSelectDriver.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz kierowcę'**
  String get seasonGrandPrixResultsEditorSelectDriver;

  /// No description provided for @seasonGrandPrixResultsEditorPodiumAndP10.
  ///
  /// In pl, this message translates to:
  /// **'Podium i p10'**
  String get seasonGrandPrixResultsEditorPodiumAndP10;

  /// No description provided for @seasonGrandPrixResultsEditorFastestLap.
  ///
  /// In pl, this message translates to:
  /// **'Najszybsze okrążenie'**
  String get seasonGrandPrixResultsEditorFastestLap;

  /// No description provided for @seasonGrandPrixResultsEditorDnf.
  ///
  /// In pl, this message translates to:
  /// **'DNF'**
  String get seasonGrandPrixResultsEditorDnf;

  /// No description provided for @seasonGrandPrixResultsEditorSafetyCar.
  ///
  /// In pl, this message translates to:
  /// **'Samochód bezpieczeństwa'**
  String get seasonGrandPrixResultsEditorSafetyCar;

  /// No description provided for @seasonGrandPrixResultsEditorRedFlag.
  ///
  /// In pl, this message translates to:
  /// **'Czerwona flaga'**
  String get seasonGrandPrixResultsEditorRedFlag;

  /// No description provided for @seasonGrandPrixResultsEditorEditDnfList.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj listę DNF'**
  String get seasonGrandPrixResultsEditorEditDnfList;

  /// No description provided for @seasonGrandPrixResultsEditorAddDriversToDnfList.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj kierowców do listy DNF'**
  String get seasonGrandPrixResultsEditorAddDriversToDnfList;

  /// No description provided for @seasonGrandPrixResultsEditorNoDriversInfoTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak kierowców'**
  String get seasonGrandPrixResultsEditorNoDriversInfoTitle;

  /// No description provided for @seasonGrandPrixResultsEditorNoDriversInfoSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj kierowców do listy DNF'**
  String get seasonGrandPrixResultsEditorNoDriversInfoSubtitle;

  /// No description provided for @seasonGrandPrixResultsEditorSuccessfullySavedResults.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie zapisano wyniki GP'**
  String get seasonGrandPrixResultsEditorSuccessfullySavedResults;

  /// No description provided for @seasonGrandPrixesEditorScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj grand prixy sezonu'**
  String get seasonGrandPrixesEditorScreenTitle;

  /// No description provided for @seasonGrandPrixesEditorAddSeasonGrandPrix.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj grand prix do sezonu'**
  String get seasonGrandPrixesEditorAddSeasonGrandPrix;

  /// No description provided for @seasonGrandPrixesEditorGrandPrix.
  ///
  /// In pl, this message translates to:
  /// **'Grand prix'**
  String get seasonGrandPrixesEditorGrandPrix;

  /// No description provided for @seasonGrandPrixesEditorSelectGrandPrix.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz grand prix'**
  String get seasonGrandPrixesEditorSelectGrandPrix;

  /// No description provided for @seasonGrandPrixesEditorRoundNumber.
  ///
  /// In pl, this message translates to:
  /// **'Numer rundy'**
  String get seasonGrandPrixesEditorRoundNumber;

  /// No description provided for @seasonGrandPrixesEditorStartDate.
  ///
  /// In pl, this message translates to:
  /// **'Data rozpoczęcia'**
  String get seasonGrandPrixesEditorStartDate;

  /// No description provided for @seasonGrandPrixesEditorEndDate.
  ///
  /// In pl, this message translates to:
  /// **'Data zakończenia'**
  String get seasonGrandPrixesEditorEndDate;

  /// No description provided for @seasonGrandPrixesEditorInvalidFormTitle.
  ///
  /// In pl, this message translates to:
  /// **'Niepoprawne dane formularza'**
  String get seasonGrandPrixesEditorInvalidFormTitle;

  /// No description provided for @seasonGrandPrixesEditorInvalidFormMessage.
  ///
  /// In pl, this message translates to:
  /// **'Niektóre pola zawierają niepoprawne dane'**
  String get seasonGrandPrixesEditorInvalidFormMessage;

  /// No description provided for @seasonGrandPrixesEditorSeasonGrandPrixDeletionConfirmationTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuwanie grand prixu z sezonu'**
  String get seasonGrandPrixesEditorSeasonGrandPrixDeletionConfirmationTitle;

  /// No description provided for @seasonGrandPrixesEditorSeasonGrandPrixDeletionConfirmationMessage.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć grand prix {grandPrixName} z sezonu {season}?'**
  String seasonGrandPrixesEditorSeasonGrandPrixDeletionConfirmationMessage(String grandPrixName, int season);

  /// No description provided for @seasonGrandPrixesEditorSuccessfullyDeletedGrandPrixFromSeason.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie usunięto grand prix z sezonu'**
  String get seasonGrandPrixesEditorSuccessfullyDeletedGrandPrixFromSeason;

  /// No description provided for @seasonGrandPrixesEditorSuccessfullyAddedGrandPrix.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie dodano grand prix do sezonu'**
  String get seasonGrandPrixesEditorSuccessfullyAddedGrandPrix;

  /// No description provided for @seasonGrandPrixesResultsScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wyniki'**
  String get seasonGrandPrixesResultsScreenTitle;

  /// No description provided for @seasonTeamsEditorScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowy zespół w sezonie'**
  String get seasonTeamsEditorScreenTitle;

  /// No description provided for @seasonTeamsEditorAddSeasonTeam.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj zespół do sezonu'**
  String get seasonTeamsEditorAddSeasonTeam;

  /// No description provided for @seasonTeamsEditorTeam.
  ///
  /// In pl, this message translates to:
  /// **'Zespół'**
  String get seasonTeamsEditorTeam;

  /// No description provided for @seasonTeamsEditorSelectTeam.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz zespół'**
  String get seasonTeamsEditorSelectTeam;

  /// No description provided for @seasonTeamsEditorSeasonTeamDeletionConfirmationTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuwanie zespołu z sezonu'**
  String get seasonTeamsEditorSeasonTeamDeletionConfirmationTitle;

  /// No description provided for @seasonTeamsEditorSeasonTeamDeletionConfirmationMessage.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć zespół {teamName} z sezonu {season}?'**
  String seasonTeamsEditorSeasonTeamDeletionConfirmationMessage(String teamName, int season);

  /// No description provided for @seasonTeamsEditorSuccessfullyAddedTeam.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie dodano zespół do sezonu'**
  String get seasonTeamsEditorSuccessfullyAddedTeam;

  /// No description provided for @seasonTeamsEditorSuccessfullyDeletedSeasonTeam.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie usunięto zespół z sezonu'**
  String get seasonTeamsEditorSuccessfullyDeletedSeasonTeam;

  /// No description provided for @teamsEditorScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj zespoły'**
  String get teamsEditorScreenTitle;

  /// No description provided for @teamsEditorAddTeam.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj zespół'**
  String get teamsEditorAddTeam;

  /// No description provided for @teamsEditorTeam.
  ///
  /// In pl, this message translates to:
  /// **'Zespół'**
  String get teamsEditorTeam;

  /// No description provided for @teamsEditorTeamName.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa zespołu'**
  String get teamsEditorTeamName;

  /// No description provided for @teamsEditorTeamHexColor.
  ///
  /// In pl, this message translates to:
  /// **'Kolor zespołu'**
  String get teamsEditorTeamHexColor;

  /// No description provided for @teamsEditorDeleteTeamConfirmationTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuwanie zespołu'**
  String get teamsEditorDeleteTeamConfirmationTitle;

  /// No description provided for @teamsEditorDeleteTeamConfirmationMessage.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć zespół {teamName}?'**
  String teamsEditorDeleteTeamConfirmationMessage(String teamName);

  /// No description provided for @teamsEditorSuccessfullyAddedTeam.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie dodano nowy zespół'**
  String get teamsEditorSuccessfullyAddedTeam;

  /// No description provided for @teamsEditorSuccessfullyDeletedTeam.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie usunięto zespół'**
  String get teamsEditorSuccessfullyDeletedTeam;

  /// No description provided for @season.
  ///
  /// In pl, this message translates to:
  /// **'Sezon'**
  String get season;

  /// No description provided for @driverPersonalDataName.
  ///
  /// In pl, this message translates to:
  /// **'Imię'**
  String get driverPersonalDataName;

  /// No description provided for @driverPersonalDataSurname.
  ///
  /// In pl, this message translates to:
  /// **'Nazwisko'**
  String get driverPersonalDataSurname;

  /// No description provided for @requiredFieldInfo.
  ///
  /// In pl, this message translates to:
  /// **'To pole jest wymagane'**
  String get requiredFieldInfo;

  /// No description provided for @add.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj'**
  String get add;

  /// No description provided for @delete.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get close;

  /// No description provided for @save.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get save;

  /// No description provided for @yes.
  ///
  /// In pl, this message translates to:
  /// **'Tak'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In pl, this message translates to:
  /// **'Nie'**
  String get no;
}

class _StrDelegate extends LocalizationsDelegate<Str> {
  const _StrDelegate();

  @override
  Future<Str> load(Locale locale) {
    return SynchronousFuture<Str>(lookupStr(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_StrDelegate old) => false;
}

Str lookupStr(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pl': return StrPl();
  }

  throw FlutterError(
    'Str.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
