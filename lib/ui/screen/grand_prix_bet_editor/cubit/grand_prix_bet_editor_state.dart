import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver_details.dart';
import '../../../../model/season_grand_prix_bet.dart';
import 'grand_prix_bet_editor_race_form.dart';

part 'grand_prix_bet_editor_state.freezed.dart';

enum GrandPrixBetEditorStateStatus {
  initial,
  completed,
  saving,
  successfullySaved,
}

extension GrandPrixBetEditorStateStatusX on GrandPrixBetEditorStateStatus {
  bool get isInitial => this == GrandPrixBetEditorStateStatus.initial;
}

@freezed
class GrandPrixBetEditorState with _$GrandPrixBetEditorState {
  final int _maxNumberOfDnfDriverPredictions = 3;

  const GrandPrixBetEditorState._();

  const factory GrandPrixBetEditorState({
    @Assert('qualiStandingsBySeasonDriverIds.length == 20')
    @Default(GrandPrixBetEditorStateStatus.initial)
    GrandPrixBetEditorStateStatus status,
    SeasonGrandPrixBet? originalSeasonGrandPrixBet,
    List<DriverDetails>? allDrivers,
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
    List<String?> qualiStandingsBySeasonDriverIds,
    @Default(GrandPrixBetEditorRaceForm()) GrandPrixBetEditorRaceForm raceForm,
  }) = _GrandPrixBetEditorState;

  bool get canSelectNextDnfDriver =>
      raceForm.dnfDrivers.length < _maxNumberOfDnfDriverPredictions;

  bool get canSave => _haveQualiBetsBeenChanged || _haveRaceBetsBeenChanged;

  bool get _haveQualiBetsBeenChanged {
    if (originalSeasonGrandPrixBet == null) {
      final String? firstNotNullSeasonDriverId =
          qualiStandingsBySeasonDriverIds.firstWhereOrNull(
        (String? driverId) => driverId != null,
      );
      final bool isAtLeastOnePositionPredicted =
          firstNotNullSeasonDriverId != null;
      return isAtLeastOnePositionPredicted;
    } else {
      return !const ListEquality().equals(
        originalSeasonGrandPrixBet!.qualiStandingsBySeasonDriverIds,
        qualiStandingsBySeasonDriverIds,
      );
    }
  }

  bool get _haveRaceBetsBeenChanged =>
      raceForm.p1SeasonDriverId !=
          originalSeasonGrandPrixBet?.p1SeasonDriverId ||
      raceForm.p2SeasonDriverId !=
          originalSeasonGrandPrixBet?.p2SeasonDriverId ||
      raceForm.p3SeasonDriverId !=
          originalSeasonGrandPrixBet?.p3SeasonDriverId ||
      raceForm.p10SeasonDriverId !=
          originalSeasonGrandPrixBet?.p10SeasonDriverId ||
      raceForm.fastestLapSeasonDriverId !=
          originalSeasonGrandPrixBet?.fastestLapSeasonDriverId ||
      _haveDnfSeasonDriverIdsBeenChanged ||
      raceForm.willBeSafetyCar != originalSeasonGrandPrixBet?.willBeSafetyCar ||
      raceForm.willBeRedFlag != originalSeasonGrandPrixBet?.willBeRedFlag;

  bool get _haveDnfSeasonDriverIdsBeenChanged {
    if (originalSeasonGrandPrixBet == null) {
      return raceForm.dnfDrivers.isNotEmpty;
    }
    final Iterable<String> originalDnfSeasonDriverIds =
        originalSeasonGrandPrixBet!.dnfSeasonDriverIds.whereType<String>();
    final Iterable<String> newDnfSeasonDriverIds = raceForm.dnfDrivers.map(
      (DriverDetails driver) => driver.seasonDriverId,
    );
    if (originalDnfSeasonDriverIds.length != newDnfSeasonDriverIds.length) {
      return true;
    }
    for (final driverId in newDnfSeasonDriverIds) {
      if (!originalDnfSeasonDriverIds.contains(driverId)) return true;
    }
    return false;
  }
}
