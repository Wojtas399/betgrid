import 'package:betgrid_shared/firebase/service/firebase_auth_service.dart';
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
  FirebaseAuthService get firebaseAuthService => FirebaseAuthService();
}
