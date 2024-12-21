import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/team_basic_info.dart';
import '../../firebase/service/firebase_team_basic_info_service.dart';
import '../../mapper/team_basic_info_mapper.dart';
import '../repository.dart';
import 'team_basic_info_repository.dart';

@LazySingleton(as: TeamBasicInfoRepository)
class TeamBasicInfoRepositoryImpl extends Repository<TeamBasicInfo>
    implements TeamBasicInfoRepository {
  final FirebaseTeamBasicInfoService _firebaseTeamBasicInfoService;
  final TeamBasicInfoMapper _teamBasicInfoMapper;
  final _getTeamByIdMutex = Mutex();

  TeamBasicInfoRepositoryImpl(
    this._firebaseTeamBasicInfoService,
    this._teamBasicInfoMapper,
  );

  @override
  Stream<TeamBasicInfo?> getTeamBasicInfoById(String id) async* {
    bool didRelease = false;
    await _getTeamByIdMutex.acquire();
    await for (final allTeams in repositoryState$) {
      TeamBasicInfo? matchingTeamBasicInfo = allTeams.firstWhereOrNull(
        (teamBasicInfo) => teamBasicInfo.id == id,
      );
      matchingTeamBasicInfo ??= await _fetchTeamBasicInfoById(id);
      if (_getTeamByIdMutex.isLocked && !didRelease) {
        _getTeamByIdMutex.release();
        didRelease = true;
      }
      yield matchingTeamBasicInfo;
    }
  }

  Future<TeamBasicInfo?> _fetchTeamBasicInfoById(String id) async {
    final teamBasicInfoDto =
        await _firebaseTeamBasicInfoService.fetchTeamBasicInfoById(id);
    if (teamBasicInfoDto == null) return null;
    final teamBasicInfo = _teamBasicInfoMapper.mapFromDto(teamBasicInfoDto);
    addEntity(teamBasicInfo);
    return teamBasicInfo;
  }
}
