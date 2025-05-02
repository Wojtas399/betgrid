import 'package:freezed_annotation/freezed_annotation.dart';

import 'season_grand_prix_results_editor_state.dart';

part 'season_grand_prix_results_editor_race_form.freezed.dart';

@freezed
abstract class SeasonGrandPrixResultsEditorRaceForm
    with _$SeasonGrandPrixResultsEditorRaceForm {
  const SeasonGrandPrixResultsEditorRaceForm._();

  const factory SeasonGrandPrixResultsEditorRaceForm({
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    @Default([]) List<DriverDetails> dnfSeasonDrivers,
    bool? wasThereSafetyCar,
    bool? wasThereRedFlag,
  }) = _SeasonGrandPrixResultsEditorRaceForm;

  SeasonGrandPrixResultsEditorRaceForm removeFromPodiumOrP10IfExists(
    String seasonDriverId,
  ) {
    return copyWith(
      p1SeasonDriverId:
          p1SeasonDriverId == seasonDriverId ? null : p1SeasonDriverId,
      p2SeasonDriverId:
          p2SeasonDriverId == seasonDriverId ? null : p2SeasonDriverId,
      p3SeasonDriverId:
          p3SeasonDriverId == seasonDriverId ? null : p3SeasonDriverId,
      p10SeasonDriverId:
          p10SeasonDriverId == seasonDriverId ? null : p10SeasonDriverId,
    );
  }
}
