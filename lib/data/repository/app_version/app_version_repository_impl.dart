import 'package:betgrid_shared/firebase/service/firebase_remote_config_service.dart';
import 'package:injectable/injectable.dart';

import 'app_version_repository.dart';

@LazySingleton(as: AppVersionRepository)
class AppVersionRepositoryImpl implements AppVersionRepository {
  final FirebaseRemoteConfigService _fireRemoteConfigService;

  AppVersionRepositoryImpl(this._fireRemoteConfigService);

  @override
  String getCurrentAppVersion() {
    return _fireRemoteConfigService.clientAppVersion;
  }
}
