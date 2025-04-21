import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../data/repository/app_version/app_version_repository.dart';
import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../model/auth_state.dart';
import '../../../../model/version.dart';
import 'splash_state.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final AppVersionRepository _appVersionRepository;
  final AuthRepository _authRepository;

  SplashCubit(this._appVersionRepository, this._authRepository)
    : super(const SplashState.initial());

  Future<void> init() async {
    emit(const SplashState.loading(progress: 0.1));

    final packageInfo = await PackageInfo.fromPlatform();
    final installedVersion = Version.fromString(packageInfo.version);
    final latestVersion = Version.fromString(
      _appVersionRepository.getCurrentAppVersion(),
    );

    if (latestVersion.isNewerThan(installedVersion)) {
      emit(const SplashState.newAppVersionAvailable());
      return;
    }

    emit(const SplashState.loading(progress: 0.5));

    final auth = await _authRepository.authState$.first;
    emit(const SplashState.loading(progress: 1));

    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      SplashState.loaded(
        isLoggedIn: switch (auth) {
          AuthStateUserIsSignedIn() => true,
          AuthStateUserIsSignedOut() => false,
        },
      ),
    );
  }
}
