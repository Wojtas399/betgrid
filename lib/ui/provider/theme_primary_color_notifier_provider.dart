import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../auth/auth_service.dart';
import '../../data/repository/user/user_repository.dart';
import '../../model/user.dart';

part 'theme_primary_color_notifier_provider.g.dart';

@riverpod
class ThemePrimaryColorNotifier extends _$ThemePrimaryColorNotifier {
  @override
  Stream<ThemePrimaryColor> build() {
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
        .map(
          (User? loggedUser) =>
              loggedUser?.themePrimaryColor ?? ThemePrimaryColor.defaultRed,
        );
  }

  void changeThemePrimaryColor(ThemePrimaryColor color) {
    state = AsyncData(color);
  }
}
