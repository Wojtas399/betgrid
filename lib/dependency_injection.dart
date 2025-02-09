import 'package:betgrid_shared/firebase/service/firebase_auth_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_driver_personal_data_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_grand_prix_basic_info_service.dart';
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
}
