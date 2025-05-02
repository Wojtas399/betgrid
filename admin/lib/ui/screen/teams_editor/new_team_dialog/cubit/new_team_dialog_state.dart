import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_team_dialog_state.freezed.dart';

enum NewTeamDialogStateStatus {
  loading,
  formNotCompleted,
  completed,
  teamBasicInfoAdded,
}

extension NewTeamDialogStateStatusExtensions on NewTeamDialogStateStatus {
  bool get isLoading => this == NewTeamDialogStateStatus.loading;

  bool get isFormNotCompleted =>
      this == NewTeamDialogStateStatus.formNotCompleted;

  bool get hasNewTeamBasicInfoBeenAdded =>
      this == NewTeamDialogStateStatus.teamBasicInfoAdded;
}

@freezed
abstract class NewTeamDialogState with _$NewTeamDialogState {
  const NewTeamDialogState._();

  const factory NewTeamDialogState({
    @Default(NewTeamDialogStateStatus.loading) NewTeamDialogStateStatus status,
    @Default('') String name,
    @Default('') String hexColor,
  }) = _NewTeamDialogState;

  bool get isNameEmpty => name.isEmpty;

  bool get isHexColorEmpty => hexColor.isEmpty;
}
