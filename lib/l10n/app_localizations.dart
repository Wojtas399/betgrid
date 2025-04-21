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

  /// No description provided for @homeAppVersion.
  ///
  /// In pl, this message translates to:
  /// **'Wersja aplikacji: {appVersion}'**
  String homeAppVersion(String appVersion);

  /// No description provided for @newVersionAvailableScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowa wersja aplikacji'**
  String get newVersionAvailableScreenTitle;

  /// No description provided for @newVersionAvailableDescription.
  ///
  /// In pl, this message translates to:
  /// **'Dostępna jest nowa wersja aplikacji. Pobierz ją, aby w pełni korzystać z najnowszych funkcjonalności.'**
  String get newVersionAvailableDescription;

  /// No description provided for @playersScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Gracze'**
  String get playersScreenTitle;

  /// No description provided for @playersNoOtherPlayersTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak innych graczy'**
  String get playersNoOtherPlayersTitle;

  /// No description provided for @playersNoOtherPlayersMessage.
  ///
  /// In pl, this message translates to:
  /// **'Aktualnie nie ma zarejestrowanych innych graczy'**
  String get playersNoOtherPlayersMessage;

  /// No description provided for @profileScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Profil'**
  String get profileScreenTitle;

  /// No description provided for @profileNewUsernameDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowa nazwa użytkownika'**
  String get profileNewUsernameDialogTitle;

  /// No description provided for @profileSuccessfullySavedUsername.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie zmieniono nazwę użytkownika'**
  String get profileSuccessfullySavedUsername;

  /// No description provided for @profileAvatarActionsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Edycja avataru'**
  String get profileAvatarActionsTitle;

  /// No description provided for @profileAvatarActionsSelectFromGallery.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz z galerii'**
  String get profileAvatarActionsSelectFromGallery;

  /// No description provided for @profileAvatarActionsCapturePhoto.
  ///
  /// In pl, this message translates to:
  /// **'Zrób zdjęcie'**
  String get profileAvatarActionsCapturePhoto;

  /// No description provided for @profileAvatarActionsDeleteImage.
  ///
  /// In pl, this message translates to:
  /// **'Usuń zdjęcie'**
  String get profileAvatarActionsDeleteImage;

  /// No description provided for @requiredDataCompletionScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wymagane dane'**
  String get requiredDataCompletionScreenTitle;

  /// No description provided for @requiredDataCompletionSelectAvatar.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz avatar'**
  String get requiredDataCompletionSelectAvatar;

  /// No description provided for @requiredDataCompletionAvatarSelectionGallery.
  ///
  /// In pl, this message translates to:
  /// **'Galeria'**
  String get requiredDataCompletionAvatarSelectionGallery;

  /// No description provided for @requiredDataCompletionAvatarSelectionCamera.
  ///
  /// In pl, this message translates to:
  /// **'Aparat'**
  String get requiredDataCompletionAvatarSelectionCamera;

  /// No description provided for @requiredDataCompletionChangeAvatar.
  ///
  /// In pl, this message translates to:
  /// **'Zmień'**
  String get requiredDataCompletionChangeAvatar;

  /// No description provided for @requiredDataCompletionSelectAvatarSource.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz źródło avataru'**
  String get requiredDataCompletionSelectAvatarSource;

  /// No description provided for @seasonGrandPrixBetPreviewTotal.
  ///
  /// In pl, this message translates to:
  /// **'Razem'**
  String get seasonGrandPrixBetPreviewTotal;

  /// No description provided for @seasonGrandPrixBetPreviewPointsDetails.
  ///
  /// In pl, this message translates to:
  /// **'Punktacja'**
  String get seasonGrandPrixBetPreviewPointsDetails;

  /// No description provided for @seasonGrandPrixBetPreviewChoice.
  ///
  /// In pl, this message translates to:
  /// **'Wybór'**
  String get seasonGrandPrixBetPreviewChoice;

  /// No description provided for @seasonGrandPrixBetPreviewResult.
  ///
  /// In pl, this message translates to:
  /// **'Rezultat'**
  String get seasonGrandPrixBetPreviewResult;

  /// No description provided for @seasonGrandPrixBetPreviewMultiplier.
  ///
  /// In pl, this message translates to:
  /// **'Mnożnik'**
  String get seasonGrandPrixBetPreviewMultiplier;

  /// No description provided for @seasonGrandPrixBetPreviewPositions.
  ///
  /// In pl, this message translates to:
  /// **'Pozycje'**
  String get seasonGrandPrixBetPreviewPositions;

  /// No description provided for @seasonGrandPrixBetPreviewPositionsMultiplier.
  ///
  /// In pl, this message translates to:
  /// **'Mnożnik punktów za pozycje'**
  String get seasonGrandPrixBetPreviewPositionsMultiplier;

  /// No description provided for @seasonGrandPrixBetPreviewFastestLap.
  ///
  /// In pl, this message translates to:
  /// **'Najszybsze okrążenie'**
  String get seasonGrandPrixBetPreviewFastestLap;

  /// No description provided for @seasonGrandPrixBetPreviewDnf.
  ///
  /// In pl, this message translates to:
  /// **'DNF'**
  String get seasonGrandPrixBetPreviewDnf;

  /// No description provided for @seasonGrandPrixBetPreviewDnfMultiplier.
  ///
  /// In pl, this message translates to:
  /// **'Mnożnik DNF'**
  String get seasonGrandPrixBetPreviewDnfMultiplier;

  /// No description provided for @seasonGrandPrixBetPreviewOther.
  ///
  /// In pl, this message translates to:
  /// **'Pozostałe'**
  String get seasonGrandPrixBetPreviewOther;

  /// No description provided for @seasonGrandPrixBetEditorScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Obstaw grand prix'**
  String get seasonGrandPrixBetEditorScreenTitle;

  /// No description provided for @seasonGrandPrixBetEditorQualificationDescription.
  ///
  /// In pl, this message translates to:
  /// **'Wytypuj końcowy rezultat kwalifikacji, tzn. rezultat po wszystkich 3 sesjach kwalifikacyjnych.'**
  String get seasonGrandPrixBetEditorQualificationDescription;

  /// No description provided for @seasonGrandPrixBetEditorRaceDescription.
  ///
  /// In pl, this message translates to:
  /// **'Wytypuj poszczególne sekcje wyścigu wedle opisu.'**
  String get seasonGrandPrixBetEditorRaceDescription;

  /// No description provided for @seasonGrandPrixBetEditorSelectDriver.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz kierowcę'**
  String get seasonGrandPrixBetEditorSelectDriver;

  /// No description provided for @seasonGrandPrixBetEditorPodiumAndP10Title.
  ///
  /// In pl, this message translates to:
  /// **'Podium oraz P10'**
  String get seasonGrandPrixBetEditorPodiumAndP10Title;

  /// No description provided for @seasonGrandPrixBetEditorPodiumAndP10Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wytypuj kierowców, którzy staną na podium oraz kierowcę, który ukończy wyścig na 10 pozycji.'**
  String get seasonGrandPrixBetEditorPodiumAndP10Subtitle;

  /// No description provided for @seasonGrandPrixBetEditorFastestLapSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wytypuj kierowcę, który przejedzie najszybsze okrążenie.'**
  String get seasonGrandPrixBetEditorFastestLapSubtitle;

  /// No description provided for @seasonGrandPrixBetEditorDnfTitle.
  ///
  /// In pl, this message translates to:
  /// **'DNF'**
  String get seasonGrandPrixBetEditorDnfTitle;

  /// No description provided for @seasonGrandPrixBetEditorDnfSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wytypuj 3 kierowców, którzy nie ukończą wyścigu.'**
  String get seasonGrandPrixBetEditorDnfSubtitle;

  /// No description provided for @seasonGrandPrixBetEditorAddDriversToDnfList.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj kierowców'**
  String get seasonGrandPrixBetEditorAddDriversToDnfList;

  /// No description provided for @seasonGrandPrixBetEditorEditDnfList.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj listę'**
  String get seasonGrandPrixBetEditorEditDnfList;

  /// No description provided for @seasonGrandPrixBetEditorNoDriversInfoTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak kierowców'**
  String get seasonGrandPrixBetEditorNoDriversInfoTitle;

  /// No description provided for @seasonGrandPrixBetEditorNoDriversInfoSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Niestety nie znaleziono żadnych kierowców do wyboru'**
  String get seasonGrandPrixBetEditorNoDriversInfoSubtitle;

  /// No description provided for @seasonGrandPrixBetEditorSafetyCarSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Czy w wyścigu pojawi się samochód bezpieczeństwa?'**
  String get seasonGrandPrixBetEditorSafetyCarSubtitle;

  /// No description provided for @seasonGrandPrixBetEditorRedFlagSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Czy w wyścigu pojawi się czerwona flaga?'**
  String get seasonGrandPrixBetEditorRedFlagSubtitle;

  /// No description provided for @seasonGrandPrixBetEditorSuccessfullySavedBets.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie zapisano typy'**
  String get seasonGrandPrixBetEditorSuccessfullySavedBets;

  /// No description provided for @seasonGrandPrixBetsScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Typy'**
  String get seasonGrandPrixBetsScreenTitle;

  /// No description provided for @seasonGrandPrixBetsNoBetsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak możliwości typowania'**
  String get seasonGrandPrixBetsNoBetsTitle;

  /// No description provided for @seasonGrandPrixBetsNoBetsMessage.
  ///
  /// In pl, this message translates to:
  /// **'Na ten moment nie masz możliwości typowania. Wszystkie wymagane dane są w procesie konfiguracji i niebawem zostaną udostępnione'**
  String get seasonGrandPrixBetsNoBetsMessage;

  /// No description provided for @seasonGrandPrixBetsOngoingStatus.
  ///
  /// In pl, this message translates to:
  /// **'Trwa'**
  String get seasonGrandPrixBetsOngoingStatus;

  /// No description provided for @seasonGrandPrixBetsNextStatus.
  ///
  /// In pl, this message translates to:
  /// **'Następne'**
  String get seasonGrandPrixBetsNextStatus;

  /// No description provided for @seasonGrandPrixBetsEndBettingTime.
  ///
  /// In pl, this message translates to:
  /// **'Koniec typowania za'**
  String get seasonGrandPrixBetsEndBettingTime;

  /// No description provided for @seasonTeamsScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zespoły'**
  String get seasonTeamsScreenTitle;

  /// No description provided for @seasonTeamDetailsName.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa'**
  String get seasonTeamDetailsName;

  /// No description provided for @seasonTeamDetailsTeamChief.
  ///
  /// In pl, this message translates to:
  /// **'Szef zespołu'**
  String get seasonTeamDetailsTeamChief;

  /// No description provided for @seasonTeamDetailsTechnicalChief.
  ///
  /// In pl, this message translates to:
  /// **'Szef techniczny'**
  String get seasonTeamDetailsTechnicalChief;

  /// No description provided for @seasonTeamDetailsChassis.
  ///
  /// In pl, this message translates to:
  /// **'Model samochodu'**
  String get seasonTeamDetailsChassis;

  /// No description provided for @seasonTeamDetailsPowerUnit.
  ///
  /// In pl, this message translates to:
  /// **'Silnik'**
  String get seasonTeamDetailsPowerUnit;

  /// No description provided for @seasonTeamDetailsReserveDrivers.
  ///
  /// In pl, this message translates to:
  /// **'Kierowcy rezerwowi'**
  String get seasonTeamDetailsReserveDrivers;

  /// No description provided for @signInScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Logowanie'**
  String get signInScreenTitle;

  /// No description provided for @signInScreenInfo.
  ///
  /// In pl, this message translates to:
  /// **'Logowanie do aplikacji jest możliwe tylko z wykorzystaniem konta Google'**
  String get signInScreenInfo;

  /// No description provided for @signInScreenSignInButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj'**
  String get signInScreenSignInButtonLabel;

  /// No description provided for @statsScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Statystyki'**
  String get statsScreenTitle;

  /// No description provided for @statsGrouped.
  ///
  /// In pl, this message translates to:
  /// **'Grupowe'**
  String get statsGrouped;

  /// No description provided for @statsIndividual.
  ///
  /// In pl, this message translates to:
  /// **'Indywidualne'**
  String get statsIndividual;

  /// No description provided for @statsTop3Players.
  ///
  /// In pl, this message translates to:
  /// **'Top 3 graczy'**
  String get statsTop3Players;

  /// No description provided for @statsBestPoints.
  ///
  /// In pl, this message translates to:
  /// **'Najwięcej zdobytych punktów'**
  String get statsBestPoints;

  /// No description provided for @statsBestPointsUnknown.
  ///
  /// In pl, this message translates to:
  /// **'Nieznane'**
  String get statsBestPointsUnknown;

  /// No description provided for @statsPointsHistory.
  ///
  /// In pl, this message translates to:
  /// **'Historia zdobytych punktów'**
  String get statsPointsHistory;

  /// No description provided for @statsPointsByDriver.
  ///
  /// In pl, this message translates to:
  /// **'Punkty zdobyte za kierowcę'**
  String get statsPointsByDriver;

  /// No description provided for @statsSelectDriver.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz kierowcę'**
  String get statsSelectDriver;

  /// No description provided for @statsNoSelectedDriver.
  ///
  /// In pl, this message translates to:
  /// **'Nie wybrano kierowcy'**
  String get statsNoSelectedDriver;

  /// No description provided for @statsNoDataTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak dostępnych statystyk'**
  String get statsNoDataTitle;

  /// No description provided for @statsNoDataMessage.
  ///
  /// In pl, this message translates to:
  /// **'Na ten moment brakuje odpowiednich danych do wyświetlenia statystyk'**
  String get statsNoDataMessage;

  /// No description provided for @loading.
  ///
  /// In pl, this message translates to:
  /// **'Ładowanie'**
  String get loading;

  /// No description provided for @qualifications.
  ///
  /// In pl, this message translates to:
  /// **'Kwalifikacje'**
  String get qualifications;

  /// No description provided for @race.
  ///
  /// In pl, this message translates to:
  /// **'Wyścig'**
  String get race;

  /// No description provided for @fastestLap.
  ///
  /// In pl, this message translates to:
  /// **'Najszybsze okrążenie'**
  String get fastestLap;

  /// No description provided for @safetyCar.
  ///
  /// In pl, this message translates to:
  /// **'Samochód bezpieczeństwa'**
  String get safetyCar;

  /// No description provided for @redFlag.
  ///
  /// In pl, this message translates to:
  /// **'Czerwona flaga'**
  String get redFlag;

  /// No description provided for @additional.
  ///
  /// In pl, this message translates to:
  /// **'Dodatkowe'**
  String get additional;

  /// No description provided for @round.
  ///
  /// In pl, this message translates to:
  /// **'Runda'**
  String get round;

  /// No description provided for @points.
  ///
  /// In pl, this message translates to:
  /// **'Punkty'**
  String get points;

  /// No description provided for @save.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get cancel;

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

  /// No description provided for @username.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa użytkownika'**
  String get username;

  /// No description provided for @theme.
  ///
  /// In pl, this message translates to:
  /// **'Motyw'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In pl, this message translates to:
  /// **'Jasny'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In pl, this message translates to:
  /// **'Ciemny'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In pl, this message translates to:
  /// **'Systemowy'**
  String get systemTheme;

  /// No description provided for @color.
  ///
  /// In pl, this message translates to:
  /// **'Kolor'**
  String get color;

  /// No description provided for @delete.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get delete;

  /// No description provided for @requiredField.
  ///
  /// In pl, this message translates to:
  /// **'To pole jest wymagane'**
  String get requiredField;

  /// No description provided for @usernameAlreadyTaken.
  ///
  /// In pl, this message translates to:
  /// **'Ta nazwa użytkownika jest już zajęta'**
  String get usernameAlreadyTaken;

  /// No description provided for @usernameHintText.
  ///
  /// In pl, this message translates to:
  /// **'Np. Jan123'**
  String get usernameHintText;

  /// No description provided for @doubleDash.
  ///
  /// In pl, this message translates to:
  /// **'--'**
  String get doubleDash;

  /// No description provided for @close.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get close;

  /// No description provided for @red.
  ///
  /// In pl, this message translates to:
  /// **'Czerwony'**
  String get red;

  /// No description provided for @pink.
  ///
  /// In pl, this message translates to:
  /// **'Różowy'**
  String get pink;

  /// No description provided for @purple.
  ///
  /// In pl, this message translates to:
  /// **'Fioletowy'**
  String get purple;

  /// No description provided for @brown.
  ///
  /// In pl, this message translates to:
  /// **'Brązowy'**
  String get brown;

  /// No description provided for @orange.
  ///
  /// In pl, this message translates to:
  /// **'Pomarańczowy'**
  String get orange;

  /// No description provided for @yellow.
  ///
  /// In pl, this message translates to:
  /// **'Żółty'**
  String get yellow;

  /// No description provided for @green.
  ///
  /// In pl, this message translates to:
  /// **'Zielony'**
  String get green;

  /// No description provided for @blue.
  ///
  /// In pl, this message translates to:
  /// **'Niebieski'**
  String get blue;
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
