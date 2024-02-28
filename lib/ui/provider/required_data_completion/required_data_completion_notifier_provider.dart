import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'required_data_completion_notifier_provider_state.dart';

part 'required_data_completion_notifier_provider.g.dart';

@riverpod
class RequiredDataCompletionNotifier extends _$RequiredDataCompletionNotifier {
  @override
  RequiredDataCompletionNotifierState build() {
    return const RequiredDataCompletionNotifierState();
  }

  void updateAvatarImgPath(String? avatarImgPath) {
    state = state.copyWith(avatarImgPath: avatarImgPath);
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }
}
