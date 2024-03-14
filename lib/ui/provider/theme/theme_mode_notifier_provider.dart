import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/repository/auth/auth_repository.dart';
import '../../../data/repository/user/user_repository.dart';
import '../../../model/user.dart';

part 'theme_mode_notifier_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  String? _loggedUserId;

  @override
  Stream<ThemeMode> build() {
    return ref
        .watch(authRepositoryProvider)
        .loggedUserId$
        .doOnData((String? loggedUserId) {
          _loggedUserId = loggedUserId;
        })
        .switchMap(
          (String? loggedUserId) => loggedUserId != null
              ? ref
                  .watch(userRepositoryProvider)
                  .getUserById(userId: loggedUserId)
              : Stream.value(null),
        )
        .map((User? loggedUser) => loggedUser?.themeMode ?? ThemeMode.light);
  }

  void changeThemeMode(ThemeMode themeMode) async {
    state = AsyncData(themeMode);
    if (_loggedUserId != null) {
      await ref.read(userRepositoryProvider).updateUserData(
            userId: _loggedUserId!,
            themeMode: themeMode,
          );
    }
  }
}
