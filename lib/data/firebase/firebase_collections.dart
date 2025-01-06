import 'package:injectable/injectable.dart';

@injectable
class FirebaseCollections {
  const FirebaseCollections();

  String get grandPrixesBasicInfo => 'GrandPrixesBasicInfo';
  String get seasonGrandPrixes => 'SeasonGrandPrixes';
  String get grandPrixesResults => 'GrandPrixResults';
  String get driversPersonalData => 'DriversPersonalData';
  String get seasonDrivers => 'SeasonDrivers';
  String get teamsBasicInfo => 'TeamsBasicInfo';
  UsersCollections get users => const UsersCollections();
}

class UsersCollections {
  const UsersCollections();

  String get main => 'Users';
  String get stats => 'Stats';
  String get grandPrixesBets => 'GrandPrixBets';
  String get grandPrixesBetPoints => 'GrandPrixBetPoints';
}
