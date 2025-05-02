import 'package:freezed_annotation/freezed_annotation.dart';

part 'required_data_completion_state.freezed.dart';

enum RequiredDataCompletionStateStatus {
  loading,
  completed,
  usernameIsEmpty,
  usernameIsAlreadyTaken,
  dataSaved,
}

extension RequiredDataCompletionStateStatusExtensions
    on RequiredDataCompletionStateStatus {
  bool get isLoading => this == RequiredDataCompletionStateStatus.loading;

  bool get isUsernameEmpty =>
      this == RequiredDataCompletionStateStatus.usernameIsEmpty;

  bool get isUsernameAlreadyTaken =>
      this == RequiredDataCompletionStateStatus.usernameIsAlreadyTaken;

  bool get hasDataBeenSaved =>
      this == RequiredDataCompletionStateStatus.dataSaved;
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
