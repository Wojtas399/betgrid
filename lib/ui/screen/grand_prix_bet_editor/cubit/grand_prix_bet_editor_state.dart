import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver.dart';

part 'grand_prix_bet_editor_state.freezed.dart';

enum GrandPrixBetEditorStateStatus {
  loading,
  completed,
}

@freezed
class GrandPrixBetEditorState with _$GrandPrixBetEditorState {
  const factory GrandPrixBetEditorState({
    @Default(GrandPrixBetEditorStateStatus.loading)
    GrandPrixBetEditorStateStatus status,
    List<Driver>? allDrivers,
    @Default([
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ])
    List<String?> qualiStandingsByDriverIds,
    @Default(RaceForm()) RaceForm raceForm,
  }) = _GrandPrixBetEditorState;
}

class RaceForm extends Equatable {
  final String? p1DriverId;
  final String? p2DriverId;
  final String? p3DriverId;
  final String? p10DriverId;
  final String? fastestLapDriverId;
  final List<String> dnfDriverIds;
  final bool? willBeSafetyCar;
  final bool? willBeRedFlag;

  const RaceForm({
    this.p1DriverId,
    this.p2DriverId,
    this.p3DriverId,
    this.p10DriverId,
    this.fastestLapDriverId,
    this.dnfDriverIds = const [],
    this.willBeSafetyCar,
    this.willBeRedFlag,
  });

  @override
  List<Object?> get props => [
        p1DriverId,
        p2DriverId,
        p3DriverId,
        p10DriverId,
        fastestLapDriverId,
        dnfDriverIds,
        willBeSafetyCar,
        willBeRedFlag,
      ];
}
