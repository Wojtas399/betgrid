import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver_personal_data.dart';

part 'drivers_editor_state.freezed.dart';

enum DriversEditorStateStatus { initial, completed, loading, driverDeleted }

extension DriversEditorStateStatusExtensions on DriversEditorStateStatus {
  bool get isInitial => this == DriversEditorStateStatus.initial;

  bool get isLoading => this == DriversEditorStateStatus.loading;

  bool get isDriverDeleted => this == DriversEditorStateStatus.driverDeleted;
}

@freezed
abstract class DriversEditorState with _$DriversEditorState {
  const factory DriversEditorState({
    @Default(DriversEditorStateStatus.initial) DriversEditorStateStatus status,
    List<DriverPersonalData>? drivers,
  }) = _DriversEditorState;
}
