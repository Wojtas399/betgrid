import 'package:betgrid_shared/firebase/model/season_team_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_team_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/season_team.dart';
import '../../mapper/season_team_mapper.dart';
import '../repository.dart';
import 'season_team_repository.dart';

@LazySingleton(as: SeasonTeamRepository)
class SeasonTeamRepositoryImpl extends Repository<SeasonTeam>
    implements SeasonTeamRepository {
  final FirebaseSeasonTeamService _fireSeasonTeamService;
  final SeasonTeamMapper _seasonTeamMapper;
  final _getByIdMutex = Mutex();

  SeasonTeamRepositoryImpl(this._fireSeasonTeamService, this._seasonTeamMapper);

  @override
  Stream<SeasonTeam?> getById({
    required String id,
    required int season,
  }) async* {
    bool didRelease = false;
    await _getByIdMutex.acquire();
    await for (final allEntities in repositoryState$) {
      SeasonTeam? matchingEntity = allEntities.firstWhereOrNull(
        (entity) => entity.id == id && entity.season == season,
      );

      matchingEntity ??= await _fetchById(id, season);

      if (_getByIdMutex.isLocked && !didRelease) {
        _getByIdMutex.release();
        didRelease = true;
      }

      yield matchingEntity;
    }
  }

  @override
  Stream<List<SeasonTeam>> getAllFromSeason(int season) async* {
    await _fetchAllFromSeason(season);
    await for (final entities in repositoryState$) {
      yield entities.where((entity) => entity.season == season).toList();
    }
  }

  Future<SeasonTeam?> _fetchById(String id, int season) async {
    final SeasonTeamDto? dto = await _fireSeasonTeamService.fetchById(
      id: id,
      season: season,
    );
    if (dto == null) return null;
    final SeasonTeam entity = _seasonTeamMapper.mapFromDto(dto);
    addEntity(entity);
    return entity;
  }

  Future<void> _fetchAllFromSeason(int season) async {
    final dtos = await _fireSeasonTeamService.fetchAllTeamsFromSeason(season);
    final entities =
        dtos.map((dto) => _seasonTeamMapper.mapFromDto(dto)).toList();
    addOrUpdateEntities(entities);
  }
}
