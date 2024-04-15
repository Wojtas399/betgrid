import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'required_data_completion_controller_state.dart';

part 'required_data_completion_controller.g.dart';

@riverpod
class RequiredDataCompletionController
    extends _$RequiredDataCompletionController {
  @override
  RequiredDataCompletionControllerState build() =>
      const RequiredDataCompletionControllerState();

  void updateAvatarImgPath(String? avatarImgPath) {
    state = state.copyWith(avatarImgPath: avatarImgPath);
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }
}
