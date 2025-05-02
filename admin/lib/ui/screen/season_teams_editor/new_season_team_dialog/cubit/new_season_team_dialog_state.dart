import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../model/team_basic_info.dart';

part 'new_season_team_dialog_state.freezed.dart';

enum NewSeasonTeamDialogStateStatus {
  initial,
  loading,
  completed,
  teamAddedToSeason,
}

extension NewSeasonTeamDialogStateStatusExtensions
    on NewSeasonTeamDialogStateStatus {
  bool get isInitial => this == NewSeasonTeamDialogStateStatus.initial;

  bool get isLoading => this == NewSeasonTeamDialogStateStatus.loading;

  bool get hasNewTeamBeenAddedToSeason =>
      this == NewSeasonTeamDialogStateStatus.teamAddedToSeason;
}

@freezed
abstract class NewSeasonTeamDialogState with _$NewSeasonTeamDialogState {
  const factory NewSeasonTeamDialogState({
    @Default(NewSeasonTeamDialogStateStatus.initial)
    NewSeasonTeamDialogStateStatus status,
    List<TeamBasicInfo>? teamsToSelect,
    String? selectedTeamId,
  }) = _NewSeasonTeamDialogState;
}
