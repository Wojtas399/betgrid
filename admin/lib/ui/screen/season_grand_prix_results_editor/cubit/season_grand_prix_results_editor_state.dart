import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/season_grand_prix_results.dart';
import 'season_grand_prix_results_editor_race_form.dart';

part 'season_grand_prix_results_editor_state.freezed.dart';

enum SeasonGrandPrixResultsEditorStateActionStatus { initial, saving, saved }

@freezed
sealed class SeasonGrandPrixResultsEditorState
    with _$SeasonGrandPrixResultsEditorState {
  const SeasonGrandPrixResultsEditorState._();

  const factory SeasonGrandPrixResultsEditorState.initial() =
      SeasonGrandPrixResultsEditorStateInitial;
  const factory SeasonGrandPrixResultsEditorState.loaded({
    @Default(SeasonGrandPrixResultsEditorStateActionStatus.initial)
    SeasonGrandPrixResultsEditorStateActionStatus actionStatus,
    SeasonGrandPrixResults? originalSeasonGrandPrixResults,
    String? grandPrixName,
    List<DriverDetails>? allSeasonDrivers,
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
    @Default(SeasonGrandPrixResultsEditorRaceForm())
    SeasonGrandPrixResultsEditorRaceForm raceForm,
  }) = SeasonGrandPrixResultsEditorStateLoaded;

  bool get canSave => _haveQualiBetsBeenChanged || _haveRaceBetsBeenChanged;

  bool get _haveQualiBetsBeenChanged {
    final SeasonGrandPrixResultsEditorState state = this;

    if (state is SeasonGrandPrixResultsEditorStateLoaded) {
      if (state.originalSeasonGrandPrixResults != null) {
        return !const ListEquality().equals(
          state.originalSeasonGrandPrixResults!.qualiStandingsBySeasonDriverIds,
          state.qualiStandingsBySeasonDriverIds,
        );
      }

      final String? firstNotNullSeasonDriverId = state
          .qualiStandingsBySeasonDriverIds
          .firstWhereOrNull((String? driverId) => driverId != null);
      final bool isAtLeastOnePositionPredicted =
          firstNotNullSeasonDriverId != null;

      return isAtLeastOnePositionPredicted;
    }

    return false;
  }

  bool get _haveRaceBetsBeenChanged {
    final SeasonGrandPrixResultsEditorState state = this;

    if (state is SeasonGrandPrixResultsEditorStateLoaded) {
      final SeasonGrandPrixResultsEditorRaceForm raceForm = state.raceForm;
      final SeasonGrandPrixResults? originalSeasonGrandPrixResults =
          state.originalSeasonGrandPrixResults;

      return raceForm.p1SeasonDriverId !=
              originalSeasonGrandPrixResults?.p1SeasonDriverId ||
          raceForm.p2SeasonDriverId !=
              originalSeasonGrandPrixResults?.p2SeasonDriverId ||
          raceForm.p3SeasonDriverId !=
              originalSeasonGrandPrixResults?.p3SeasonDriverId ||
          raceForm.p10SeasonDriverId !=
              originalSeasonGrandPrixResults?.p10SeasonDriverId ||
          raceForm.fastestLapSeasonDriverId !=
              originalSeasonGrandPrixResults?.fastestLapSeasonDriverId ||
          _haveDnfSeasonDriverIdsBeenChanged ||
          raceForm.wasThereSafetyCar !=
              originalSeasonGrandPrixResults?.wasThereSafetyCar ||
          raceForm.wasThereRedFlag !=
              originalSeasonGrandPrixResults?.wasThereRedFlag;
    }

    return false;
  }

  bool get _haveDnfSeasonDriverIdsBeenChanged {
    final SeasonGrandPrixResultsEditorState state = this;

    if (state is SeasonGrandPrixResultsEditorStateLoaded) {
      final SeasonGrandPrixResults? originalSeasonGrandPrixResults =
          state.originalSeasonGrandPrixResults;

      if (originalSeasonGrandPrixResults == null) {
        return state.raceForm.dnfSeasonDrivers.isNotEmpty == true;
      }

      final List<String> originalDnfSeasonDriverIds =
          originalSeasonGrandPrixResults.dnfSeasonDriverIds ?? [];
      final List<String> newDnfSeasonDriverIds =
          state.raceForm.dnfSeasonDrivers
              .map(
                (DriverDetails driverDetails) => driverDetails.seasonDriverId,
              )
              .toList();

      if (originalDnfSeasonDriverIds.length != newDnfSeasonDriverIds.length) {
        return true;
      }
      for (final driverId in newDnfSeasonDriverIds) {
        if (!originalDnfSeasonDriverIds.contains(driverId)) return true;
      }

      return false;
    }

    return false;
  }
}

class DriverDetails extends Equatable {
  final String seasonDriverId;
  final String name;
  final String surname;
  final int number;
  final String teamName;
  final String teamHexColor;

  const DriverDetails({
    required this.seasonDriverId,
    required this.name,
    required this.surname,
    required this.number,
    required this.teamName,
    required this.teamHexColor,
  });

  @override
  List<Object?> get props => [
    seasonDriverId,
    name,
    surname,
    number,
    teamName,
    teamHexColor,
  ];
}
