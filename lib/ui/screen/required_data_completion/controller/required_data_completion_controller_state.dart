import 'package:freezed_annotation/freezed_annotation.dart';

part 'required_data_completion_controller_state.freezed.dart';

@freezed
class RequiredDataCompletionControllerState
    with _$RequiredDataCompletionControllerState {
  const factory RequiredDataCompletionControllerState({
    String? avatarImgPath,
    @Default('') String username,
  }) = _RequiredDataCompletionControllerState;
}
