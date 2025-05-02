import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/season_team/season_team_repository.dart';
import '../../../../model/season_team.dart';
import '../../../common_cubit/season_cubit.dart';
import 'season_teams_state.dart';

@injectable
class SeasonTeamsCubit extends Cubit<SeasonTeamsState> {
  final SeasonTeamRepository _seasonTeamRepository;
  final SeasonCubit _seasonCubit;
  StreamSubscription<List<SeasonTeam>>? _seasonTeamsSubscription;

  SeasonTeamsCubit(this._seasonTeamRepository, @factoryParam this._seasonCubit)
    : super(const SeasonTeamsState.initial());

  @override
  Future<void> close() {
    _seasonTeamsSubscription?.cancel();
    return super.close();
  }

  void initialize() {
    final int currentSeason = _seasonCubit.state;
    _seasonTeamsSubscription = _seasonTeamRepository
        .getAllFromSeason(currentSeason)
        .listen(_manageUpdatedTeams);
  }

  void _manageUpdatedTeams(List<SeasonTeam> teams) {
    final List<SeasonTeam> sortedTeams = [...teams]
      ..sort((team1, team2) => team1.shortName.compareTo(team2.shortName));
    emit(SeasonTeamsStateLoaded(teams: sortedTeams));
  }
}
