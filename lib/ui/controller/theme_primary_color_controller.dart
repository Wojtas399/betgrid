import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/user/user_repository.dart';
import '../../model/user.dart';
import '../provider/logged_user_provider.dart';

part 'theme_primary_color_controller.g.dart';

@riverpod
class ThemePrimaryColorController extends _$ThemePrimaryColorController {
  String? _loggedUserId;

  @override
  Future<ThemePrimaryColor> build() async {
    final User? loggedUser = await ref.watch(loggedUserProvider.future);
    if (loggedUser != null) {
      _loggedUserId = loggedUser.id;
      return loggedUser.themePrimaryColor;
    }
    return ThemePrimaryColor.defaultRed;
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
