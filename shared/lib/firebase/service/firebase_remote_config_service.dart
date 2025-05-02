import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  final _rc = FirebaseRemoteConfig.instance;

  String get clientAppVersion => _rc.getString('client_app_version');
}
