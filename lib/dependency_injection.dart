import 'package:betgrid_shared/firebase/service/firebase_auth_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_driver_personal_data_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_grand_prix_basic_info_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_driver_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_grand_prix_bet_points_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_grand_prix_bet_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_grand_prix_results_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_grand_prix_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_user_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_user_stats_service.dart';
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

  FirebaseSeasonDriverService get fireSeasonDriverService =>
      FirebaseSeasonDriverService();

  FirebaseSeasonGrandPrixService get fireSeasonGrandPrixService =>
      FirebaseSeasonGrandPrixService();

  FirebaseUserService get fireUserService => FirebaseUserService();

  FirebaseSeasonGrandPrixBetService get fireSeasonGrandPrixBetService =>
      FirebaseSeasonGrandPrixBetService();

  FirebaseSeasonGrandPrixBetPointsService
      get fireSeasonGrandPrixBetPointsService =>
          FirebaseSeasonGrandPrixBetPointsService();

  FirebaseSeasonGrandPrixResultsService get fireSeasonGrandPrixResultsService =>
      FirebaseSeasonGrandPrixResultsService();

  FirebaseUserStatsService get fireUserStatsService =>
      FirebaseUserStatsService();
}
