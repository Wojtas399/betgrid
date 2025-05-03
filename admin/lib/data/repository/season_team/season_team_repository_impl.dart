import 'package:betgrid_shared/betgrid_shared.dart';
import 'package:betgrid_shared/firebase/model/season_team_dto.dart';
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
  final FirebaseStorageService _fireStorageService;
  final SeasonTeamMapper _seasonTeamMapper;
  final _getByIdMutex = Mutex();

  SeasonTeamRepositoryImpl(
    this._fireSeasonTeamService,
    this._fireStorageService,
    this._seasonTeamMapper,
  );

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
    await for (final allTeams in repositoryState$) {
      yield allTeams.where((team) => team.season == season).toList();
    }
  }

  @override
  Future<void> add({
    required int season,
    required String shortName,
    required String fullName,
    required String teamChief,
    required String technicalChief,
    required String chassis,
    required String powerUnit,
    required String baseHexColor,
    required String logoImgPath,
    required String carImgPath,
  }) async {
    //TODO
    // final SeasonTeamDto? addedSeasonTeamDto = await _firebaseSeasonTeamService
    //     .add(
    //       season: season,
    //       shortName: shortName,
    //       fullName: fullName,
    //       teamChief: teamChief,
    //       technicalChief: technicalChief,
    //       chassis: chassis,
    //       powerUnit: powerUnit,
    //       baseHexColor: baseHexColor,
    //       logoImgName: logoImgName,
    //       carImgName: carImgName,
    //     );
    // if (addedSeasonTeamDto != null) {
    //   final SeasonTeam addedSeasonTeam = _seasonTeamMapper.mapFromDto(
    //     addedSeasonTeamDto,
    //     logoImgName,
    //     carImgName,
    //   );
    //   addEntity(addedSeasonTeam);
    // }
  }

  @override
  Future<void> delete({
    required int season,
    required String seasonTeamId,
  }) async {
    await _fireSeasonTeamService.delete(
      season: season,
      seasonTeamId: seasonTeamId,
    );
    deleteEntity(seasonTeamId);
  }

  Future<SeasonTeam?> _fetchById(String id, int season) async {
    final SeasonTeamDto? dto = await _fireSeasonTeamService.fetchById(
      id: id,
      season: season,
    );
    if (dto == null) return null;

    final SeasonTeam entity = await _mapSeasonTeamFromDto(dto);
    addEntity(entity);

    return entity;
  }

  Future<void> _fetchAllFromSeason(int season) async {
    final dtos = await _fireSeasonTeamService.fetchAllTeamsFromSeason(season);

    final List<SeasonTeam> entities = [];
    for (final dto in dtos) {
      final SeasonTeam entity = await _mapSeasonTeamFromDto(dto);
      entities.add(entity);
    }

    addOrUpdateEntities(entities);
  }

  Future<SeasonTeam> _mapSeasonTeamFromDto(SeasonTeamDto dto) async {
    final String? logoImgUrl = await _fireStorageService.fetchTeamLogoImgUrl(
      season: dto.season,
      teamLogoImgFileName: dto.logoImgName,
    );
    final String? carImgUrl = await _fireStorageService.fetchCarImgUrl(
      season: dto.season,
      carImgFileName: dto.carImgName,
    );

    if (logoImgUrl == null || carImgUrl == null) {
      throw Exception('Failed to fetch logo or car image');
    }

    return _seasonTeamMapper.mapFromDto(dto, logoImgUrl, carImgUrl);
  }
}
