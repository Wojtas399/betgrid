import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver_details.dart';

part 'season_grand_prix_bet_editor_race_form.freezed.dart';

@freezed
class SeasonGrandPrixBetEditorRaceForm with _$SeasonGrandPrixBetEditorRaceForm {
  const SeasonGrandPrixBetEditorRaceForm._();

  const factory SeasonGrandPrixBetEditorRaceForm({
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    @Default([]) List<DriverDetails> dnfDrivers,
    bool? willBeRedFlag,
    bool? willBeSafetyCar,
  }) = _SeasonGrandPrixBetEditorRaceForm;

  SeasonGrandPrixBetEditorRaceForm removeFromPodiumOrP10IfExists(
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
