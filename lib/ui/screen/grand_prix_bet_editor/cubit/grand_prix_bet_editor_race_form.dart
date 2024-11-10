import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver.dart';

part 'grand_prix_bet_editor_race_form.freezed.dart';

@freezed
class GrandPrixBetEditorRaceForm with _$GrandPrixBetEditorRaceForm {
  const factory GrandPrixBetEditorRaceForm({
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    @Default([]) List<Driver> dnfDrivers,
    bool? willBeRedFlag,
    bool? willBeSafetyCar,
  }) = _GrandPrixBetEditorRaceForm;
}
