import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../auth/auth_service.dart';
import '../../data/repository/user/user_repository.dart';
import '../../model/user.dart';

part 'theme_primary_color_notifier_provider.g.dart';

@riverpod
class ThemePrimaryColorNotifier extends _$ThemePrimaryColorNotifier {
  String? _loggedUserId;

  @override
  Stream<ThemePrimaryColor> build() {
    return ref
        .watch(authServiceProvider)
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
        .map(
          (User? loggedUser) =>
              loggedUser?.themePrimaryColor ?? ThemePrimaryColor.defaultRed,
        );
  }

  void changeThemePrimaryColor(ThemePrimaryColor color) async {
    state = AsyncData(color);
    if (_loggedUserId != null) {
      await ref.read(userRepositoryProvider).updateUserData(
            userId: _loggedUserId!,
            themePrimaryColor: color,
          );
    }
  }
}
