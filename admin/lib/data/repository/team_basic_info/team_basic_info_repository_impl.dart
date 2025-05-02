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
  final FirebaseTeamBasicInfoService _firebaseTeamBasicInfoService;
  final TeamBasicInfoMapper _teamBasicInfoMapper;
  final _getByIdMutex = Mutex();

  TeamBasicInfoRepositoryImpl(
    this._firebaseTeamBasicInfoService,
    this._teamBasicInfoMapper,
  );

  @override
  Stream<List<TeamBasicInfo>> getAll() async* {
    await _fetchAll();
    await for (final allTeamsBasicInfo in repositoryState$) {
      yield allTeamsBasicInfo;
    }
  }

  @override
  Stream<TeamBasicInfo?> getById(String id) async* {
    bool didRelease = false;
    await _getByIdMutex.acquire();
    await for (final allTeamsBasicInfo in repositoryState$) {
      TeamBasicInfo? matchingTeamBasicInfo = allTeamsBasicInfo.firstWhereOrNull(
        (teamBasicInfo) => teamBasicInfo.id == id,
      );
      matchingTeamBasicInfo ??= await _fetchById(id);
      if (_getByIdMutex.isLocked && !didRelease) {
        _getByIdMutex.release();
        didRelease = true;
      }
      yield matchingTeamBasicInfo;
    }
  }

  @override
  Future<void> add({required String name, required String hexColor}) async {
    final TeamBasicInfoDto? addedTeamBasicInfoDto =
        await _firebaseTeamBasicInfoService.add(name: name, hexColor: hexColor);
    if (addedTeamBasicInfoDto != null) {
      final TeamBasicInfo addedTeamBasicInfo = _teamBasicInfoMapper.mapFromDto(
        addedTeamBasicInfoDto,
      );
      addEntity(addedTeamBasicInfo);
    }
  }

  @override
  Future<void> deleteById(String id) async {
    await _firebaseTeamBasicInfoService.deleteById(id);
    deleteEntity(id);
  }

  Future<void> _fetchAll() async {
    final Iterable<TeamBasicInfoDto> dtos =
        await _firebaseTeamBasicInfoService.fetchAll();
    if (dtos.isNotEmpty) {
      final Iterable<TeamBasicInfo> entities = dtos.map(
        _teamBasicInfoMapper.mapFromDto,
      );
      addOrUpdateEntities(entities);
    }
  }

  Future<TeamBasicInfo?> _fetchById(String id) async {
    final TeamBasicInfoDto? dto = await _firebaseTeamBasicInfoService.fetchById(
      id,
    );
    if (dto == null) return null;
    final TeamBasicInfo entity = _teamBasicInfoMapper.mapFromDto(dto);
    addEntity(entity);
    return entity;
  }
}
