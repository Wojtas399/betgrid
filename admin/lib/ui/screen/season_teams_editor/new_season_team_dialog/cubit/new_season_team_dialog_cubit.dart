import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../data/repository/season_team/season_team_repository.dart';
import '../../../../../data/repository/team_basic_info/team_basic_info_repository.dart';
import '../../../../../model/season_team.dart';
import '../../../../../model/team_basic_info.dart';
import 'new_season_team_dialog_state.dart';

@injectable
class NewSeasonTeamDialogCubit extends Cubit<NewSeasonTeamDialogState> {
  final SeasonTeamRepository _seasonTeamRepository;
  final TeamBasicInfoRepository _teamBasicInfoRepository;
  final int _season;
  StreamSubscription<_ListenedParams>? _listener;

  NewSeasonTeamDialogCubit(
    this._seasonTeamRepository,
    this._teamBasicInfoRepository,
    @factoryParam this._season,
  ) : super(const NewSeasonTeamDialogState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener = _getListenedParams().listen((_ListenedParams params) {
      emit(
        state.copyWith(
          status: NewSeasonTeamDialogStateStatus.completed,
          teamsToSelect: _selectAvailableTeams(params),
        ),
      );
    });
  }

  void onTeamSelected(String teamId) {
    emit(
      state.copyWith(
        status: NewSeasonTeamDialogStateStatus.completed,
        selectedTeamId: teamId,
      ),
    );
  }

  Future<void> submit() async {
    assert(state.selectedTeamId?.isNotEmpty == true);
    emit(state.copyWith(status: NewSeasonTeamDialogStateStatus.loading));
    await _seasonTeamRepository.add(
      season: _season,
      teamId: state.selectedTeamId!,
    );
    emit(
      state.copyWith(
        status: NewSeasonTeamDialogStateStatus.teamAddedToSeason,
        selectedTeamId: null,
      ),
    );
  }

  Stream<_ListenedParams> _getListenedParams() {
    return Rx.combineLatest2(
      _seasonTeamRepository.getAllFromSeason(_season),
      _teamBasicInfoRepository.getAll(),
      (
        List<SeasonTeam> allTeamsFromSeason,
        List<TeamBasicInfo> allTeamsBasicInfo,
      ) => (
        teamsFromSeason: allTeamsFromSeason,
        allTeamsBasicInfo: allTeamsBasicInfo,
      ),
    );
  }

  List<TeamBasicInfo> _selectAvailableTeams(_ListenedParams params) {
    final idsOfTeamsFromSeason = params.teamsFromSeason.map(
      (SeasonTeam seasonTeam) => seasonTeam.teamId,
    );
    return params.allTeamsBasicInfo
        .where((TeamBasicInfo team) => !idsOfTeamsFromSeason.contains(team.id))
        .toList();
  }
}

typedef _ListenedParams =
    ({List<SeasonTeam> teamsFromSeason, List<TeamBasicInfo> allTeamsBasicInfo});
