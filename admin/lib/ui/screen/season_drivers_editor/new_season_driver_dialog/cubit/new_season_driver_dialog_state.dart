import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../model/driver_personal_data.dart';
import '../../../../../model/season_team.dart';

part 'new_season_driver_dialog_state.freezed.dart';

enum NewSeasonDriverDialogStateStatus {
  loading,
  addingDriverToSeason,
  completed,
  driverAddedToSeason,
}

extension NewSeasonDriverDialogStateStatusExtensions
    on NewSeasonDriverDialogStateStatus {
  bool get isAddingDriverToSeason =>
      this == NewSeasonDriverDialogStateStatus.addingDriverToSeason;

  bool get hasNewDriverBeenAddedToSeason =>
      this == NewSeasonDriverDialogStateStatus.driverAddedToSeason;
}

@freezed
abstract class NewSeasonDriverDialogState with _$NewSeasonDriverDialogState {
  const factory NewSeasonDriverDialogState({
    @Default(NewSeasonDriverDialogStateStatus.loading)
    NewSeasonDriverDialogStateStatus status,
    List<DriverPersonalData>? driversToSelect,
    List<SeasonTeam>? teamsToSelect,
    String? selectedDriverId,
    int? driverNumber,
    String? selectedTeamId,
  }) = _NewSeasonDriverDialogState;
}
