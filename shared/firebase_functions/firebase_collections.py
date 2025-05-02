class FirebaseSeasonCollections:
    MAIN = "Season"
    DRIVERS = "Drivers"
    GRAND_PRIXES = "GrandPrixes"
    GRAND_PRIXES_RESULTS = "GrandPrixesResults"
    TEAMS = "Teams"


class FirebaseUserSeasonCollections:
    MAIN = "Season"
    GRAND_PRIX_BETS = "GrandPrixBets"
    GRAND_PRIX_BETS_POINTS = "GrandPrixBetPoints"


class FirebaseUsersCollections:
    MAIN = "Users"
    SEASON = FirebaseUserSeasonCollections()


class FirebaseCollections:
    GRAND_PRIXES_BASIC_INFO = "GrandPrixesBasicInfo"
    DRIVERS_PERSONAL_DATA = "DriversPersonalData"
    TEAMS_BASIC_INFO = "TeamsBasicInfo"
    SEASON = FirebaseSeasonCollections()
    USERS = FirebaseUsersCollections()
