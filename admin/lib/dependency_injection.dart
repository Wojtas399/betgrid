import 'package:betgrid_shared/firebase/service/firebase_auth_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_driver_personal_data_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_grand_prix_basic_info_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_driver_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_grand_prix_results_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_grand_prix_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_team_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_team_basic_info_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'dependency_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  getIt.init();
}

@module
abstract class FirebaseDeps {
  FirebaseAuthService get firebaseAuthService => FirebaseAuthService();

  FirebaseDriverPersonalDataService get firebaseDriverPersonalDataService =>
      FirebaseDriverPersonalDataService();

  FirebaseGrandPrixBasicInfoService get firebaseGrandPrixBasicInfoService =>
      FirebaseGrandPrixBasicInfoService();

  FirebaseTeamBasicInfoService get firebaseTeamBasicInfoService =>
      FirebaseTeamBasicInfoService();

  FirebaseSeasonDriverService get firebaseSeasonDriverService =>
      FirebaseSeasonDriverService();

  FirebaseSeasonGrandPrixService get firebaseSeasonGrandPrixService =>
      FirebaseSeasonGrandPrixService();

  FirebaseSeasonTeamService get firebaseSeasonTeamService =>
      FirebaseSeasonTeamService();

  FirebaseSeasonGrandPrixResultsService
  get firebaseSeasonGrandPrixResultsService =>
      FirebaseSeasonGrandPrixResultsService();
}
