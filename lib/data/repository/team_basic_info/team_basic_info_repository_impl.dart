import 'package:betgrid_shared/firebase/model/team_basic_info_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_team_basic_info_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/team_basic_info.dart';
import '../../mapper/team_basic_info_mapper.dart';
import '../repository.dart';
import 'team_basic_info_repository.dart';

@LazySingleton(as: TeamBasicInfoRepository)
class TeamBasicInfoRepositoryImpl extends Repository<TeamBasicInfo>
    implements TeamBasicInfoRepository {
  final FirebaseTeamBasicInfoService _fireTeamBasicInfoService;
  final TeamBasicInfoMapper _teamBasicInfoMapper;
  final _getByIdMutex = Mutex();

  TeamBasicInfoRepositoryImpl(
    this._fireTeamBasicInfoService,
    this._teamBasicInfoMapper,
  );

  @override
  Stream<TeamBasicInfo?> getById(String id) async* {
    bool didRelease = false;
    await _getByIdMutex.acquire();
    await for (final allEntities in repositoryState$) {
      TeamBasicInfo? matchingEntity = allEntities.firstWhereOrNull(
        (entity) => entity.id == id,
      );
      matchingEntity ??= await _fetchById(id);
      if (_getByIdMutex.isLocked && !didRelease) {
        _getByIdMutex.release();
        didRelease = true;
      }
      yield matchingEntity;
    }
  }

  Future<TeamBasicInfo?> _fetchById(String id) async {
    final TeamBasicInfoDto? dto = await _fireTeamBasicInfoService.fetchById(id);
    if (dto == null) return null;
    final TeamBasicInfo entity = _teamBasicInfoMapper.mapFromDto(dto);
    addEntity(entity);
    return entity;
  }
}
