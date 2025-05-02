import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_driver_dialog_state.freezed.dart';

enum NewDriverDialogStateStatus {
  loading,
  formNotCompleted,
  completed,
  newDriverPersonalDataAdded,
}

extension NewDriverDialogStateStatusExtensions on NewDriverDialogStateStatus {
  bool get isFormNotCompleted =>
      this == NewDriverDialogStateStatus.formNotCompleted;

  bool get isLoading => this == NewDriverDialogStateStatus.loading;

  bool get hasNewDriverPersonalDataBeenAdded =>
      this == NewDriverDialogStateStatus.newDriverPersonalDataAdded;
}

@freezed
abstract class NewDriverDialogState with _$NewDriverDialogState {
  const NewDriverDialogState._();

  const factory NewDriverDialogState({
    @Default(NewDriverDialogStateStatus.loading)
    NewDriverDialogStateStatus status,
    @Default('') String name,
    @Default('') String surname,
  }) = _NewDriverDialogState;

  bool get isNameEmpty => name.isEmpty;

  bool get isSurnameEmpty => surname.isEmpty;
}
