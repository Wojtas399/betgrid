import 'package:betgrid_shared/betgrid_shared.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'dependency_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.init();
}

@module
abstract class FirebaseModule {
  FirebaseAuthService get fireAuthService => FirebaseAuthService();

  FirebaseDriverPersonalDataService get fireDriverPersonalDataService =>
      FirebaseDriverPersonalDataService();

  FirebaseGrandPrixBasicInfoService get fireGrandPrixBasicInfoService =>
      FirebaseGrandPrixBasicInfoService();

  FirebaseSeasonTeamService get fireSeasonTeamService =>
      FirebaseSeasonTeamService();

  FirebaseSeasonDriverService get fireSeasonDriverService =>
      FirebaseSeasonDriverService();

  FirebaseSeasonGrandPrixService get fireSeasonGrandPrixService =>
      FirebaseSeasonGrandPrixService();

  FirebaseUserService get fireUserService => FirebaseUserService();

  FirebaseAvatarService get fireAvatarService => FirebaseAvatarService();

  FirebaseSeasonGrandPrixBetService get fireSeasonGrandPrixBetService =>
      FirebaseSeasonGrandPrixBetService();

  FirebaseSeasonGrandPrixBetPointsService
  get fireSeasonGrandPrixBetPointsService =>
      FirebaseSeasonGrandPrixBetPointsService();

  FirebaseSeasonGrandPrixResultsService get fireSeasonGrandPrixResultsService =>
      FirebaseSeasonGrandPrixResultsService();

  FirebaseUserStatsService get fireUserStatsService =>
      FirebaseUserStatsService();

  FirebaseStorageService get fireStorageService => FirebaseStorageService();

  FirebaseRemoteConfigService get fireRemoteConfig =>
      FirebaseRemoteConfigService();
}
