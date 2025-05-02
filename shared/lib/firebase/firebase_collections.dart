class FirebaseCollections {
  String get grandPrixesBasicInfo => 'GrandPrixesBasicInfo';
  String get driversPersonalData => 'DriversPersonalData';
  String get teamsBasicInfo => 'TeamsBasicInfo';
  FirebaseSeasonCollections get season => const FirebaseSeasonCollections();
  FirebaseUsersCollections get users => const FirebaseUsersCollections();
}

class FirebaseSeasonCollections {
  const FirebaseSeasonCollections();

  String get main => 'Season';
  String get drivers => 'Drivers';
  String get grandPrixes => 'GrandPrixes';
  String get grandPrixesResults => 'GrandPrixesResults';
  String get teams => 'Teams';
}

class FirebaseUsersCollections {
  const FirebaseUsersCollections();

  String get main => 'Users';
  FirebaseUsersSeasonCollections get season =>
      const FirebaseUsersSeasonCollections();
}

class FirebaseUsersSeasonCollections {
  const FirebaseUsersSeasonCollections();

  String get main => 'Season';
  String get grandPrixesBets => 'GrandPrixBets';
  String get grandPrixesBetPoints => 'GrandPrixBetPoints';
}
