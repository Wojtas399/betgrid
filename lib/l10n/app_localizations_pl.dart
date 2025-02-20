// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class StrPl extends Str {
  StrPl([String locale = 'pl']) : super(locale);

  @override
  String get signInScreenTitle => 'Logowanie';

  @override
  String get signInScreenInfo => 'Logowanie do aplikacji jest możliwe tylko z wykorzystaniem konta Google';

  @override
  String get signInScreenSignInButtonLabel => 'Zaloguj';

  @override
  String get requiredDataCompletionScreenTitle => 'Wymagane dane';

  @override
  String get requiredDataCompletionSelectAvatar => 'Wybierz avatar';

  @override
  String get requiredDataCompletionAvatarSelectionGallery => 'Galeria';

  @override
  String get requiredDataCompletionAvatarSelectionCamera => 'Aparat';

  @override
  String get requiredDataCompletionChangeAvatar => 'Zmień';

  @override
  String get requiredDataCompletionSelectAvatarSource => 'Wybierz źródło avataru';

  @override
  String get statsScreenTitle => 'Statystyki';

  @override
  String get statsGrouped => 'Grupowe';

  @override
  String get statsIndividual => 'Indywidualne';

  @override
  String get statsTop3Players => 'Top 3 graczy';

  @override
  String get statsBestPoints => 'Najwięcej zdobytych punktów';

  @override
  String get statsBestPointsUnknown => 'Nieznane';

  @override
  String get statsPointsHistory => 'Historia zdobytych punktów';

  @override
  String get statsPointsByDriver => 'Punkty zdobyte za kierowcę';

  @override
  String get statsSelectDriver => 'Wybierz kierowcę';

  @override
  String get statsNoSelectedDriver => 'Nie wybrano kierowcy';

  @override
  String get statsNoDataTitle => 'Brak dostępnych statystyk';

  @override
  String get statsNoDataMessage => 'Na ten moment brakuje odpowiednich danych do wyświetlenia statystyk';

  @override
  String get betsScreenTitle => 'Typy';

  @override
  String get betsNoBetsTitle => 'Brak możliwości typowania';

  @override
  String get betsNoBetsMessage => 'Na ten moment nie masz możliwości typowania. Wszystkie wymagane dane są w procesie konfiguracji i niebawem zostaną udostępnione';

  @override
  String get betsOngoingStatus => 'Trwa';

  @override
  String get betsNextStatus => 'Następne';

  @override
  String get betsEndBettingTime => 'Koniec typowania za';

  @override
  String get playersScreenTitle => 'Gracze';

  @override
  String get playersNoOtherPlayersTitle => 'Brak innych graczy';

  @override
  String get playersNoOtherPlayersMessage => 'Aktualnie nie ma zarejestrowanych innych graczy';

  @override
  String get grandPrixBetTotal => 'Razem';

  @override
  String get grandPrixBetPointsDetails => 'Punktacja';

  @override
  String get grandPrixBetChoice => 'Wybór';

  @override
  String get grandPrixBetResult => 'Rezultat';

  @override
  String get grandPrixBetMultiplier => 'Mnożnik';

  @override
  String get grandPrixBetPositions => 'Pozycje';

  @override
  String get grandPrixBetPositionsMultiplier => 'Mnożnik punktów za pozycje';

  @override
  String get grandPrixBetFastestLap => 'Najszybsze okrążenie';

  @override
  String get grandPrixBetDNF => 'DNF';

  @override
  String get grandPrixBetDNFMultiplier => 'Mnożnik DNF';

  @override
  String get grandPrixBetOther => 'Pozostałe';

  @override
  String get grandPrixBetEditorScreenTitle => 'Obstaw grand prix';

  @override
  String get grandPrixBetEditorQualificationDescription => 'Wytypuj końcowy rezultat kwalifikacji, tzn. rezultat po wszystkich 3 sesjach kwalifikacyjnych.';

  @override
  String get grandPrixBetEditorRaceDescription => 'Wytypuj poszczególne sekcje wyścigu wedle opisu.';

  @override
  String get grandPrixBetEditorSelectDriver => 'Wybierz kierowcę';

  @override
  String get grandPrixBetEditorPodiumAndP10Title => 'Podium oraz P10';

  @override
  String get grandPrixBetEditorPodiumAndP10Subtitle => 'Wytypuj kierowców, którzy staną na podium oraz kierowcę, który ukończy wyścig na 10 pozycji.';

  @override
  String get grandPrixBetEditorFastestLapSubtitle => 'Wytypuj kierowcę, który przejedzie najszybsze okrążenie.';

  @override
  String get grandPrixBetEditorDnfTitle => 'DNF';

  @override
  String get grandPrixBetEditorDnfSubtitle => 'Wytypuj 3 kierowców, którzy nie ukończą wyścigu.';

  @override
  String get grandPrixBetEditorAddDriversToDnfList => 'Dodaj kierowców';

  @override
  String get grandPrixBetEditorEditDnfList => 'Edytuj listę';

  @override
  String get grandPrixBetEditorNoDriversInfoTitle => 'Brak kierowców';

  @override
  String get grandPrixBetEditorNoDriversInfoSubtitle => 'Niestety nie znaleziono żadnych kierowców do wyboru';

  @override
  String get grandPrixBetEditorSafetyCarSubtitle => 'Czy w wyścigu pojawi się samochód bezpieczeństwa?';

  @override
  String get grandPrixBetEditorRedFlagSubtitle => 'Czy w wyścigu pojawi się czerwona flaga?';

  @override
  String get grandPrixBetEditorSuccessfullySavedBets => 'Pomyślnie zapisano typy';

  @override
  String get profileScreenTitle => 'Profil';

  @override
  String get profileNewUsernameDialogTitle => 'Nowa nazwa użytkownika';

  @override
  String get profileSuccessfullySavedUsername => 'Pomyślnie zmieniono nazwę użytkownika';

  @override
  String get profileAvatarActionsTitle => 'Edycja avataru';

  @override
  String get profileAvatarActionsSelectFromGallery => 'Wybierz z galerii';

  @override
  String get profileAvatarActionsCapturePhoto => 'Zrób zdjęcie';

  @override
  String get profileAvatarActionsDeleteImage => 'Usuń zdjęcie';

  @override
  String get loading => 'Ładowanie';

  @override
  String get qualifications => 'Kwalifikacje';

  @override
  String get race => 'Wyścig';

  @override
  String get fastestLap => 'Najszybsze okrążenie';

  @override
  String get safetyCar => 'Samochód bezpieczeństwa';

  @override
  String get redFlag => 'Czerwona flaga';

  @override
  String get additional => 'Dodatkowe';

  @override
  String get round => 'Runda';

  @override
  String get points => 'Punkty';

  @override
  String get save => 'Zapisz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get username => 'Nazwa użytkownika';

  @override
  String get theme => 'Motyw';

  @override
  String get lightTheme => 'Jasny';

  @override
  String get darkTheme => 'Ciemny';

  @override
  String get systemTheme => 'Systemowy';

  @override
  String get color => 'Kolor';

  @override
  String get delete => 'Usuń';

  @override
  String get requiredField => 'To pole jest wymagane';

  @override
  String get usernameAlreadyTaken => 'Ta nazwa użytkownika jest już zajęta';

  @override
  String get usernameHintText => 'Np. Jan123';

  @override
  String get doubleDash => '--';

  @override
  String get red => 'Czerwony';

  @override
  String get pink => 'Różowy';

  @override
  String get purple => 'Fioletowy';

  @override
  String get brown => 'Brązowy';

  @override
  String get orange => 'Pomarańczowy';

  @override
  String get yellow => 'Żółty';

  @override
  String get green => 'Zielony';

  @override
  String get blue => 'Niebieski';
}
