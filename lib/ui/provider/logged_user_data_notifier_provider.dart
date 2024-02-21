import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../auth/auth_service.dart';
import '../../data/repository/user/user_repository.dart';
import '../../model/user.dart';

part 'logged_user_data_notifier_provider.g.dart';

@riverpod
class LoggedUserDataNotifier extends _$LoggedUserDataNotifier {
  String? _loggedUserId;

  @override
  Stream<User?> build() {
    return ref.watch(authServiceProvider).loggedUserId$.doOnData(
      (String? loggedUserId) {
        _loggedUserId = loggedUserId;
      },
    ).switchMap(
      (String? loggedUserId) => loggedUserId != null
          ? ref.watch(userRepositoryProvider).getUserById(userId: loggedUserId)
          : Stream.value(null),
    );
  }

  Future<void> addLoggedUserData({
    required String username,
    String? avatarImgPath,
    required ThemeMode themeMode,
    required ThemePrimaryColor themePrimaryColor,
  }) async {
    if (_loggedUserId != null) {
      await ref.read(userRepositoryProvider).addUser(
            userId: _loggedUserId!,
            username: username,
            avatarImgPath: avatarImgPath,
            themeMode: themeMode,
            themePrimaryColor: themePrimaryColor,
          );
    }
  }
}
