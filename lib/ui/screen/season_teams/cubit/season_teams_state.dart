import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/season_team.dart';

part 'season_teams_state.freezed.dart';

@freezed
sealed class SeasonTeamsState with _$SeasonTeamsState {
  const SeasonTeamsState._();

  const factory SeasonTeamsState.initial() = SeasonTeamsStateInitial;
  const factory SeasonTeamsState.loaded({@Default([]) List<SeasonTeam> teams}) =
      SeasonTeamsStateLoaded;

  SeasonTeamsStateLoaded get loaded => this as SeasonTeamsStateLoaded;
}
