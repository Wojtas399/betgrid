import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/season_team/season_team_repository.dart';
import '../../../../model/season_team.dart';
import '../../../service/date_service.dart';
import 'season_teams_editor_state.dart';

@injectable
class SeasonTeamsEditorCubit extends Cubit<SeasonTeamsEditorState> {
  final SeasonTeamRepository _seasonTeamRepository;
  final DateService _dateService;
  StreamSubscription<List<SeasonTeam>>? _seasonTeamsSubscription;

  SeasonTeamsEditorCubit(this._seasonTeamRepository, this._dateService)
    : super(const SeasonTeamsEditorState());

  @override
  Future<void> close() {
    _seasonTeamsSubscription?.cancel();
    return super.close();
  }

  void initialize() {
    final int currentSeason = _dateService.getNow().year;
    _seasonTeamsSubscription = _seasonTeamRepository
        .getAllFromSeason(currentSeason)
        .listen((List<SeasonTeam> seasonTeams) {
          final List<SeasonTeam> sortedTeams = [...seasonTeams]
            ..sortByShortName();
          emit(
            state.copyWith(
              status: SeasonTeamsEditorStateStatus.completed,
              currentSeason: currentSeason,
              selectedSeason: state.selectedSeason ?? currentSeason,
              teamsFromSeason: sortedTeams,
            ),
          );
        });
  }

  void onSeasonSelected(int season) {
    final int? currentSeason = state.currentSeason;
    assert(currentSeason != null);
    assert(season == currentSeason || season == currentSeason! + 1);
    _seasonTeamsSubscription?.cancel();
    _seasonTeamsSubscription = _seasonTeamRepository
        .getAllFromSeason(season)
        .listen((List<SeasonTeam> seasonTeams) {
          final List<SeasonTeam> sortedTeams = [...seasonTeams]
            ..sortByShortName();
          emit(
            state.copyWith(
              status: SeasonTeamsEditorStateStatus.completed,
              teamsFromSeason: sortedTeams,
              selectedSeason: season,
            ),
          );
        });
  }

  Future<void> deleteTeamFromSeason(String teamId) async {
    assert(teamId.isNotEmpty && state.selectedSeason != null);
    emit(state.copyWith(status: SeasonTeamsEditorStateStatus.loading));
    final List<SeasonTeam> allTeamsFromSeason =
        await _seasonTeamRepository
            .getAllFromSeason(state.selectedSeason!)
            .first;
    final String idOfSeasonTeamToDelete =
        allTeamsFromSeason
            .firstWhere((seasonTeam) => seasonTeam.id == teamId)
            .id;
    await _seasonTeamRepository.delete(
      season: state.selectedSeason!,
      seasonTeamId: idOfSeasonTeamToDelete,
    );
    emit(
      state.copyWith(status: SeasonTeamsEditorStateStatus.seasonTeamDeleted),
    );
  }
}

extension _TeamsListExtensions on List<SeasonTeam> {
  void sortByShortName() {
    sort((t1, t2) => t1.shortName.compareTo(t2.shortName));
  }
}
