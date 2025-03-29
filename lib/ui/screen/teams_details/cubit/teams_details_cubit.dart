import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/season_team/season_team_repository.dart';
import '../../../../model/season_team.dart';
import '../../../common_cubit/season_cubit.dart';
import 'teams_details_state.dart';

@injectable
class TeamsDetailsCubit extends Cubit<TeamsDetailsState> {
  final SeasonTeamRepository _seasonTeamRepository;
  final SeasonCubit _seasonCubit;
  StreamSubscription<List<SeasonTeam>>? _seasonTeamsSubscription;

  TeamsDetailsCubit(this._seasonTeamRepository, @factoryParam this._seasonCubit)
    : super(const TeamsDetailsState.initial());

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
    emit(TeamsDetailsStateLoaded(teams: teams));
  }
}
