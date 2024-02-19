import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'required_data_completion_notifier_state.freezed.dart';

@freezed
class RequiredDataCompletionNotifierState
    with _$RequiredDataCompletionNotifierState {
  const factory RequiredDataCompletionNotifierState({
    @Default(RequiredDataCompletionNotifierStatusCompleted())
    RequiredDataCompletionNotifierStatus status,
    String? avatarImgPath,
    @Default('') String username,
  }) = _RequiredDataCompletionNotifierState;
}

abstract class RequiredDataCompletionNotifierStatus extends Equatable {
  const RequiredDataCompletionNotifierStatus();

  @override
  List<Object?> get props => [];
}

class RequiredDataCompletionNotifierStatusSavingData
    extends RequiredDataCompletionNotifierStatus {
  const RequiredDataCompletionNotifierStatusSavingData();
}

class RequiredDataCompletionNotifierStatusCompleted
    extends RequiredDataCompletionNotifierStatus {
  const RequiredDataCompletionNotifierStatusCompleted();
}

class RequiredDataCompletionNotifierStatusEmptyUsername
    extends RequiredDataCompletionNotifierStatus {
  const RequiredDataCompletionNotifierStatusEmptyUsername();
}

class RequiredDataCompletionNotifierStatusDataSaved
    extends RequiredDataCompletionNotifierStatus {
  const RequiredDataCompletionNotifierStatusDataSaved();
}
