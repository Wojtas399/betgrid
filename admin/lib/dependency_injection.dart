import 'package:betgrid_shared/betgrid_shared.dart';
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

  FirebaseSeasonDriverService get firebaseSeasonDriverService =>
      FirebaseSeasonDriverService();

  FirebaseSeasonGrandPrixService get firebaseSeasonGrandPrixService =>
      FirebaseSeasonGrandPrixService();

  FirebaseSeasonTeamService get firebaseSeasonTeamService =>
      FirebaseSeasonTeamService();

  FirebaseSeasonGrandPrixResultsService
  get firebaseSeasonGrandPrixResultsService =>
      FirebaseSeasonGrandPrixResultsService();

  FirebaseStorageService get firebaseStorageService => FirebaseStorageService();
}
