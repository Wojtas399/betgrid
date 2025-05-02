import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../model/grand_prix_basic_info.dart';

part 'new_season_grand_prix_dialog_state.freezed.dart';

enum NewSeasonGrandPrixDialogStateStatus {
  initial,
  formNotCompleted,
  completed,
  savingGrandPrix,
  grandPrixSaved,
}

extension NewSeasonGrandPrixDialogStateStatusX
    on NewSeasonGrandPrixDialogStateStatus {
  bool get isInitial => this == NewSeasonGrandPrixDialogStateStatus.initial;

  bool get isFormNotCompleted =>
      this == NewSeasonGrandPrixDialogStateStatus.formNotCompleted;

  bool get isSavingGrandPrix =>
      this == NewSeasonGrandPrixDialogStateStatus.savingGrandPrix;

  bool get isGrandPrixSaved =>
      this == NewSeasonGrandPrixDialogStateStatus.grandPrixSaved;
}

@freezed
abstract class NewSeasonGrandPrixDialogState
    with _$NewSeasonGrandPrixDialogState {
  const NewSeasonGrandPrixDialogState._();

  const factory NewSeasonGrandPrixDialogState({
    @Default(NewSeasonGrandPrixDialogStateStatus.initial)
    NewSeasonGrandPrixDialogStateStatus status,
    Iterable<GrandPrixBasicInfo>? grandPrixesToSelect,
    String? selectedGrandPrixId,
    int? roundNumber,
    DateTime? startDate,
    DateTime? endDate,
  }) = _NewSeasonGrandPrixDialogState;

  bool get isGrandPrixSelected => selectedGrandPrixId?.isNotEmpty == true;

  bool get isRoundNumberValid => roundNumber != null && roundNumber! > 0;

  bool get isStartDateValid => startDate != null;

  bool get isEndDateValid => endDate != null && endDate!.isAfter(startDate!);
}
