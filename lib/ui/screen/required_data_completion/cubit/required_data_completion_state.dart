import 'package:freezed_annotation/freezed_annotation.dart';

part 'required_data_completion_state.freezed.dart';

enum RequiredDataCompletionStateStatus {
  loading,
  completed,
  loggedUserDoesNotExist,
  usernameIsEmpty,
  usernameIsAlreadyTaken,
  dataSaved,
}

@freezed
class RequiredDataCompletionState with _$RequiredDataCompletionState {
  const RequiredDataCompletionState._();

  const factory RequiredDataCompletionState({
    @Default(RequiredDataCompletionStateStatus.completed)
    RequiredDataCompletionStateStatus status,
    String? avatarImgPath,
    @Default('') String username,
  }) = _RequiredDataCompletionState;

  bool get doesAvatarExist => avatarImgPath != null;
}
