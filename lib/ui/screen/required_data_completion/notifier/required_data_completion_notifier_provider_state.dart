import 'package:freezed_annotation/freezed_annotation.dart';

part 'required_data_completion_notifier_provider_state.freezed.dart';

@freezed
class RequiredDataCompletionNotifierState
    with _$RequiredDataCompletionNotifierState {
  const factory RequiredDataCompletionNotifierState({
    String? avatarImgPath,
    @Default('') String username,
  }) = _RequiredDataCompletionNotifierState;
}
