import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/season_team.dart';

part 'season_team_details_state.freezed.dart';

@freezed
class SeasonTeamDetailsState with _$SeasonTeamDetailsState {
  const SeasonTeamDetailsState._();

  const factory SeasonTeamDetailsState.initial() =
      SeasonTeamDetailsStateInitial;
  const factory SeasonTeamDetailsState.loaded({
    required SeasonTeam team,
    required List<SeasonTeamDetailsDriverInfo> drivers,
  }) = SeasonTeamDetailsStateLoaded;

  SeasonTeamDetailsStateLoaded get loaded =>
      this as SeasonTeamDetailsStateLoaded;
}

class SeasonTeamDetailsDriverInfo extends Equatable {
  final String name;
  final String surname;
  final int number;

  const SeasonTeamDetailsDriverInfo({
    required this.name,
    required this.surname,
    required this.number,
  });

  @override
  List<Object?> get props => [name, surname, number];
}
