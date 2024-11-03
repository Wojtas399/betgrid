import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/team.dart';
import '../../firebase/service/firebase_team_service.dart';
import '../../mapper/new_team_mapper.dart';
import '../repository.dart';
import 'team_repository.dart';

@LazySingleton(as: TeamRepository)
class TeamRepositoryImpl extends Repository<Team> implements TeamRepository {
  final FirebaseTeamService _firebaseTeamService;
  final NewTeamMapper _teamMapper;
  final _getTeamByIdMutex = Mutex();

  TeamRepositoryImpl(
    this._firebaseTeamService,
    this._teamMapper,
  );

  @override
  Stream<Team?> getTeamById(String id) async* {
    await _getTeamByIdMutex.acquire();
    await for (final allTeams in repositoryState$) {
      Team? matchingTeam = allTeams.firstWhereOrNull((team) => team.id == id);
      matchingTeam ??= await _fetchTeamById(id);
      if (_getTeamByIdMutex.isLocked) {
        _getTeamByIdMutex.release();
      }
      yield matchingTeam;
    }
  }

  Future<Team?> _fetchTeamById(String id) async {
    final teamDto = await _firebaseTeamService.fetchTeamById(id);
    if (teamDto == null) return null;
    final team = _teamMapper.mapFromDto(teamDto);
    addEntity(team);
    return team;
  }
}
