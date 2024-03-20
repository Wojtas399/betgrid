import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/user/user_repository.dart';
import '../../model/user.dart';
import '../provider/logged_user_provider.dart';

part 'theme_mode_controller.g.dart';

@riverpod
class ThemeModeController extends _$ThemeModeController {
  String? _loggedUserId;

  @override
  Future<ThemeMode> build() async {
    final User? loggedUser = await ref.watch(loggedUserProvider.future);
    if (loggedUser != null) {
      _loggedUserId = loggedUser.id;
      return loggedUser.themeMode;
    }
    return ThemeMode.system;
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
