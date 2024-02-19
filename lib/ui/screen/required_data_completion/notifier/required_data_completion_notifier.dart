import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../auth/auth_service.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../model/user.dart';
import 'required_data_completion_notifier_state.dart';

part 'required_data_completion_notifier.g.dart';

@riverpod
class RequiredDataCompletionNotifier extends _$RequiredDataCompletionNotifier {
  @override
  Stream<RequiredDataCompletionNotifierState> build() async* {
    yield const RequiredDataCompletionNotifierState();
  }

  void updateAvatarImgPath(String? avatarImgPath) {
    state = AsyncData(state.value!.copyWith(
      avatarImgPath: avatarImgPath,
    ));
  }

  void updateUsername(String username) {
    state = AsyncData(state.value!.copyWith(
      username: username,
    ));
  }

  Future<void> submit({
    required ThemeMode themeMode,
    required ThemePrimaryColor themePrimaryColor,
  }) async {
    if (state.value!.username.isEmpty) {
      state = AsyncData(state.value!.copyWith(
        status: const RequiredDataCompletionNotifierStatusEmptyUsername(),
      ));
      return;
    }
    final String? loggedUserId =
        await ref.read(authServiceProvider).loggedUserId$.first;
    if (loggedUserId == null) {
      throw '[RequiredDataCompletionNotifierProvider] Logged user id not found';
    }
    state = AsyncData(state.value!.copyWith(
      status: const RequiredDataCompletionNotifierStatusSavingData(),
    ));
    await ref.read(userRepositoryProvider).addUser(
          userId: loggedUserId,
          username: state.value!.username,
          avatarImgPath: state.value!.avatarImgPath,
          themeMode: themeMode,
          themePrimaryColor: themePrimaryColor,
        );
    state = AsyncData(state.value!.copyWith(
      status: const RequiredDataCompletionNotifierStatusDataSaved(),
    ));
  }
}
