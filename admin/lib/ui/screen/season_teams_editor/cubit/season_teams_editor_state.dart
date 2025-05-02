import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/team_basic_info.dart';

part 'season_teams_editor_state.freezed.dart';

enum SeasonTeamsEditorStateStatus {
  initial,
  completed,
  loading,
  seasonTeamDeleted,
}

extension SeasonTeamsEditorStateStatusExtensions
    on SeasonTeamsEditorStateStatus {
  bool get isInitial => this == SeasonTeamsEditorStateStatus.initial;

  bool get isLoading => this == SeasonTeamsEditorStateStatus.loading;

  bool get hasSeasonTeamBeenDeleted =>
      this == SeasonTeamsEditorStateStatus.seasonTeamDeleted;
}

@freezed
abstract class SeasonTeamsEditorState with _$SeasonTeamsEditorState {
  const factory SeasonTeamsEditorState({
    @Default(SeasonTeamsEditorStateStatus.initial)
    SeasonTeamsEditorStateStatus status,
    int? currentSeason,
    int? selectedSeason,
    List<TeamBasicInfo>? teamsFromSeason,
    bool? areThereOtherTeamsToAdd,
  }) = _SeasonTeamsEditorState;
}
