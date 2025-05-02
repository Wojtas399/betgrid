// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class StrPl extends Str {
  StrPl([String locale = 'pl']) : super(locale);

  @override
  String get driversEditorScreenTitle => 'Edytuj kierowców';

  @override
  String get driversEditorAddDriver => 'Dodaj kierowcę';

  @override
  String get driversEditorDeleteDriverConfirmationTitle => 'Usuwanie kierowcy';

  @override
  String driversEditorDeleteDriverConfirmationMessage(String driverName) {
    return 'Czy na pewno chcesz usunąć kierowcę $driverName?';
  }

  @override
  String get driversEditorSuccessfullyAddedDriver => 'Pomyślnie dodano nowego kierowcę';

  @override
  String get driversEditorSuccessfullyDeletedDriver => 'Pomyślnie usunięto kierowcę';

  @override
  String get editorsScreenTitle => 'Edytory';

  @override
  String get grandPrixesEditorScreenTitle => 'Edytuj grand prixy';

  @override
  String get grandPrixesEditorDeleteGrandPrixConfirmationTitle => 'Usuwanie grand prixu';

  @override
  String grandPrixesEditorDeleteGrandPrixConfirmationMessage(String grandPrixName) {
    return 'Czy na pewno chcesz usunąć grand prix $grandPrixName?';
  }

  @override
  String get grandPrixesEditorSuccessfullyDeletedGrandPrix => 'Pomyślnie usunięto grand prix';

  @override
  String get grandPrixesEditorSuccessfullyAddedGrandPrix => 'Pomyślnie dodano nowe grand prix';

  @override
  String get grandPrixesEditorAddGrandPrix => 'Dodaj grand prix';

  @override
  String get grandPrixesEditorGrandPrixName => 'Nazwa grand prix';

  @override
  String get grandPrixesEditorCountryAlpha2Code => 'Kod kraju';

  @override
  String get homeScreenTitle => 'Strona główna';

  @override
  String get homeCreateGrandPrixButton => 'Stwórz nowe grand prix';

  @override
  String get homeEditDriversButton => 'Edytuj kierowców';

  @override
  String get homeEditSeasonDriversButton => 'Edytuj kierowców z sezonu';

  @override
  String get homeEditTeamsButton => 'Edytuj zespoły';

  @override
  String get homeEditSeasonTeamsButton => 'Edytuj zespoły z sezonu';

  @override
  String get homeEditGrandPrixesButton => 'Edytuj grand prixy';

  @override
  String get homeEditSeasonGrandPrixesButton => 'Edytuj grand prixy z sezonu';

  @override
  String get seasonDriversEditorScreenTitle => 'Edytuj kierowców sezonu';

  @override
  String get seasonDriversEditorAddSeasonDriver => 'Dodaj kierowcę do sezonu';

  @override
  String get seasonDriversEditorDriver => 'Kierowca';

  @override
  String get seasonDriversEditorDriverNumber => 'Numer kierowcy';

  @override
  String get seasonDriversEditorTeam => 'Zespół';

  @override
  String get seasonDriversEditorSeasonDriverDeletionConfirmationTitle => 'Usuwanie kierowcy z sezonu';

  @override
  String seasonDriversEditorSeasonDriverDeletionConfirmationMessage(String driverName, int season) {
    return 'Czy na pewno chcesz usunąć kierowcę $driverName z sezonu $season?';
  }

  @override
  String get seasonDriversEditorSuccessfullyAddedDriver => 'Pomyślnie dodano kierowcę do sezonu';

  @override
  String get seasonDriversEditorSuccessfullyDeletedSeasonDriver => 'Pomyślnie usunięto kierowcę z sezonu';

  @override
  String get seasonGrandPrixResultsEditorQualifications => 'Kwalifikacje';

  @override
  String get seasonGrandPrixResultsEditorRace => 'Wyścig';

  @override
  String get seasonGrandPrixResultsEditorSelectDriver => 'Wybierz kierowcę';

  @override
  String get seasonGrandPrixResultsEditorPodiumAndP10 => 'Podium i p10';

  @override
  String get seasonGrandPrixResultsEditorFastestLap => 'Najszybsze okrążenie';

  @override
  String get seasonGrandPrixResultsEditorDnf => 'DNF';

  @override
  String get seasonGrandPrixResultsEditorSafetyCar => 'Samochód bezpieczeństwa';

  @override
  String get seasonGrandPrixResultsEditorRedFlag => 'Czerwona flaga';

  @override
  String get seasonGrandPrixResultsEditorEditDnfList => 'Edytuj listę DNF';

  @override
  String get seasonGrandPrixResultsEditorAddDriversToDnfList => 'Dodaj kierowców do listy DNF';

  @override
  String get seasonGrandPrixResultsEditorNoDriversInfoTitle => 'Brak kierowców';

  @override
  String get seasonGrandPrixResultsEditorNoDriversInfoSubtitle => 'Dodaj kierowców do listy DNF';

  @override
  String get seasonGrandPrixResultsEditorSuccessfullySavedResults => 'Pomyślnie zapisano wyniki GP';

  @override
  String get seasonGrandPrixesEditorScreenTitle => 'Edytuj grand prixy sezonu';

  @override
  String get seasonGrandPrixesEditorAddSeasonGrandPrix => 'Dodaj grand prix do sezonu';

  @override
  String get seasonGrandPrixesEditorGrandPrix => 'Grand prix';

  @override
  String get seasonGrandPrixesEditorSelectGrandPrix => 'Wybierz grand prix';

  @override
  String get seasonGrandPrixesEditorRoundNumber => 'Numer rundy';

  @override
  String get seasonGrandPrixesEditorStartDate => 'Data rozpoczęcia';

  @override
  String get seasonGrandPrixesEditorEndDate => 'Data zakończenia';

  @override
  String get seasonGrandPrixesEditorInvalidFormTitle => 'Niepoprawne dane formularza';

  @override
  String get seasonGrandPrixesEditorInvalidFormMessage => 'Niektóre pola zawierają niepoprawne dane';

  @override
  String get seasonGrandPrixesEditorSeasonGrandPrixDeletionConfirmationTitle => 'Usuwanie grand prixu z sezonu';

  @override
  String seasonGrandPrixesEditorSeasonGrandPrixDeletionConfirmationMessage(String grandPrixName, int season) {
    return 'Czy na pewno chcesz usunąć grand prix $grandPrixName z sezonu $season?';
  }

  @override
  String get seasonGrandPrixesEditorSuccessfullyDeletedGrandPrixFromSeason => 'Pomyślnie usunięto grand prix z sezonu';

  @override
  String get seasonGrandPrixesEditorSuccessfullyAddedGrandPrix => 'Pomyślnie dodano grand prix do sezonu';

  @override
  String get seasonGrandPrixesResultsScreenTitle => 'Wyniki';

  @override
  String get seasonTeamsEditorScreenTitle => 'Nowy zespół w sezonie';

  @override
  String get seasonTeamsEditorAddSeasonTeam => 'Dodaj zespół do sezonu';

  @override
  String get seasonTeamsEditorTeam => 'Zespół';

  @override
  String get seasonTeamsEditorSelectTeam => 'Wybierz zespół';

  @override
  String get seasonTeamsEditorSeasonTeamDeletionConfirmationTitle => 'Usuwanie zespołu z sezonu';

  @override
  String seasonTeamsEditorSeasonTeamDeletionConfirmationMessage(String teamName, int season) {
    return 'Czy na pewno chcesz usunąć zespół $teamName z sezonu $season?';
  }

  @override
  String get seasonTeamsEditorSuccessfullyAddedTeam => 'Pomyślnie dodano zespół do sezonu';

  @override
  String get seasonTeamsEditorSuccessfullyDeletedSeasonTeam => 'Pomyślnie usunięto zespół z sezonu';

  @override
  String get teamsEditorScreenTitle => 'Edytuj zespoły';

  @override
  String get teamsEditorAddTeam => 'Dodaj zespół';

  @override
  String get teamsEditorTeam => 'Zespół';

  @override
  String get teamsEditorTeamName => 'Nazwa zespołu';

  @override
  String get teamsEditorTeamHexColor => 'Kolor zespołu';

  @override
  String get teamsEditorDeleteTeamConfirmationTitle => 'Usuwanie zespołu';

  @override
  String teamsEditorDeleteTeamConfirmationMessage(String teamName) {
    return 'Czy na pewno chcesz usunąć zespół $teamName?';
  }

  @override
  String get teamsEditorSuccessfullyAddedTeam => 'Pomyślnie dodano nowy zespół';

  @override
  String get teamsEditorSuccessfullyDeletedTeam => 'Pomyślnie usunięto zespół';

  @override
  String get season => 'Sezon';

  @override
  String get driverPersonalDataName => 'Imię';

  @override
  String get driverPersonalDataSurname => 'Nazwisko';

  @override
  String get requiredFieldInfo => 'To pole jest wymagane';

  @override
  String get add => 'Dodaj';

  @override
  String get delete => 'Usuń';

  @override
  String get cancel => 'Anuluj';

  @override
  String get close => 'Zamknij';

  @override
  String get save => 'Zapisz';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';
}
