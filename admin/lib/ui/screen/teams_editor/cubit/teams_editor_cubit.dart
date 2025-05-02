import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository/team_basic_info/team_basic_info_repository.dart';
import '../../../../model/team_basic_info.dart';
import 'teams_editor_state.dart';

@injectable
class TeamsEditorCubit extends Cubit<TeamsEditorState> {
  final TeamBasicInfoRepository _teamBasicInfoRepository;
  StreamSubscription<List<TeamBasicInfo>>? _teamsSubscription;

  TeamsEditorCubit(this._teamBasicInfoRepository)
    : super(const TeamsEditorState());

  @override
  Future<void> close() {
    _teamsSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _teamsSubscription = _teamBasicInfoRepository.getAll().listen((
      List<TeamBasicInfo> teams,
    ) {
      emit(
        state.copyWith(status: TeamsEditorStateStatus.completed, teams: teams),
      );
    });
  }

  Future<void> deleteTeam(String id) async {
    assert(id.isNotEmpty);
    emit(state.copyWith(status: TeamsEditorStateStatus.loading));
    await _teamBasicInfoRepository.deleteById(id);
    emit(state.copyWith(status: TeamsEditorStateStatus.teamDeleted));
  }
}
