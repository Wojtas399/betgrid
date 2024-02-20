import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../auth/auth_service.dart';
import '../../data/repository/user/user_repository.dart';
import '../../model/user.dart';

part 'theme_mode_notifier_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  Stream<ThemeMode> build() {
    return ref
        .watch(authServiceProvider)
        .loggedUserId$
        .switchMap(
          (String? loggedUserId) => loggedUserId != null
              ? ref
                  .watch(userRepositoryProvider)
                  .getUserById(userId: loggedUserId)
              : Stream.value(null),
        )
        .map((User? loggedUser) => loggedUser?.themeMode ?? ThemeMode.light);
  }

  void changeThemeMode(ThemeMode mode) {
    state = AsyncData(mode);
  }
}
