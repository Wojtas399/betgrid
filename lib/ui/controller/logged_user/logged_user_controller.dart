import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/exception/user_repository_exception.dart';
import '../../../data/repository/auth/auth_repository.dart';
import '../../../data/repository/user/user_repository.dart';
import '../../../model/user.dart';
import 'logged_user_controller_state.dart';

part 'logged_user_controller.g.dart';

@riverpod
class LoggedUserController extends _$LoggedUserController {
  @override
  Future<LoggedUserControllerState> build() async =>
      const LoggedUserControllerStateInitial();

  Future<void> addData({
    required String username,
    String? avatarImgPath,
    required ThemeMode themeMode,
    required ThemePrimaryColor themePrimaryColor,
  }) async {
    if (username.isEmpty) {
      _emitError(const LoggedUserControllerStateEmptyUsername());
      return;
    }
    final String? loggedUserId = await _loadLoggedUserId();
    if (loggedUserId == null) {
      _emitError(const LoggedUserControllerStateLoggedUserIdNotFound());
      return;
    }
    try {
      _emitLoading();
      await ref.read(userRepositoryProvider).addUser(
            userId: loggedUserId,
            username: username,
            avatarImgPath: avatarImgPath,
            themeMode: themeMode,
            themePrimaryColor: themePrimaryColor,
          );
      _emitData(const LoggedUserControllerStateDataSaved());
    } on UserRepositoryExceptionUsernameAlreadyTaken catch (_) {
      _emitError(const LoggedUserControllerStateNewUsernameIsAlreadyTaken());
    }
  }

  Future<void> updateUsername(String username) async {
    if (username.isEmpty) {
      _emitError(const LoggedUserControllerStateEmptyUsername());
      return;
    }
    final String? loggedUserId = await _loadLoggedUserId();
    if (loggedUserId == null) {
      _emitError(const LoggedUserControllerStateLoggedUserIdNotFound());
      return;
    }
    try {
      _emitLoading();
      await ref.read(userRepositoryProvider).updateUserData(
            userId: loggedUserId,
            username: username,
          );
      _emitData(const LoggedUserControllerStateUsernameUpdated());
    } on UserRepositoryExceptionUsernameAlreadyTaken catch (_) {
      _emitError(const LoggedUserControllerStateNewUsernameIsAlreadyTaken());
    }
  }

  Future<void> updateAvatar(String? newAvatarImgPath) async {
    final String? loggedUserId = await _loadLoggedUserId();
    if (loggedUserId != null) {
      _emitLoading();
      await ref.read(userRepositoryProvider).updateUserAvatar(
            userId: loggedUserId,
            avatarImgPath: newAvatarImgPath,
          );
      _emitData(const LoggedUserControllerStateAvatarUpdated());
    } else {
      _emitError(const LoggedUserControllerStateLoggedUserIdNotFound());
    }
  }

  Future<String?> _loadLoggedUserId() async =>
      await ref.watch(authRepositoryProvider).loggedUserId$.first;

  void _emitLoading() {
    state = const AsyncLoading<LoggedUserControllerState>();
  }

  void _emitData(LoggedUserControllerState controllerState) {
    state = AsyncData<LoggedUserControllerState>(controllerState);
  }

  void _emitError(LoggedUserControllerState controllerState) {
    state = AsyncError(controllerState, StackTrace.current);
  }
}
