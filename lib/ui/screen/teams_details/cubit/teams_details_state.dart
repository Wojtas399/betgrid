import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/season_team.dart';

part 'teams_details_state.freezed.dart';

@freezed
sealed class TeamsDetailsState with _$TeamsDetailsState {
  const TeamsDetailsState._();

  const factory TeamsDetailsState.initial() = TeamsDetailsStateInitial;
  const factory TeamsDetailsState.loaded({
    @Default([]) List<SeasonTeam> teams,
  }) = TeamsDetailsStateLoaded;

  TeamsDetailsStateLoaded get loaded => this as TeamsDetailsStateLoaded;
}
