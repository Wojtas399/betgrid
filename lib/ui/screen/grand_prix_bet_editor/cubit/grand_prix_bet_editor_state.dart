import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver.dart';
import '../../../../model/grand_prix_bet.dart';
import 'grand_prix_bet_editor_race_form.dart';

part 'grand_prix_bet_editor_state.freezed.dart';

enum GrandPrixBetEditorStateStatus {
  initializing,
  completed,
  saving,
  successfullySaved,
}

@freezed
class GrandPrixBetEditorState with _$GrandPrixBetEditorState {
  final int _maxNumberOfDnfDriverPredictions = 3;

  const GrandPrixBetEditorState._();

  const factory GrandPrixBetEditorState({
    @Assert('qualiStandingsByDriverIds.length == 20')
    @Default(GrandPrixBetEditorStateStatus.initializing)
    GrandPrixBetEditorStateStatus status,
    GrandPrixBet? originalGrandPrixBet,
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
    @Default(GrandPrixBetEditorRaceForm()) GrandPrixBetEditorRaceForm raceForm,
  }) = _GrandPrixBetEditorState;

  bool get canSelectNextDnfDriver =>
      raceForm.dnfDrivers.length < _maxNumberOfDnfDriverPredictions;

  bool get canSave => _haveQualiBetsBeenChanged || _haveRaceBetsBeenChanged;

  bool get _haveQualiBetsBeenChanged {
    if (originalGrandPrixBet == null) {
      final String? firstNotNullDriverId =
          qualiStandingsByDriverIds.firstWhereOrNull(
        (String? driverId) => driverId != null,
      );
      final bool isAtLeastOnePositionPredicted = firstNotNullDriverId != null;
      return isAtLeastOnePositionPredicted;
    } else {
      return !const ListEquality().equals(
        originalGrandPrixBet!.qualiStandingsByDriverIds,
        qualiStandingsByDriverIds,
      );
    }
  }

  bool get _haveRaceBetsBeenChanged =>
      raceForm.p1DriverId != originalGrandPrixBet?.p1DriverId ||
      raceForm.p2DriverId != originalGrandPrixBet?.p2DriverId ||
      raceForm.p3DriverId != originalGrandPrixBet?.p3DriverId ||
      raceForm.p10DriverId != originalGrandPrixBet?.p10DriverId ||
      raceForm.fastestLapDriverId != originalGrandPrixBet?.fastestLapDriverId ||
      _haveDnfDriverIdsBeenChanged ||
      raceForm.willBeSafetyCar != originalGrandPrixBet?.willBeSafetyCar ||
      raceForm.willBeRedFlag != originalGrandPrixBet?.willBeRedFlag;

  bool get _haveDnfDriverIdsBeenChanged {
    if (originalGrandPrixBet == null) return raceForm.dnfDrivers.isNotEmpty;
    final Iterable<String> originalDnfDriverIds =
        originalGrandPrixBet!.dnfDriverIds.whereNotNull();
    final Iterable<String> newDnfDriverIds = raceForm.dnfDrivers.map(
      (Driver driver) => driver.seasonDriverId,
    );
    if (originalDnfDriverIds.length != newDnfDriverIds.length) return true;
    for (final driverId in newDnfDriverIds) {
      if (!originalDnfDriverIds.contains(driverId)) return true;
    }
    return false;
  }
}
