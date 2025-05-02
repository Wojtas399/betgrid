import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_grand_prix_dialog_state.freezed.dart';

enum NewGrandPrixDialogStateStatus {
  initial,
  formNotCompleted,
  completed,
  loading,
  newGrandPrixAdded,
}

extension NewGrandPrixDialogStateStatusX on NewGrandPrixDialogStateStatus {
  bool get isFormNotCompleted =>
      this == NewGrandPrixDialogStateStatus.formNotCompleted;

  bool get isLoading => this == NewGrandPrixDialogStateStatus.loading;

  bool get hasNewGrandPrixBeenAdded =>
      this == NewGrandPrixDialogStateStatus.newGrandPrixAdded;
}

@freezed
abstract class NewGrandPrixDialogState with _$NewGrandPrixDialogState {
  const NewGrandPrixDialogState._();

  const factory NewGrandPrixDialogState({
    @Default(NewGrandPrixDialogStateStatus.initial)
    NewGrandPrixDialogStateStatus status,
    @Default('') String grandPrixName,
    @Default('') String countryAlpha2Code,
  }) = _NewGrandPrixDialogState;

  bool get isGrandPrixNameEmpty => grandPrixName.isEmpty;

  bool get isCountryAlpha2CodeEmpty => countryAlpha2Code.isEmpty;
}
