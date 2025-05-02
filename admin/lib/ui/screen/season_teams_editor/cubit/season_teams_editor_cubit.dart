import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/season_team/season_team_repository.dart';
import '../../../../data/repository/team_basic_info/team_basic_info_repository.dart';
import '../../../../model/season_team.dart';
import '../../../../model/team_basic_info.dart';
import '../../../service/date_service.dart';
import 'season_teams_editor_state.dart';

@injectable
class SeasonTeamsEditorCubit extends Cubit<SeasonTeamsEditorState> {
  final SeasonTeamRepository _seasonTeamRepository;
  final TeamBasicInfoRepository _teamBasicInfoRepository;
  final DateService _dateService;
  StreamSubscription<_ListenedParams>? _listener;

  SeasonTeamsEditorCubit(
    this._seasonTeamRepository,
    this._teamBasicInfoRepository,
    this._dateService,
  ) : super(const SeasonTeamsEditorState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    final int currentSeason = _dateService.getNow().year;
    _listener = _getListenedParams(currentSeason).listen((
      _ListenedParams params,
    ) {
      final List<TeamBasicInfo> sortedAllTeamsFromSeasonBasicInfo = [
        ..._mapSeasonTeamsToTeamsBasicInfo(
          params.allTeamsFromSeason,
          params.allTeamsBasicInfo,
        ),
      ];
      sortedAllTeamsFromSeasonBasicInfo.sortByTeamName();
      emit(
        state.copyWith(
          status: SeasonTeamsEditorStateStatus.completed,
          currentSeason: currentSeason,
          selectedSeason: state.selectedSeason ?? currentSeason,
          teamsFromSeason: sortedAllTeamsFromSeasonBasicInfo,
          areThereOtherTeamsToAdd: _areThereOtherTeamsNotAddedToSeason(params),
        ),
      );
    });
  }

  void onSeasonSelected(int season) {
    final int? currentSeason = state.currentSeason;
    assert(currentSeason != null);
    assert(season == currentSeason || season == currentSeason! + 1);
    _listener?.cancel();
    _listener = _getListenedParams(season).listen((_ListenedParams params) {
      final List<TeamBasicInfo> sortedAllTeamsFromSeasonBasicInfo = [
        ..._mapSeasonTeamsToTeamsBasicInfo(
          params.allTeamsFromSeason,
          params.allTeamsBasicInfo,
        ),
      ];
      sortedAllTeamsFromSeasonBasicInfo.sortByTeamName();
      emit(
        state.copyWith(
          status: SeasonTeamsEditorStateStatus.completed,
          teamsFromSeason: sortedAllTeamsFromSeasonBasicInfo,
          selectedSeason: season,
          areThereOtherTeamsToAdd: _areThereOtherTeamsNotAddedToSeason(params),
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
            .firstWhere((seasonTeam) => seasonTeam.teamId == teamId)
            .id;
    await _seasonTeamRepository.delete(
      season: state.selectedSeason!,
      seasonTeamId: idOfSeasonTeamToDelete,
    );
    emit(
      state.copyWith(status: SeasonTeamsEditorStateStatus.seasonTeamDeleted),
    );
  }

  Stream<_ListenedParams> _getListenedParams(int season) {
    return Rx.combineLatest2(
      _seasonTeamRepository.getAllFromSeason(season),
      _teamBasicInfoRepository.getAll(),
      (
        List<SeasonTeam> allTeamsFromSeason,
        List<TeamBasicInfo> allTeamsBasicInfo,
      ) => (
        allTeamsFromSeason: allTeamsFromSeason,
        allTeamsBasicInfo: allTeamsBasicInfo,
      ),
    );
  }

  List<TeamBasicInfo> _mapSeasonTeamsToTeamsBasicInfo(
    List<SeasonTeam> seasonTeams,
    List<TeamBasicInfo> allTeamsBasicInfo,
  ) {
    return seasonTeams
        .map(
          (seasonTeam) => allTeamsBasicInfo.firstWhere(
            (teamBasicInfo) => teamBasicInfo.id == seasonTeam.teamId,
          ),
        )
        .toList();
  }

  bool _areThereOtherTeamsNotAddedToSeason(_ListenedParams params) {
    final idsOfTeamsInSeason = params.allTeamsFromSeason.map(
      (team) => team.teamId,
    );
    return params.allTeamsBasicInfo
        .where((team) => !idsOfTeamsInSeason.contains(team.id))
        .isNotEmpty;
  }
}

typedef _ListenedParams =
    ({
      List<SeasonTeam> allTeamsFromSeason,
      List<TeamBasicInfo> allTeamsBasicInfo,
    });

extension _TeamsListExtensions on List<TeamBasicInfo> {
  void sortByTeamName() {
    sort((t1, t2) => t1.name.compareTo(t2.name));
  }
}
